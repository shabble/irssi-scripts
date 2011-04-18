# DOCUMENTATION:
#
# 
#
#
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
              name        => 'kill-ring',
              description => 'keeps track of changes to the cutbuffer'
                             . ' and allows you to cycle through them',
              license     => 'MIT',
              updated     => '$DATE'
             );

my @cut_buf_history;

sub cut_buffer_init {
    Irssi::signal_add_first('gui key pressed' => \&sig_cmd_undo);
    Irssi::command_bind('cut_buf_cycle' => \&cmd_cut_buf_cycle);
}

sub add_to_history {
    my ($str) = @_;

    return unless defined $str;

    my $head = $cut_buf_history[-1];

    if (defined $head and $str ne $head) {
        push @cut_buf_history, $str;
    } elsif (not defined $head) {
        push @cut_buf_history, $str;
    }

    # enforce maximum size
    # TODO: make this a setting?

    if (@cut_buf_history > 100) {
        shift @cut_buf_history;
    }
}

sub cmd_cut_buf_cycle {
    print '%_Cut buffer contains:%_';
    foreach my $buf (@cut_buf_history) {
        print "$buf"
   }
}

sub sig_cmd_undo {
    my ($key) = @_;
    add_to_history(_cut_buf());
}

sub _cut_buf {
    return Irssi::parse_special('$U', 0, 0);
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

cut_buffer_init();
