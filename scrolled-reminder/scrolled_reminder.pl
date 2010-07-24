use strict;
use warnings;

use Irssi;
use Irssi::TextUI;
use Irssi::Irc;

use Data::Dumper;

# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.

#             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

#   0. You just DO WHAT THE FUCK YOU WANT TO.

sub DEBUG () { 1 }

our $VERSION = '0.01';
our %IRSSI =
  (
   authors     => 'Tom Feist',
   contact     => 'shabble+irssi@metavore.org',
   name        => 'scrolled-reminder',
   description => 'Requires confirmation to messages sent'
                  . 'when the current window is scrolled up',

   license     => 'WTFPL; http://sam.zoy.org/wtfpl/',
   url         => 'http://github.com/shabble/shab-irssi-scripts/'
                  . 'tree/master/scrolled-reminder/',
             );

# check we have prompt_info loaded.

sub script_is_loaded {
    my $name = shift;
    print "Checking if $name is loaded" if DEBUG;
    no strict 'refs';
    my $retval = defined %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}

unless (script_is_loaded('prompt_info')) {
    die "This script requires 'prompt_info' in order to work. "
      . "Please load it and try again";
} else {
    scroll_reminder_init();
}

my $permit_pending;
my $pending_input = {};
my $active;

sub scroll_reminder_init {
    $permit_pending = 0;
    $active = 0;
    # we need to be first so we can intercept stuff.
    Irssi::signal_add_first('send text', \&handle_send_text);
    Irssi::signal_add_first('gui key pressed', \&handle_keypress);
}

################################################################

sub handle_send_text {
    my ($text, $server, $win_item) = @_;
    unless ($win_item) {
        # not all windows have window-items (eg: status window)
        return;
    }

    my $window = $win_item->window;
    my $view = $window->view;

    # are we scrolled up?

    # TODO: would be better to check if we're scrolled /and/ there's activity?
    # eg: --more-- is showing?

    if ($view->{bottom} != 1) {

        # have we got a pending line that we've already allowed?
        if ($permit_pending) {

            $pending_input = {};
            $permit_pending = 0;

            # no idea why we need to explicitly continue this time.
            Irssi::signal_continue(@_);

        } else {

            # otherwise, store it and start the confirmation process.
            $pending_input = {
                              text     => $text,
                              server   => $server,
                              win_item => $win_item
                             };

            Irssi::signal_stop;
            require_confirmation();
        }
    }
}

sub handle_keypress {
    my ($key) = @_;

    # would be nicer to add/remove ourselves appropriately, but
    # for odd reasons, that doesn't work.
    return unless $active;

    if ($key == 3) { # Ctrl-c

        # notify, and have it disappear after a second.
        set_prompt('aborted!');
        Irssi::timeout_add_once(1000, sub { set_prompt('') }, undef);

        # stick the input line back into the input buffer for them.
        my $text = $pending_input->{text};
        Irssi::gui_input_set($text);
        Irssi::gui_input_set_pos(length $text);

        # clean up the pending stuff
        $permit_pending = 0;
        $pending_input = {};

        # don't draw the C-c.
        Irssi::signal_stop();


        # and, we don't need the handler to trigger anymore
        $active = 0;

    } elsif ($key == 11) { # Ctrl-k

        # allow this to be reraised and pass through
        # the send text handler.
        $permit_pending = 1;

        # stop the C-k from behaving normally.
        Irssi::signal_stop();

        # and re-raise the signal with stored params.
        Irssi::signal_emit('send text',
                           $pending_input->{text},
                           $pending_input->{server},
                           $pending_input->{win_item});

        # stop the key handler from doing stuff
        $active = 0;
        # and restore the prompt
        set_prompt('');

    } else {

        #TODO: What should the behaviour of other keys be when we're
        # awaiting a response?

        Irssi::signal_stop();
        return;
    }
}

sub require_confirmation {
    # enable the key handler
    $active = 1;
    set_prompt('Scrolled Warning: C-k to confirm, C-c to cancel');
}


sub set_prompt {
    my $msg = shift;
    # add a leading space unless we're trying to clear it entirely.
    $msg = ' ' . $msg if length $msg;
    Irssi::signal_emit('change prompt', $msg);
}
