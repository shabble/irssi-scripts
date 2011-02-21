use strictures 1;

package Test::Irssi::Driver;

use Moose;
use MooseX::POE;
use POE qw( Wheel::ReadWrite Wheel::Run Filter::Stream );
use POSIX;

has 'parent'
  => (
      is => 'ro',
      isa => 'Test::Irssi',
      required => 1,
     );


sub  START {
    my ($self, $kernel, $heap) = @_[OBJECT, KERNEL, HEAP];

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

    # Start the terminal reader/writer.
    $heap->{stdio} = POE::Wheel::ReadWrite->new(@stdio_options);

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

    # Start the asynchronous child process.
    $heap->{program} = POE::Wheel::Run->new(@program_options);
}



sub STOP {
    my ($self, $heap) = @_[OBJECT,HEAP];
    $heap->{stdin_tio}->setattr (0, TCSANOW);
    $heap->{stdout_tio}->setattr(1, TCSANOW);
    $heap->{stderr_tio}->setattr(2, TCSANOW);
    $self->_logfile_fh->close();
}

### Handle terminal STDIN.  Send it to the background program's STDIN.
### If the user presses ^C, then echo a little string

sub handle_terminal_stdin {
    my ($self, $heap, $input) = @_[OBJECT, HEAP, ARG0];
    if ($input =~ m/\003/g) {
        $input = "/echo I like cakes\n";
    } elsif ($input =~ m/\004/g) {
        $self->log( vt_dump());
    }
    $heap->{program}->put($input);
}
##
### Handle STDOUT from the child program.
sub handle_child_stdout {
    my ($self, $heap, $input) = @_[OBJECT, HEAP, ARG0];
    # process via vt
    $self->parent->vt->process($input);
    # send to terminal
    $heap->{stdio}->put($input);
}

### Handle SIGCHLD.  Shut down if the exiting child process was the
### one we've been managing.

sub  CHILD {
    my ($self, $heap, $child_pid) = @_[OBJECT, HEAP, ARG1];
    if ($child_pid == $heap->{program}->PID) {
        delete $heap->{program};
        delete $heap->{stdio};
    }
    return 0;
}

sub bacon { 
    POE::Session->create
        (
         inline_states => {
                           _start             => \&handle_start,
                           _stop              => \&handle_stop,
                           got_terminal_stdin => \&handle_terminal_stdin,
                           got_child_stdout   => \&handle_child_stdout,
                           got_sigchld        => \&handle_sigchld,
                          },
        );
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

