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
use Symbol 'geniosym';

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'exec.pl',
              description => '',
              license     => 'Public Domain',
             );

my @processes = ();
sub get_processes { return @processes }

# the /exec command, nothing to do with the actual command being run.
my $command;
my $command_options;

sub get_new_id {
    my $i = 1;
    foreach my $proc (@processes) {
        if ($proc->{id} != $i) {
            next;
        }
        $i++;
    }
    return $i;
}

sub add_process {
    #my ($pid) = @_;
    my $id = get_new_id();

    my $new = {
               id      => $id,
               pid     => 0,
               in_tag  => 0,
               out_tag => 0,
               err_tag => 0,
               s_in    => geniosym(), #IO::Handle->new,
               s_err   => geniosym(), #IO::Handle->new,
               s_out   => geniosym(), #IO::Handle->new,
               cmd     => '',
               opts    => {},
              };

    # $new->{s_in}->autoflush(1);
    # $new->{s_out}->autoflush(1);
    # $new->{s_err}->autoflush(1);

    push @processes, $new;

    _msg("New process item created: $id");
    return $new;
}

sub find_process_by_id {
    my ($id) = @_;
    my @matches =  grep { $_->{id} == $id } @processes;
    _error("wtf, multiple id matches for $id. BUG") if @matches > 1;

    return $matches[0];

}
sub find_process_by_pid {
    my ($pid) = @_;
    my @matches =  grep { $_->{pid} == $pid } @processes;
    _error("wtf, multiple pid matches for $pid. BUG") if @matches > 1;

    return $matches[0];
}

sub remove_process {
    my ($id, $verbose) = @_;
    my $del_index = 0;
    foreach my $proc (@processes) {
        if ($id == $proc->{id}) {
            last;
        }
        $del_index++;
    }
    print "remove: del index: $del_index";
    if ($del_index <= $#processes) {
        my $dead = splice(@processes, $del_index, 1, ());
        #_msg("removing " . Dumper($dead));

        Irssi::input_remove($dead->{err_tag});
        Irssi::input_remove($dead->{out_tag});

        close $dead->{s_out};
        close $dead->{s_in};
        close $dead->{s_err};

    } else {
        $verbose = 1;
        if ($verbose) {
            print "remove: No such process with ID $id";
        }
    }
}

sub show_current_processes {
    if (@processes == 0) {
        print "No processes running";
        return;
    }
    foreach my $p (@processes) {
        printf("ID: %d, PID: %d, Command: %s", $p->{id}, $p->{pid}, $p->{cmd});
    }
}

