# LICENCE:
#
# Copyright (c) 2011 Tom Feist <shabble+irssi@metavore.org>
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

# TODO: attempt to create an undo function for short-term history in
# the input-bar.

use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'MIT',
             );

my @undo_list;

sub undo_init {
    Irssi::signal_add_first('gui key pressed' => \&sig_cmd_undo);}
}

sub add_to_undo {
    my ($str, $pos) = @_;

    return unless defined $str and defined $pos;

    my $undo_head = $undo_list[-1];

    if (ref $undo_head) {
        if ($str ne $undo_head->{str} && $pos != $undo_head->{pos}) {
            push @undo_list, { str => $str, pos => $pos };
        }
    } else {
        push @undo_list, { str => $str, pos => $pos };
    }

    # enforce maximum size
    # TODO: make this a setting?

    if (@undo_list > 100) {
        shift @undo_list;
    }
}

sub sig_cmd_undo {
    my ($key) = @_;

    if ($key == 10) {
        @undo_list = ();
        return;
    } elsif ($key != 28) {
        add_to_undo(_input(), _input_pos());
        return;
    }

    Irssi::signal_stop();

    my $prev_state = pop @undo_list;

    if (not defined $prev_state) {
        print "No further undo";
        return;
    }

    _input($prev_state->{str});
    _input_pos($prev_state->{pos});
}

sub _input {
    my ($data) = @_;

    my $current_data = Irssi::parse_special('$L', 0, 0);

    # TODO: set this back up.

    # if ($settings->{utf8}->{value}) {
    #     $current_data = decode_utf8($current_data);
    # }

    if (defined $data) {
        # if ($settings->{utf8}->{value}) {
        #     Irssi::gui_input_set(encode_utf8($data));
        # } else {
        Irssi::gui_input_set($data);
        #}
    } else {
        $data = $current_data;
    }

    return $data;
}

sub _input_pos {
    my ($pos) = @_;
    my $cur_pos = Irssi::gui_input_get_pos();
    if (defined $pos) {
        Irssi::gui_input_set_pos($pos) if $pos != $cur_pos;
    } else {
        $pos = $cur_pos;
    }

    return $pos;
}

undo_init();
