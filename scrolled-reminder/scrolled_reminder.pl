use strict;
use warnings;

use Irssi;
use Irssi::TextUI;
use Irssi::Irc;

use Data::Dumper;

our $VERSION = '0.01';
our %IRSSI = (
              authors     => 'Tom Feist',
              contact     => 'shabble@cowu.be',
              name        => 'scrolled-reminder',
              description => 'Requires confirmation to messages sent'
              . 'when the current window is scrolled up',

              license     => 'WTFPL; http://sam.zoy.org/wtfpl/',
              url         => 'http://metavore.org/',
             );


sub handle_send_text {
    my ($text, $server_tag, $win_item) = @_;
    unless ($win_item) {
        # not all windows have window-items (eg: status window)
        return;
    }

    my $window = $win_item->window;
    my $view = $window->view;

    if ($view->{bottom} != 1) {
        # we're scrolled up.
        unless (require_confirmation($window)) {
            Irssi::signal_stop;
        }
    }
}

sub handle_keypress {
    my ($key) = @_;
    Irssi::print("key pressed: " . $key);
    if ($key == 3) { # Ctrl-c
    } elsif ($key == 11) { # Ctrl-k
    } else {
    }

    Irssi::signal_remove('gui key pressed', \&handle_keypress);
}

sub require_confirmation {
    my ($window) = @_;
    Irssi::signal_add_first('gui key pressed', \&handle_keypress);

    $window->print("You are scrolled up Really send?");
    write_to_prompt($window, 'Press Ctrl-K to confirm, Ctrl-C to cancel ');
}

sub write_to_prompt {
    my ($window, $msg) = @_;
    #$window->command("insert_text $msg");

}

Irssi::signal_add_first('send text', 'handle_send_text');

