# ABOUT:
#
# This script attempts to prevent you from responding accidentally to long-finished
# conversations if you have scrolled back and are not viewing the current activity
# of the channel.
#
# If you attempt to send a message when you are not at the most recent point in the
# channel buffer, it will intercept the message and offer you a menu of options
# instead.
#
# USAGE:
#
# When scrolled up and sending a message, the subsequent prompt has the following
# options:
#
# * Ctrl-C - cancel sending the message. It remains in your input line, but is not
#            sent to the channel.
# * Ctrl-K - send the message to the channel. The input line is cleared.
# * Space  - Jump to the bottom (most recent) part of the channel buffer.
#            Unlike the first two, this does not cancel the prompt, so it allows
#            you to determine if your message is still appropriate before sending.
#
#
# INSTALL:
#
# This script requires that you have first installed and loaded 'uberprompt.pl'
# Uberprompt can be downloaded from:
#
# http://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl
#
# and follow the instructions at the top of that file for installation.
#
# LICENCE:
#
# Copyright (c) 2010 Tom Feist
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

use strict;
use warnings;

use Irssi;
use Irssi::TextUI;
use Irssi::Irc;

use Data::Dumper;

my $DEBUG_ENABLED = 0;
sub DEBUG () { $DEBUG_ENABLED }

our $VERSION = '0.01';
our %IRSSI =
  (
   authors     => 'Tom Feist',
   contact     => 'shabble+irssi@metavore.org',
   name        => 'scrolled-reminder',
   description => 'Requires confirmation to messages sent'
                  . 'when the current window is scrolled up',

   license     => 'MIT',
   url         => 'http://github.com/shabble/irssi-scripts/'
                  . 'tree/master/scrolled-reminder/',
             );

# check we have prompt_info loaded.

sub script_is_loaded {
    return exists($Irssi::Script::{$_[0] . '::'}) ;
}

unless (script_is_loaded('uberprompt')) {
    die "This script requires the 'uberprompt.pl' script in order to work. "
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

    Irssi::settings_add_bool('scrollminder', 'scrollminder_debug', 0);

    # we need to be first so we can intercept stuff.
    Irssi::signal_add_first('send text', \&handle_send_text);
    Irssi::signal_add_first('gui key pressed', \&handle_keypress);
    Irssi::signal_add('setup changed' => \&setup_changed);

    setup_changed();
}

sub setup_changed {
    $DEBUG_ENABLED = Irssi::settings_get_bool('scrollminder_debug');
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

    } elsif ($key == 32) {

        $pending_input->{win_item}->command("scrollback end");

        set_prompt('Scrolled Alert: C-k confirms, C-c cancels');

        Irssi::signal_stop();

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
    set_prompt('Scrolled Alert: C-k confirms, C-c cancels, SPC goes to end of buffer');
}


sub set_prompt {
    my $msg = shift;
    # add a leading space unless we're trying to clear it entirely.
    $msg = ' ' . $msg if length $msg;
    Irssi::signal_emit('change prompt', $msg, 'UP_INNER');
}
