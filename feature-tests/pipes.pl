use strict;
use warnings;

use Irssi;
use POSIX;
use Time::HiRes qw/sleep/;

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
        # make up some data - block if we like.
        for (1..10) {
            sleep rand 1;
            print $write_handle "Some data: $_\n";
        }
        print $write_handle "__DONE__\n";
        close $write_handle;

        POSIX::_exit(1);
    }
}

sub child_input {
    my $args = shift;
    my ($read_handle, $input_tag_ref, $job) = @$args;

    my $data = <$read_handle>;

    if ($data =~ m/__DONE__/) {
        close($read_handle);
        Irssi::input_remove($$input_tag_ref);
        _msg("child finished");

        $forked = 0;

    } else {
        _msg("Received from child: $data");
    }

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