sub parse_options {
    my ($args) = @_;
    my @options = Irssi::command_parse_options($command, $args);
    if (@options) {
        my $opt_hash = $options[0];
        my $rest     = $options[1];

        $rest =~ s/^\s*(.*?)\s*$/$1/; # trim surrounding space.

        #print Dumper([$opt_hash, $rest]);
        if (length $rest) {
            return ($opt_hash, $rest);
        } else {
            show_current_processes();
            return ();
        }
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
    my ($rec) = @_;

    #Irssi::timeout_add_once(100, sub { die }, {});

    return unless exists $rec->{cmd};
    drop_privs();

    _msg("Executing command " . join(", ", @{ $rec->{cmd} }));
    my $c = join(" ", @{ $rec->{cmd} });
    my $pid = open3($rec->{s_sin}, $rec->{s_out}, $rec->{s_err}, $c);

    _msg("PID is $pid");
    $rec->{pid} = $pid;

    # _msg("Pid %s, in: %s, out: %s, err: %s, cmd: %s",
    #      $pid, $sin, $sout, $serr, $cmd);

    # _msg("filenos, Pid %s, in: %s, out: %s, err: %s",
    #      $pid, $sin->fileno, $sout->fileno, $serr->fileno);

    if (not defined $pid) {

        _error("open3 failed: $! Aborting");

        close($_) for ($rec->{s_in}, $rec->{s_err}, $rec->{s_out});
        undef($_) for ($rec->{s_in}, $rec->{s_err}, $rec->{s_out});

        return;
    }

    # parent
    if ($pid) {

#    eval {
        print "fileno is " .  fileno($rec->{s_out});
        $rec->{out_tag} = Irssi::input_add( fileno($rec->{s_out}),
                                            Irssi::INPUT_READ,
                                            \&child_output,
                                            $rec);
        #die unless $rec->{out_tag};

        $rec->{err_tag} = Irssi::input_add(fileno($rec->{s_err}),
                                           Irssi::INPUT_READ,
                                           \&child_error,
                                           $rec);
        #die unless $rec->{err_tag};

 #   };


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
    my $rec = shift;

    my $err_fh = $rec->{s_err};

    my $done = 0;

    while (not $done) {
        my $data = '';
        _msg("Stderr: starting sysread");
        my $bytes_read = sysread($err_fh, $data, 256);
        if (not defined $bytes_read) {
            _error("stderr: sysread failed:: $!");
            $done = 1;
        } elsif ($bytes_read == 0) {
            _msg("stderr: sysread got EOF");
            $done = 1;
        } elsif ($bytes_read < 256) {
            # that's all, folks.
            _msg("%%_stderr:%%_ read %d bytes: %s", $bytes_read, $data);
        } else {
            # we maybe need to read some more
            _msg("%%_stderr:%%_ read %d bytes: %s, maybe more", $bytes_read, $data);
        }
    }

    _msg('removing input stderr tag');
    Irssi::input_remove($rec->{err_tag});

}

sub sig_pidwait {
    my ($pidwait, $status) = @_;
    my @matches = grep { $_->{pid} == $pidwait } @processes;
    foreach my $m (@matches) {
        _msg("PID %d has terminated. Status %d (or maybe %d .... %d)",
             $pidwait, $status, $?, ${^CHILD_ERROR_NATIVE} );

        remove_process($m->{id});
    }
}

sub child_output {
    my $rec = shift;
    my $out_fh = $rec->{s_out};

    my $done = 0;

    while (not $done) {
        my $data = '';
        _msg("Stdout: starting sysread");
        my $bytes_read = sysread($out_fh, $data, 256);
        if (not defined $bytes_read) {
            _error("stdout: sysread failed:: $!");
            $done = 1;
        } elsif ($bytes_read == 0) {
            _msg("stdout: sysread got EOF");
            $done = 1;
        } elsif ($bytes_read < 256) {
            # that's all, folks.
            _msg("%%_stdout:%%_ read %d bytes: %s", $bytes_read, $data);
        } else {
            # we maybe need to read some more
            _msg("%%_stdout:%%_ read %d bytes: %s, maybe more", $bytes_read, $data);
        }
    }

    _msg('removing input stdout tag');
    Irssi::input_remove($rec->{out_tag});

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
    Irssi::signal_stop;
    my @options = parse_options($args);

    if (@options) {
        my $rec = add_process();
        my ($options, $cmd) = @options;

        $cmd = [split ' ', $cmd];

        if (not exists $options->{nosh}) {
            unshift @$cmd, ("/bin/sh -c");
        }

        $rec->{opts} = $options;
        $rec->{cmd}  = $cmd;

        do_fork_and_exec($rec)
    }

}

sub cmd_input {
    my ($args) = @_;
    my $rec = $processes[0];    # HACK, make them specify.
    if ($rec->{pid}) {
        print "INput writing to $rec->{pid}";
        my $fh = $rec->{s_in};

        my $ret = syswrite($fh, "$args\n");
        if (not defined $ret) {
            print "Error writing to process $rec->{pid}: $!";
        } else {
            print "Wrote $ret bytes to $rec->{pid}";
        }

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

package Irssi::UI;

{
    no warnings 'redefine';

    sub processes() {
        return Irssi::Script::exec::get_processes();
    }

}

1;
