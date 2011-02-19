#!/usr/bin/env perl

use warnings;
use strict;

sub PROGRAM () { "/opt/stow/repo/irssi-debug/bin/irssi" }
use POSIX;

use POE qw( Wheel::ReadWrite Wheel::Run Filter::Stream );
use Term::VT102;
use Term::TermInfo;
use feature qw/say switch/;
use Data::Dumper;

use Term::Size;

my ($columns, $rows) = Term::Size::chars *STDOUT{IO};

my $logfile = "irssi.log";
open my $logfh, ">", $logfile or die "Couldn't open $logfile for writing: $!";


my $ti = Term::Terminfo->new();

my $vt = Term::VT102->new(rows => $rows, cols => $columns);

$vt->callback_set(OUTPUT    => \&vt_output,    undef);
$vt->callback_set(ROWCHANGE => \&vt_rowchange, undef);
$vt->callback_set(CLEAR     => \&vt_clear,     undef);
$vt->callback_set(SCROLL_DOWN => \&vt_scr_dn,  undef);
$vt->callback_set(SCROLL_UP   => \&vt_scr_up,  undef);
$vt->callback_set(GOTO        => \&vt_goto,    undef);

$vt->option_set(LINEWRAP => 1);
$vt->option_set(LFTOCRLF => 1);

sub vt_output {
    my ($vt, $cb_name, $cb_data, $priv_data) = @_;
    say $logfh "OUTPUT: " . Dumper(\@_);
}


sub vt_rowchange {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    #say $logfh "ROWCHANGE: " . Dumper(\@_);
    say $logfh "Row $arg1 changed: ";
    say $logfh $vt->row_plaintext($arg1);
#    print $ti->getstr("clear");
 #   print vt_dump();

}

sub vt_clear {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "VT Cleared";
}
sub vt_scr_dn {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "Scroll Down";
}
sub vt_scr_up {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "Scroll Up";
}
sub vt_goto {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "Goto: $arg1, $arg2";
}

sub vt_dump {
    my $str = '';
    for my $y (1..24) {
        $str .= $vt->row_sgrtext($y) . "\n";
    }
    return $str;
}

### Handle the _start event.  This sets things in motion.
sub handle_start {
  my ($kernel, $heap) = @_[KERNEL, HEAP];

  save_term_settings($heap);

  # Set a signal handler.
  $kernel->sig(CHLD => "got_sigchld");

  make_raw();

  # Start the terminal reader/writer.
  $heap->{stdio} = POE::Wheel::ReadWrite->new(
    InputHandle  => \*STDIN,
    OutputHandle => \*STDOUT,
    InputEvent   => "got_terminal_stdin",
    Filter       => POE::Filter::Stream->new(),
  );

  # Start the asynchronous child process.
  $heap->{program} = POE::Wheel::Run->new(
    Program     => PROGRAM,
    Conduit     => "pty",
    StdoutEvent => "got_child_stdout",
    StdioFilter => POE::Filter::Stream->new(),
  );
}

### Handle the _stop event.  This restores the original terminal
### settings when we're done.  That's very important.
sub handle_stop {
  my $heap = $_[HEAP];
  $heap->{stdin_tio}->setattr(0,  TCSANOW);
  $heap->{stdout_tio}->setattr(1, TCSANOW);
  $heap->{stderr_tio}->setattr(2, TCSANOW);
}

### Handle terminal STDIN.  Send it to the background program's STDIN.
### If the user presses ^C, then echo a little string

sub handle_terminal_stdin {
  my ($heap, $input) = @_[HEAP, ARG0];
  if ($input =~ m/\003/g) {
      $input = "/echo I like cakes\n";
  } elsif ($input =~ m/\004/g) {
      say $logfh vt_dump();
  }
  $heap->{program}->put($input);
}

### Handle STDOUT from the child program.
sub handle_child_stdout {
  my ($heap, $input) = @_[HEAP, ARG0];
  # process via vt
  $vt->process($input);
  # send to terminal
  $heap->{stdio}->put($input);
}

### Handle SIGCHLD.  Shut down if the exiting child process was the
### one we've been managing.

sub handle_sigchld {
  my ($heap, $child_pid) = @_[HEAP, ARG1];
  if ($child_pid == $heap->{program}->PID) {
    delete $heap->{program};
    delete $heap->{stdio};
  }
  return 0;
}


### Start a session to encapsulate the previous features.
POE::Session->create(
  inline_states => {
    _start             => \&handle_start,
    _stop              => \&handle_stop,
    got_terminal_stdin => \&handle_terminal_stdin,
    got_child_stdout   => \&handle_child_stdout,
    got_sigchld        => \&handle_sigchld,
  },
);


sub make_raw {

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

sub save_term_settings {
    my ($heap) = @_;
    # Save the original terminal settings so they can be restored later.
    $heap->{stdin_tio} = POSIX::Termios->new();
    $heap->{stdin_tio}->getattr(0);
    $heap->{stdout_tio} = POSIX::Termios->new();
    $heap->{stdout_tio}->getattr(1);
    $heap->{stderr_tio} = POSIX::Termios->new();
    $heap->{stderr_tio}->getattr(2);
}

### Start POE's main loop, which runs the session until it's done.
$poe_kernel->run();
exit 0;
