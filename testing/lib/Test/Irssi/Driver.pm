use strictures 1;

package Test::Irssi::Driver;

use Moose;
use lib $ENV{HOME} . "/projects/poe/lib";

use POE qw( Wheel::ReadWrite Wheel::Run Filter::Stream );
use POSIX;
use feature qw/say/;
use Data::Dump qw/dump/;

has 'parent'
  => (
      is       => 'ro',
      isa      => 'Test::Irssi',
      required => 1,
     );

has 'headless'
  => (
      is      => 'rw',
      isa     => 'Bool',
      default => 0,
     );

sub  START {
    my ($self, $kernel, $heap) = @_[OBJECT, KERNEL, HEAP];

    $kernel->alias_set("IrssiTestDriver");

    $self->log("Start handler called");

    $self->save_term_settings($heap);

    # Set a signal handler.
    $kernel->sig(CHLD => "got_sigchld");

    $self->make_raw_terminal;

    my @stdio_options =
      (
       InputHandle  => \*STDIN,
       OutputHandle => \*STDOUT,
       InputEvent   => "got_terminal_stdin",
       Filter       => POE::Filter::Stream->new(),
      );

    $self->log("stdio options: " . dump(@stdio_options));

    # Start the terminal reader/writer.
    $heap->{stdio} = POE::Wheel::ReadWrite->new(@stdio_options);

    $self->log("Created stdio wheel");

    my $rows = $self->parent->terminal_height;
    my $cols = $self->parent->terminal_width;

    my @program_options =
      (
       Program     => $self->parent->irssi_binary,
       ProgramArgs => ['--noconnect', '--home=' . $self->parent->irssi_homedir ],
       Conduit     => "pty",
       Winsize     => [$rows, $cols, 0, 0],
       StdoutEvent => "got_child_stdout",
       StdioFilter => POE::Filter::Stream->new(),
      );

    $self->log("wheel options: " . dump(@program_options));

    # Start the asynchronous child process.
    $heap->{program} = POE::Wheel::Run->new(@program_options);

    $self->log("Created child run wheel");
    $poe_kernel->yield('testing_ready');
}

sub STOP {
    my ($self, $heap) = @_[OBJECT,HEAP];
    $self->log("STOP called");
    $self->restore_term_settings($heap);
    $self->parent->_logfile_fh->close();

    if (not $self->parent->generate_tap) {
        $self->parent->summarise_test_results();
    }
}

### Handle terminal STDIN.  Send it to the background program's STDIN.
### If the user presses ^C, then echo a little string

sub terminal_stdin {
    my ($self, $heap, $input) = @_[OBJECT, HEAP, ARG0];

    if ($input =~ m/\003/g) { # C-c
        $input = "/echo I like cakes\n";
    } elsif ($input =~ m/\x17/g) { # C-w
        $input = "/quit\n";
    }

    $heap->{program}->put($input);
}

### Handle STDOUT from the child program.
sub child_stdout {
    my ($self, $heap, $input) = @_[OBJECT, HEAP, ARG0];
    # process via vt
    $self->parent->vt->process($input);

    if (not $self->headless) {
        # send to terminal
        $heap->{stdio}->put($input);
    }
}

### Handle SIGCHLD.  Shut down if the exiting child process was the
### one we've been managing.

sub shutdown {
    my ($self, $heap, $kernel) = @_[OBJECT, HEAP, KERNEL];
    $self->log("Shutdown called");
    $heap->{program}->kill(15);
    $kernel->alias_remove("IrssiTestDriver");
}

sub CHILD {
    my ($self, $heap, $child_pid) = @_[OBJECT, HEAP, ARG1];
    if ($child_pid == $heap->{program}->PID) {
        delete $heap->{program};
        delete $heap->{stdio};
    }
    return 0;
}

sub setup {
    my $self = shift;

    my @states =
      (
       object_states =>
       [ $self =>
         {
          _start             => 'START',
          _stop              => 'STOP',
          got_sigchld        => 'CHILD',

          got_terminal_stdin => 'terminal_stdin',
          got_child_stdout   => 'child_stdout',

          got_delay          => 'timer_expired',
          create_delay       => 'timer_created',


          testing_ready      => 'testing_ready',
          test_complete      => 'test_complete',
          execute_test       => 'execute_test',

          shutdown           => 'shutdown',
         }
       ]
      );
    $self->log("creating root session");

    POE::Session->create(@states);
    $self->log("session created");

}

sub testing_ready {
    my ($self) = $_[OBJECT];
    # begin by fetching a test from the pending queue.
    $self->log("Starting to run tests");
    $self->log("-" x 80);
    $self->parent->run_test;
}

sub execute_test {
    my ($self, $heap, $kernel, $test) = @_[OBJECT,HEAP, KERNEL, ARG0];
    # do some stuff here to evaluate it.

    $test->evaluate_test;

}

sub test_complete {
    my ($self, $kernel) = @_[OBJECT, KERNEL];

    $self->parent->complete_test;

    if ($self->parent->tests_remaining) {
        $self->parent->run_test;
    }

    # otherwise, we're done, and can shutdown.
   #kernel->yield('shutdown');

}

sub timer_created {
    my ($self, $heap, $kernel, $duration) = @_[OBJECT, HEAP, KERNEL, ARG0];
    $kernel->delay(got_delay => $duration);
    $self->log("Timer created for $duration");
}

sub timer_expired {
    my ($self, $data) = @_[OBJECT,ARG0];
    $self->log("Timeout invoking test again.");
    $self->parent->active_test->resume_from_timer;
}

sub save_term_settings {
    my ($self, $heap) = @_;
    # Save the original terminal settings so they can be restored later.
    $heap->{stdin_tio} = POSIX::Termios->new();
    $heap->{stdin_tio}->getattr(0);
    $heap->{stdout_tio} = POSIX::Termios->new();
    $heap->{stdout_tio}->getattr(1);
    $heap->{stderr_tio} = POSIX::Termios->new();
    $heap->{stderr_tio}->getattr(2);
}

sub restore_term_settings {
    my ($self, $heap) = @_;

    $heap->{stdin_tio}->setattr (0, TCSANOW);
    $heap->{stdout_tio}->setattr(1, TCSANOW);
    $heap->{stderr_tio}->setattr(2, TCSANOW);
}

sub make_raw_terminal {
    my ($self) = @_;
    # Put the terminal into raw input mode.  Otherwise discrete
    # keystrokes will not be read immediately.
    my $tio = POSIX::Termios->new();
    $tio->getattr(0);
    my $lflag = $tio->getlflag;
    $lflag &= ~(ECHO | ECHOE | ECHOK | ECHONL | ICANON | IEXTEN | ISIG);
    $tio->setlflag($lflag);
    my $iflag = $tio->getiflag;
    $iflag &= ~(BRKINT | INPCK | ISTRIP | IXON);
    $tio->setiflag($iflag);
    my $cflag = $tio->getcflag;
    $cflag &= ~(CSIZE | PARENB);
    $tio->setcflag($cflag);
    $tio->setattr(0, TCSANOW);
}

sub log {
    my ($self, $msg) = @_;
    my $fh = $self->parent->_logfile_fh;
    $fh->say($msg);
}


__PACKAGE__->meta->make_immutable;

no Moose;

