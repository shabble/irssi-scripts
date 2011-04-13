# exec.pl
# a (currently stupid) alternative to the built-in /exec, because it's broken
# on OSX. This thing stll needs a whole bunch of actual features, but for now,
# you can actually run commands.

# Obviously, that's pretty dangerous.  Use at your own risk.

# EXEC [-] [-nosh] [-out | -msg <target> | -notice <target>] [-name <name>] <cmd line>
# EXEC -out | -window | -msg <target> | -notice <target> | -close | -<signal> %<id>
# EXEC -in %<id> <text to send to process>
#
#      -: Don't print "process terminated ..." message
#
#      -nosh: Don't start command through /bin/sh
#
#      -out: Send output to active channel/query
#
#      -msg: Send output to specified nick/channel
#
#      -notice: Send output to specified nick/channel as notices
#
#      -name: Name the process so it could be accessed easier
#
#      -window: Move the output of specified process to active window
#
#      -close: Forcibly close (or "forget") a process that doesn't die.
#              This only removes all information from irssi concerning the
#              process, it doesn't send SIGKILL or any other signal
#              to the process.
#
#      -<signal>: Send a signal to process. <signal> can be either numeric
#                 or one of the few most common ones (hup, term, kill, ...)
#
#      -in: Send text to standard input of the specified process
#
#      -interactive: Creates a query-like window item. Text written to it is
#                    sent to executed process, like /EXEC -in.
#
# Execute specified command in background. Output of process is printed to
# active window by default, but can be also sent as messages or notices to
# specified nick or channel.
#
# Processes can be accessed either by their ID or name if you named it. Process
# identifier must always begin with '%' character, like %0 or %name.
#
# Once the process is started, its output can still be redirected elsewhere with
# the -window, -msg, etc. options. You can send text to standard input of the
# process with -in option.
#
# -close option shouldn't probably be used if there's a better way to kill the
# process. It is meant to remove the processes that don't die even with
# SIGKILL. This option just closes the pipes used to communicate with the
# process and frees all memory it used.
#
# EXEC without any arguments displays the list of started processes.
#



use 5.010;    # 5.10 or above, necessary to get the return value from a command.

use strict;
use warnings;
use English '-no_match_vars';

use Irssi;
use POSIX;
use Time::HiRes qw/sleep/;
use IO::Handle;
use IO::Pipe;
use IPC::Open3;


use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'exec.pl',
              description => '',
              license     => 'Public Domain',
             );


my $forked = 0;

my $command;
my $command_options;


sub parse_options {
    my ($args) = @_;
    my @options = Irssi::command_parse_options($command, $args);
    if (@options) {
        my $opt_hash = $options[0];
        my $rest     = $options[1];

        print Dumper($opt_hash);
        return ($opt_hash, $rest);
    } else {
        _error("Error parsing $command options");
        return ();
    }
}



sub do_fork_and_exec {
    my ($options, $cmd) = @_;

    my $stdout_pipe = IO::Pipe->new;
    my $stderr_pipe = IO::Pipe->new;

#    return if $forked;

    #my $pid = fork();

    if (not defined $pid) {
        _error("Fork failed: $! Aborting");
        $_->close for $stdout_pipe->handles;
        undef $stdout_pipe;
        return;
    }

#    $forked = 1;

    if ($pid > 0) {             # this is the parent (Irssi)
        my $tag;

        Irssi::pidwait_add($pid);

        my $stdout_reader = $stdout_pipe->reader;
        $stdout_reader->autoflush;

        my @args = ($stdout_reader, \$tag, $pid, $cmd, $options);
        $tag = Irssi::input_add($stdout_reader->fileno,
                                Irssi::INPUT_READ,
                                \&child_output,
                                \@args);

    } else {                    # child
        # make up some data - block if we like.
        drop_privs();
        my $stdout_fh = $stdout_pipe->writer;
        $stdout_fh->autoflush;

        my @data = qx/$cmd/;
        my $retval = ${^CHILD_ERROR_NATIVE};

        $stdout_fh->print($_) for @data;

        my $done_str = "__DONE__$retval\n";
        if ($data[$#data] =~ m/\n$/) {
        } else {
            $done_str = "\n" . $done_str;
        }
        $stdout_fh->print($done_str);

        $stdout_fh->close;

        POSIX::_exit(1);
    }
}
sub drop_privs {
    my @temp = ($EUID, $EGID);
    my $orig_uid = $UID;
    my $orig_gid = $GID;
    $EUID = $UID;
    $EGID = $GID;
    # Drop privileges
    $UID = $orig_uid;
    $GID = $orig_gid;
    # Make sure privs are really gone
    ($EUID, $EGID) = @temp;
    die "Can't drop privileges"
      unless $UID == $EUID && $GID eq $EGID;
}

sub child_output {
    my $args = shift;
    my ($stdout_reader, $tag_ref, $pid, $cmd, $options) = @$args;

    my $return_value = 0;

    while (defined(my $data = <$stdout_reader>)) {

        chomp $data;

        # TODO: do we want to remove empty lines?
        #return unless length $data;

        if ($data =~ m/^__DONE__(\d+)$/) {
            $return_value = $1;
            last;
        } else {
            _msg("$data");
        }
    }

    if (not exists $options->{'-'}) {
        _msg("process %d (%s) terminated with return code %d",
             $pid, $cmd, $return_value);
    }

    $stdout_reader->close;
    Irssi::input_remove($$tag_ref);
}

sub _error {
    my ($msg) = @_;
    my $win = Irssi::active_win();
    $win->print($msg, Irssi::MSGLEVEL_CLIENTERROR);
}

sub _msg {
    my ($msg, @params) = @_;
    my $win = Irssi::active_win();
    my $str = sprintf($msg, @params);
    $win->print($str, Irssi::MSGLEVEL_CLIENTCRAP);
}

sub cmd_exec {

    my ($args, $server, $witem) = @_;
    # TODO: parse some options here.
    Irssi::signal_stop;

    my @options = parse_options($args);
    if (@options) {
        do_fork_and_exec(@options)
    }

}

sub exec_init {
    $command = "exec";
    $command_options = join ' ',
      (
       '!-', 'interactive', 'nosh', '+name', '+msg',
       '+notice', 'window', 'close', '+level', 'quiet'
      );

    Irssi::command_bind($command, \&cmd_exec);
    Irssi::command_set_options($command, $command_options);
}

exec_init();
