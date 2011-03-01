use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;
use POSIX;
use Time::HiRes qw/sleep/;
use JSON::Any;


our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'test-shim',
              description => '',
              license     => 'Public Domain',
             );


my $forked = 0;

sub pipe_and_fork {
    my ($read_handle, $write_handle);
    pipe($read_handle, $write_handle);

    my $oldfh = select($write_handle);
    $| = 1;
    select $oldfh;

    return if $forked;

    my $pid = fork();

    if (not defined $pid) {
        _error("Can't fork: Aborting");
        close($read_handle);
        close($write_handle);
        return;
    }

    $forked = 1;

    if ($pid > 0) { # this is the parent (Irssi)
        close ($write_handle);
        Irssi::pidwait_add($pid);
        my $job = $pid;
        my $tag;
        my @args = ($read_handle, \$tag, $job);
        $tag = Irssi::input_add(fileno($read_handle),
                                      Irssi::INPUT_READ,
                                      \&child_input,
                                      \@args);

    } else { # child
        child_process($write_handle);
        close $write_handle;

        POSIX::_exit(1);
    }
}
sub _cleanup_child {
    my ($read_handle, $input_tag_ref) = @_;
    close $read_handle;
    Irssi::input_remove($$input_tag_ref);
    _msg("child finished");
    $forked = 0;
}
sub child_input {
    my $args = shift;
    my ($read_handle, $input_tag_ref, $job) = @$args;

    my $input = <$read_handle>;
    my $data = JSON::Any::jsonToObj($input);
    if (ref $data  ne 'HASH') { 
        _error("Invalid data received: $input");
        _cleanup_child($read_handle, $input_tag_ref);
    }

    if (exists $data->{connection}) {
        if ($data->{connection} eq 'close') {
            _cleanup_child($read_handle, $input_tag_ref);
        }
    } else {
        parent_process_response($data);
    }
}

sub parent_process_response {
    my ($data) = @_;
}


sub child_process {
    my ($handle) = @_;

}

sub _error {
    my ($msg) = @_;
    my $win = Irssi::active_win();
    $win->print($msg, Irssi::MSGLEVEL_CLIENTERROR);
}

sub _msg {
    my ($msg) = @_;
    my $win = Irssi::active_win();
    $win->print($msg, Irssi::MSGLEVEL_CLIENTCRAP);
}

Irssi::command_bind("start_pipes", \&pipe_and_fork);
