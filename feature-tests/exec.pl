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
use Symbol qw/gensym geniosym/;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'exec.pl',
              description => '',
              license     => 'Public Domain',
             );


my $pid = 0;

my $command;
my $command_options;

my ($sin, $serr, $sout) = (new IO::Handle, new IO::Handle, new IO::Handle);
my ($stdout_tag, $stderr_tag);


sub parse_options {
    my ($args) = @_;
    my @options = Irssi::command_parse_options($command, $args);
    if (@options) {
        my $opt_hash = $options[0];
        my $rest     = $options[1];

        $rest =~ s/^\s*(.*?)\s*$/$1/; # trim surrounding space.

        print Dumper([$opt_hash, $rest]);
        return ($opt_hash, $rest);
    } else {
        _error("Error parsing $command options");
        return ();
    }
}

sub schedule_cleanup {
    my $fd = shift;
    Irssi::timeout_add_once(100, sub { $_[0]->close }, $fd);
}

sub do_fork_and_exec {
    my ($options, $cmd) = @_;

    #Irssi::timeout_add_once(100, sub { die }, {});

    return unless $cmd;

    #_msg("type of siin is %s, out is %s, err is %s", ref $sin, ref $sout, ref $serr);

    $sin->autoflush;
    $sout->autoflush;
    $serr->autoflush;

    drop_privs();

    $pid = open3($sin, $sout, $serr, $cmd);

    # _msg("Pid %s, in: %s, out: %s, err: %s, cmd: %s",
    #      $pid, $sin, $sout, $serr, $cmd);

    # _msg("filenos, Pid %s, in: %s, out: %s, err: %s",
    #      $pid, $sin->fileno, $sout->fileno, $serr->fileno);

    if (not defined $pid) {
        _error("open3 failed: $! Aborting");

        $_->close for ($sin, $serr, $sout);
        undef($_) for ($sin, $serr, $sout);

        return;
    }

    # parent
    if ($pid) {


        eval {
            my @out_args = ($sout, $cmd, $options);
            $stdout_tag = Irssi::input_add( $sout->fileno, Irssi::INPUT_READ,
                                            \&child_output, \@out_args);
            die unless $stdout_tag;

            my @err_args = ($serr, $cmd, $options);
            $stderr_tag = Irssi::input_add($serr->fileno, Irssi::INPUT_READ,
                                           \&child_error, \@err_args);
            die unless $stderr_tag;

        };

        Irssi::pidwait_add($pid);

        die "input_add failed to initialise: $@" if $@;
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

sub child_error {
    my $args = shift;
    my ($stderr_reader, $cmd, $options) = @$args;

  read_err_data_loop:
    my $data = '';
    my $bytes_read = sysread($stderr_reader, $data, 256);
    if (not defined $bytes_read) {
        _error("stderr: sysread failed:: $!");

    } elsif ($bytes_read == 0) {
        _msg("stderr: sysread got EOF");

    } elsif ($bytes_read < 256) {
        # that's all, folks.
        _msg("stderr: read %d bytes: %s", $bytes_read, $data);
    } else {
        # we maybe need to read some more
        _msg("stderr: read %d bytes: %s, maybe more", $bytes_read, $data);
        goto read_err_data_loop;
    }

}

sub sig_pidwait {
    my ($pidwait, $status) = @_;
    if ($pidwait == $pid) {
        _msg("PID %d has terminated. Status %d (or maybe %d .... %d)",
             $pidwait, $status, $?, ${^CHILD_ERROR_NATIVE} );
        $pid = 0;

        _msg('removing input stdout tag');
        Irssi::input_remove($stdout_tag);

        _msg('removing input stderr tag');
        Irssi::input_remove($stderr_tag);

    }
}

sub child_output {
    my $args = shift;
    my ($stdout_reader, $tag_ref, $pid, $cmd, $options) = @$args;

    my $return_value = 0;

  read_out_data_loop:
    my $data = '';
    my $bytes_read = sysread($stdout_reader, $data, 256);
    if (not defined $bytes_read) {
        _error("stdout: sysread failed:: $!");

    } elsif ($bytes_read == 0) {
        _msg("stdout: sysread got EOF");

    } elsif ($bytes_read < 256) {
        # that's all, folks.
        _msg("stdout: read %d bytes: %s", $bytes_read, $data);
    } else {
        # we maybe need to read some more
        _msg("stdout: read %d bytes: %s, maybe more", $bytes_read, $data);
        goto read_out_data_loop;
    }

    #schedule_cleanup($stdout_reader);
    #$stdout_reader->close;
}

sub _error {
    my ($msg, @params) = @_;
    my $win = Irssi::active_win();
    my $str = sprintf($msg, @params);
    $win->print($str, Irssi::MSGLEVEL_CLIENTERROR);
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

sub cmd_input {
    my ($args) = @_;
    if ($pid) {
        print $sin "$args\n";
    } else {
        _error("no execs are running to accept input");
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
    Irssi::command_bind('input', \&cmd_input);

    Irssi::signal_add('pidwait', \&sig_pidwait);
}

  exec_init();
