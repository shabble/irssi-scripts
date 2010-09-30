# A script to emulate some of the vi(m) features for the Irssi inputline.
#
# Currently supported features:
#
# * Insert/Command mode. Escape enters command mode.
# * cursor motion with: h l 0 ^ $
# * history motion with j k
# * cursor word motion with: w b e W B E
# * change/delete: c d C D
# * delete at cursor: x
# * replace at cursor: r
# * Insert mode at pos: i a
# * Insert mode at start: I
# * insert mode at end: A
# * yank and paste: y p P
# * switch case: ~
# * repeat change: .
# * change/change/yank line: cc dd yy S
# * Combinations like in Vi, e.g. d5fx
# * window selection: :b<num>, :b#, :b <match-str>
#
# * special registers: "* "+ (contain irssi's cut-buffer)
#
# TODO:
# * History:
#   * /,?,n,N to search through history (like history_search.pl)
# * Undo:
#   * u = undo (how many levels, branching?!)
#   * C-r = redo
# * Window switching (:b)
#  * Tab completion of window(-item) names
#  * non-sequential matches(?)
#  * additional statusbar-item for showing matches
#
# * use irssi settings for some of the features
#  * Done:
#    * vim_mode_utf8 (use utf-8 toggle)
#    * vim_mode_debug (debug prints)
#    * vim_mode_cmd_seq (char that when double-pressed enters cmd mode from ins)
#  * Pending:
#    * ???
#
# WONTFIX - things we're not ever likely to do
# * Macros
#
# Known bugs:
# * multi-line pastes
#
# Installation:
#
# Dependencies:
#
# For proper :ex mode support, requires the installation of prompt_info.pl
#  http://github.com/shabble/irssi-scripts/raw/master/prompt_info/prompt_info.pl
#
# and follow the instructions in the top of that file for installation instructions.
#
# Then, copy into scripts dir, /script load vim_mode.pl ...
#
# Use the following command to get a statusbar item that shows which mode you're
# in.
#
# /statusbar window add vim_mode to get the status.
#
# And the following to let :b name display a list of matching channels
#
# /statusbar window add vim_windows
#
# NOTE: This script is still under heavy development, and there may be bugs.
# Please submit reproducible sequences to the bug-tracker at:
# http://github.com/shabble/irssi-scripts/issues
#
# or contact rudi_s or shabble on irc.freenode.net (#irssi)
#
# LICENCE:
#
# Copyright (c) 2010 Tom Feist & Simon Ruderich
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
#
#
# Have fun!

use strict;
use warnings;

use Encode;
use List::Util;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw


use vars qw($VERSION %IRSSI);
$VERSION = "1.0.1";
%IRSSI =
  (
   authors         => "Tom Feist (shabble), Simon Ruderich (rudi_s)",
   contact         => 'shabble+irssi@metavore.org, '
                    . 'shabble@#irssi/Freenode, simon@ruderich.org'
                    . 'rudi_s@#irssi/Freenode',
   name            => "vim_mode",
   description     => "Give Irssi Vim-like commands for editing the inputline",
   license         => "MIT",
   changed         => "28/9/2010"
  );


# CONSTANTS


sub M_CMD() { 1 } # command mode
sub M_INS() { 0 } # insert mode
sub M_EX () { 2 } # extended mode (after a :?)

# word and non-word regex, when modifiying also update them in setup_changed()
my $word     = qr/[\w_]/o;
my $non_word = qr/[^\w_\s]/o;

# GLOBAL VARIABLES

my $DEBUG_ENABLED = 0;

sub DEBUG { $DEBUG_ENABLED }

# use UTF-8 internally for string calculations/manipulations
my $utf8 = 1;

# buffer to keep track of the last N keystrokes, used for Esc detection and
# insert mode mappings
my @input_buf;
my $input_buf_timer;
my $input_buf_enabled = 0;

# insert mode repeat buffer, used to repeat (.) last insert
my @insert_buf;

# flag to allow us to emulate keystrokes without re-intercepting them
my $should_ignore = 0;

# ex mode buffer
my @ex_buf;

# for commands like 10x
my $numeric_prefix = undef;
# vi operators like d, c, ..
my $operator = undef;
# vi movements, only used when a movement needs more than one key (like f t).
my $movement = undef;
# last vi command, used by .
my $last
  = {
     'char' => 'i', # = i to support . when loading the script
     'numeric_prefix' => undef,
     'operator' => undef,
     'movement' => undef,
     'register' => '"',
    };

# what Vi mode we're in. We start in insert mode.
my $mode = M_INS;

# current active register
my $register = '"';

# vi registers
my $registers
  = {
     '"' => '', # default register
     '+' => '', # contains irssi's cut buffer
     '*' => '', # same
    };
foreach my $char ('a' .. 'z') {
    $registers->{$char} = '';
}

# current imap still pending (first character entered)
my $imap = undef;

# maps for insert mode
my $imaps = {};

# index into the history list (for j,k)
my $history_index = undef;
# current line, necessary for j,k or the current input line gets destroyed
my $history_input = undef;
# position in input line
my $history_pos = 0;

# Undo/redo buffer.
my @undo_buffer;
my $undo_index = undef;

sub script_is_loaded {
    my $name = shift;
    print "Checking if $name is loaded" if DEBUG;
    no strict 'refs';
    my $retval = defined %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}

vim_mode_init();


# vi-operators like d, c; they don't move the cursor
my $operators
  = {
     'c' => { func => \&cmd_operator_c },
     'd' => { func => \&cmd_operator_d },
     'y' => { func => \&cmd_operator_y },
    };

# vi-moves like w,b; they move the cursor and may get combined with an
# operator; also things like i/I are listed here, not entirely correct but
# they work in a similar way
my $movements
  = {
     # arrow like movement
     'h' => { func => \&cmd_movement_h },
     'l' => { func => \&cmd_movement_l },
     ' ' => { func => \&cmd_movement_space },
     'j' => { func => \&cmd_movement_j },
     'k' => { func => \&cmd_movement_k },
     # char movement, take an additional parameter and use $movement
     'f' => { func => \&cmd_movement_f },
     't' => { func => \&cmd_movement_t },
     'F' => { func => \&cmd_movement_F },
     'T' => { func => \&cmd_movement_T },
     # word movement
     'w' => { func => \&cmd_movement_w },
     'b' => { func => \&cmd_movement_b },
     'e' => { func => \&cmd_movement_e },
     'W' => { func => \&cmd_movement_W },
     'B' => { func => \&cmd_movement_B },
     'E' => { func => \&cmd_movement_E },
     # line movement
     '0' => { func => \&cmd_movement_0 },
     '^' => { func => \&cmd_movement_caret },
     '$' => { func => \&cmd_movement_dollar },
     # delete chars
     'x' => { func => \&cmd_movement_x },
     'X' => { func => \&cmd_movement_X },
     # insert mode
     'i' => { func => \&cmd_movement_i },
     'I' => { func => \&cmd_movement_I },
     'a' => { func => \&cmd_movement_a },
     'A' => { func => \&cmd_movement_A },
     # replace mode
     'r' => { func => \&cmd_movement_r },
     # paste
     'p' => { func => \&cmd_movement_p },
     'P' => { func => \&cmd_movement_P },
     # to end of line
     'C' => { func => \&cmd_movement_dollar },
     'D' => { func => \&cmd_movement_dollar },
     # misc
     '~' => { func => \&cmd_movement_tilde },
     '.' => {},
     '"' => { func => \&cmd_movement_register },
     # undo
     'u'    => { func => \&cmd_undo },
     "\x12" => { func => \&cmd_redo },
     "\x04" => { func => \&_print_undo_buffer },

    };

# special movements which take an additional key
my $movements_multiple =
    {
     'f' => undef,
     't' => undef,
     'F' => undef,
     'T' => undef,
     'r' => undef,
     '"' => undef,
    };


sub cmd_undo {
    print "Undo!" if DEBUG;

    print "Undoing entry index: $undo_index of " . scalar(@undo_buffer) if DEBUG;

    _restore_undo_entry($undo_index);

    if ($undo_index != $#undo_buffer) {
        $undo_index++;
    } else {
        print "No further undo." if DEBUG;
    }
}

sub cmd_redo {
    print "Redo!" if DEBUG;
}

sub cmd_operator_c {
    my ($old_pos, $new_pos, $move, $repeat) = @_;

    # Changing a word or WORD doesn't delete the last space before a word.
    if ($move eq 'w' or $move eq 'W') {
        my $input = _input();
        if (substr($input, $new_pos - 1, 1) =~ /\s/) {
            $new_pos--;
        }
    }

    cmd_operator_d($old_pos, $new_pos, $move, $repeat, 1);

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        _insert_buffer(1);
    }
}
sub cmd_operator_d {
    my ($old_pos, $new_pos, $move, $repeat, $change) = @_;

    my ($pos, $length) = _get_pos_and_length($old_pos, $new_pos, $move);

    # Remove the selected string from the input.
    my $input = _input();
    my $string = substr $input, $pos, $length, '';
    if ($register =~ /[A-Z]/) {
        $registers->{lc $register} .= $string;
        print "Deleted into $register: ", $registers->{lc $register} if DEBUG;
    } else {
        $registers->{$register} = $string;
        print "Deleted into $register: ", $registers->{$register} if DEBUG;
    }
    _input($input);

    # Prevent moving after the text when we delete the last character. But not
    # when changing (C).
    $pos-- if $pos == length($input) and !$change;

    # Move the cursor at the right position.
    _input_pos($pos);
}
sub cmd_operator_y {
    my ($old_pos, $new_pos, $move, $repeat) = @_;

    my ($pos, $length) = _get_pos_and_length($old_pos, $new_pos, $move);

    # Extract the selected string and put it in the " register.
    my $input = _input();
    my $string = substr $input, $pos, $length;
    if ($register =~ /[A-Z]/) {
        $registers->{lc $register} .= $string;
        print "Yanked into $register: ", $registers->{lc $register} if DEBUG;
    } else {
        $registers->{$register} = $string;
        print "Yanked into $register: ", $registers->{$register} if DEBUG;
    }

    _input_pos($old_pos);
}
sub _get_pos_and_length {
    my ($old_pos, $new_pos, $move) = @_;

    my $length = $new_pos - $old_pos;
    # We need a positive length and $old_pos must be smaller.
    if ($length < 0) {
        $old_pos = $new_pos;
        $length *= -1;
    }

    # Most movement commands don't move one character after the deletion area
    # (which is what we need). For those increase length to support proper
    # selection/deletion.
    if ($move ne 'w' and $move ne 'W' and $move ne 'x' and $move ne 'X' and
        $move ne 'B' and $move ne 'h' and $move ne 'l') {
        $length += 1;
    }

    return ($old_pos, $length);
}


sub cmd_movement_h {
    my ($count, $pos, $repeat) = @_;

    $pos -= $count;
    $pos = 0 if $pos < 0;
    _input_pos($pos);
}
sub cmd_movement_l {
    my ($count, $pos, $repeat) = @_;

    my $length = _input_len();
    $pos += $count;
    $pos = _fix_input_pos($pos, $length);
    _input_pos($pos);
}
sub cmd_movement_space {
    my ($count, $pos, $repeat) = @_;
    cmd_movement_l($count, $pos);
}

# later history (down)
sub cmd_movement_j {
    my ($count, $pos, $repeat) = @_;

    if (Irssi::version < 20090117) {
        # simulate a down-arrow
        _emulate_keystrokes(0x1b, 0x5b, 0x42);
        return;
    }

    my @history = Irssi::active_win->get_history_lines();

    if (defined $history_index) {
        $history_index += $count;
        print "History Index: $history_index" if DEBUG;
    } else {
        $history_index = $#history;
    }

    if ($history_index > $#history) {
        # Restore the input line.
        _input($history_input);
        _input_pos($history_pos);
        $history_index = $#history + 1;
    } elsif ($history_index >= 0) {
        _input($history[$history_index]);
        _input_pos(0);
    }
}
# earlier history (up)
sub cmd_movement_k {
    my ($count, $pos, $repeat) = @_;

    if (Irssi::version < 20090117) {
        # simulate an up-arrow
        _emulate_keystrokes(0x1b, 0x5b, 0x41);
        return;
    }

    my @history = Irssi::active_win->get_history_lines();

    if (defined $history_index) {
        $history_index -= $count;
        $history_index = 0 if $history_index < 0;
    } else {
        $history_index = $#history;
        $history_input = _input();
        $history_pos = _input_pos();
    }
    print "History Index: $history_index" if DEBUG;
    if ($history_index >= 0) {
        _input($history[$history_index]);
        _input_pos(0);
    }
}

sub cmd_movement_f {
    my ($count, $pos, $repeat, $char) = @_;

    $pos = _next_occurrence(_input(), $char, $count, $pos);
    if ($pos != -1) {
        _input_pos($pos);
    }
}
sub cmd_movement_t {
    my ($count, $pos, $repeat, $char) = @_;

    $pos = _next_occurrence(_input(), $char, $count, $pos);
    if ($pos != -1) {
        _input_pos($pos - 1);
    }
}
sub cmd_movement_F {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = reverse _input();
    $pos = _next_occurrence($input, $char, $count, length($input) - $pos - 1);
    if ($pos != -1) {
        _input_pos(length($input) - $pos - 1);
    }
}
sub cmd_movement_T {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = reverse _input();
    $pos = _next_occurrence($input, $char, $count, length($input) - $pos - 1);
    if ($pos != -1) {
        _input_pos(length($input) - $pos - 1 + 1);
    }
}
# Find $count-th next occurrence of $char.
sub _next_occurrence {
    my ($input, $char, $count, $pos) = @_;

    while ($count-- > 0) {
        $pos = index $input, $char, $pos + 1;
        if ($pos == -1) {
            return -1;
        }
    }
    return $pos;
}

sub cmd_movement_w {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    while ($count-- > 0) {
        # Go to end of next word/non-word.
        if (substr($input, $pos) =~ /^$word+/ or
            substr($input, $pos) =~ /^$non_word+/) {
            $pos += $+[0];
        }
        # And skip over any whitespace if necessary. This also happens when
        # we're inside whitespace.
        if (substr($input, $pos) =~ /^\s+/) {
            $pos += $+[0];
        }
    }

    $pos = _fix_input_pos($pos, length $input);
    _input_pos($pos);
}
sub cmd_movement_b {
    my ($count, $pos, $repeat) = @_;

    my $input = reverse _input();
    $pos = length($input) - $pos - 1;
    $pos = 0 if ($pos < 0);

    $pos = _end_of_word($input, $count, $pos);
    $pos = length($input) - $pos - 1;
    $pos = 0 if ($pos < 0);
    _input_pos($pos);
}
sub cmd_movement_e {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    $pos = _end_of_word($input, $count, $pos);
    $pos = _fix_input_pos($pos, length $input);
    _input_pos($pos);
}
# Go to the end of $count-th word, like vi's e.
sub _end_of_word {
    my ($input, $count, $pos) = @_;

    while ($count-- > 0 and length($input) > $pos) {
        my $skipped = 0;
        # Skip over whitespace if in the middle of it or directly after the
        # current word/non-word.
        if (substr($input, $pos + 1) =~ /^\s+/) {
            $pos += $+[0] + 1;
            $skipped = 1;
        }
        elsif (substr($input, $pos) =~ /^\s+/) {
            $pos += $+[0];
            $skipped = 1;
        }
        # We are inside a word/non-word, skip to the end of it.
        if (substr($input, $pos) =~ /^$word{2,}/ or
            substr($input, $pos) =~ /^$non_word{2,}/) {
            $pos += $+[0] - 1;
        # We are the border of word/non-word. Skip to the end of the next one.
        # But not if we've already jumped over whitespace because there could
        # be only one word/non-word char after the whitespace.
        } elsif (!$skipped and (substr($input, $pos) =~ /^$word($non_word+)/ or
                                substr($input, $pos) =~ /^$non_word($word+)/)) {
            $pos += $+[0] - 1;
        }
    }

    # Necessary for correct deletion at the end of the line.
    if (length $input == $pos + 1) {
        $pos++;
    }

    return $pos;
}
sub cmd_movement_W {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    while ($count-- > 0 and length($input) > $pos) {
        if (substr($input, $pos + 1) !~ /\s+/) {
            return cmd_movement_dollar();
        }
        $pos += $+[0] + 1;
    }
    $pos = _fix_input_pos($pos, length $input);
    _input_pos($pos);
}
sub cmd_movement_B {
    my ($count, $pos, $repeat) = @_;

    my $input = reverse _input();
    $pos = _end_of_WORD($input, $count, length($input) - $pos - 1);
    if ($pos == -1) {
        cmd_movement_0();
    } else {
        _input_pos(length($input) - $pos - 1);
    }
}
sub cmd_movement_E {
    my ($count, $pos, $repeat) = @_;

    $pos = _end_of_WORD(_input(), $count, $pos);
    if ($pos == -1) {
        cmd_movement_dollar();
    } else {
        _input_pos($pos);
    }
}
# Go to the end of $count-th WORD, like vi's e.
sub _end_of_WORD {
    my ($input, $count, $pos) = @_;

    return $pos if $pos >= length($input);

    # We are inside a WORD, skip to the end of it.
    if (substr($input, $pos + 1) =~ /^\S+(\s)/) {
        $pos += $-[1];
        $count--;
    }

    while ($count-- > 0) {
        if (substr($input, $pos) !~ /\s+\S+(\s+)/) {
            return -1;
        }
        $pos += $-[1] - 1;
    }
    return $pos;
}

sub cmd_movement_0 {
    _input_pos(0);
}
sub cmd_movement_caret {
    my $input = _input();
    my $pos;
    # No whitespace at all.
    if ($input !~ m/^\s/) {
        $pos = 0;
    # Some non-whitesapece, go to first one.
    } elsif ($input =~ m/[^\s]/) {
        $pos = $-[0];
    # Only whitespace, go to the end.
    } else {
        $pos = _fix_input_pos(_input_len(), length $input);
    }
    _input_pos($pos);
}
sub cmd_movement_dollar {
    my $input = _input();
    my $length = length $input;
    _input_pos(_fix_input_pos($length, $length));
}

sub cmd_movement_x {
    my ($count, $pos, $repeat) = @_;

    cmd_operator_d($pos, $pos + $count, 'x');
}
sub cmd_movement_X {
    my ($count, $pos, $repeat) = @_;

    return if $pos == 0;

    my $new = $pos - $count;
    $new = 0 if $new < 0;
    cmd_operator_d($pos, $new, 'X');
}

sub cmd_movement_i {
    my ($count, $pos, $repeat) = @_;

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        _insert_buffer($count);
    }
}
sub cmd_movement_I {
    my ($count, $pos, $repeat) = @_;

    cmd_movement_caret();
    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        _insert_buffer($count);
    }
}
sub cmd_movement_a {
    my ($count, $pos, $repeat) = @_;

    # Move after current character. Can't use cmd_movement_l() because we need
    # to mover after last character at the end of the line.
    my $length = _input_len();
    $pos += $count;
    $pos = $length if $pos > $length;
    _input_pos($pos);

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        _insert_buffer($count);
    }
}
sub cmd_movement_A {
    my ($count, $pos, $repeat) = @_;

    _input_pos(_input_len());

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        _insert_buffer($count);
    }
}
# Add @insert_buf to _input() at the current cursor position.
sub _insert_buffer {
    my ($count) = @_;
    _insert_at_position(join('', @insert_buf), $count, _input_pos());
}
sub _insert_at_position {
    my ($string, $count, $pos) = @_;

    $string = $string x $count;

    my $input = _input();
    # Check if we are not at the end of the line to prevent substr outside of
    # string error.
    if (length $input > $pos) {
        substr($input, $pos, 0) = $string;
    } else {
        $input .= $string;
    }
    _input($input);

    _input_pos($pos - 1 + length $string);
}

sub cmd_movement_r {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = _input();
    substr $input, $pos, 1, $char;
    _input($input);
    _input_pos($pos);
}

sub cmd_movement_p {
    my ($count, $pos, $repeat) = @_;
    _paste_at_position($count, $pos + 1);
}
sub cmd_movement_P {
    my ($count, $pos, $repeat) = @_;
    _paste_at_position($count, $pos);
}
sub _paste_at_position {
    my ($count, $pos) = @_;

    return if not $registers->{$register};
    _insert_at_position($registers->{$register}, $count, $pos);
}

sub cmd_movement_tilde {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    my $string = substr $input, $pos, $count;
    $string =~ s/(.)/(uc($1) eq $1) ? lc($1) : uc($1)/ge;
    substr $input, $pos, $count, $string;

    _input($input);
    _input_pos($pos + $count);
}

sub cmd_movement_register {
    my ($count, $pos, $repeat, $char) = @_;

    if (not exists $registers->{$char} and not exists $registers->{lc $char}) {
        print "Wrong register $char, ignoring." if DEBUG;
        return;
    }

    # + and * contain both irssi's cut-buffer
    if ($char eq '+' or $char eq '*') {
        $registers->{'+'} = Irssi::parse_special('$U');
        $registers->{'*'} = $registers->{'+'};
    }

    $register = $char;
    print "Changing register to $register" if DEBUG;
}

# Adapt the input position depending if an operator is active or not.
sub _fix_input_pos {
    my ($pos, $length) = @_;

    # Allow moving past the last character when an operator is active to allow
    # correct handling of last character in line.
    if ($operator) {
        $pos = $length if $pos > $length;
    # Otherwise forbid it.
    } else {
        $pos = $length - 1 if $pos > $length - 1;
    }

    return $pos;
}

sub cmd_ex_command {
    my $arg_str = join '', @ex_buf;
    if ($arg_str =~ m|^s/(.+)/(.*)/([ig]*)|) {
        my ($search, $replace, $flags) = ($1, $2, $3);
        print "Searching for $search, replace: $replace, flags; $flags"
          if DEBUG;

        my $rep_fun = sub { $replace };

        my $line = _input();
        my @re_flags = split '', defined $flags?$flags:'';

        if (scalar grep { $_ eq 'i' } @re_flags) {
            $search = '(?i)' . $search;
        }

        print "Search is $search" if DEBUG;

        my $re_pattern = qr/$search/;

        if (scalar grep { $_ eq 'g' } @re_flags) {
            $line =~ s/$re_pattern/$rep_fun->()/eg;
        } else {
            print "Single replace: $replace" if DEBUG;
            $line =~ s/$re_pattern/$rep_fun->()/e;
        }

        print "New line is: $line" if DEBUG;
        _input($line);

    } elsif ($arg_str =~ m|^b(?:uffer)?\s*(.+)$|) {
        my $window;
        my $item;
        my $buffer = $1;

        # Go to window number.
        if ($buffer =~ /^[0-9]+$/) {
            $window = Irssi::window_find_refnum($buffer);
        # Go to previous window.
        } elsif ($buffer eq '#') {
            Irssi::command('window last');
        # Go to best regex matching window.
        } else {
            my $matches = _matching_windows($buffer);
            if (scalar @$matches > 0) {
                $window = @$matches[0]->{window};
                $item = @$matches[0]->{item};
            }
        }

        if ($window) {
            $window->set_active();
            if ($item) {
                $item->set_active();
            }
        }

    # :reg[isters] {arg} and :di[splay] {arg}
    } elsif ($arg_str =~ /^(?:reg(?:isters)?|di(?:splay)?)(?:\s+(.+)$)?/) {
        my @regs;
        if ($1) {
            my $regs = $1;
            $regs =~ s/\s+//g;
            @regs = split //, $regs;
        } else {
            @regs = keys %$registers;
        }
        my $active_window = Irssi::active_win;
        foreach my $key (sort @regs) {
            if (defined $registers->{$key}) {
                $active_window->print("register $key: $registers->{$key}");
            }
        }
    }
}

sub _matching_windows {
    my ($buffer) = @_;

    my $server;

    if ($buffer =~ m{^(.+)/(.+)}) {
        $server = $1;
        $buffer = $2;
    }

    print ":b searching for channel $buffer" if DEBUG;
    print ":b on server $server" if $server and DEBUG;

    my @matches;
    foreach my $window (Irssi::windows()) {
        # Matching window names.
        if ($window->{name} =~ /$buffer/i) {
            my $win_ratio = ($+[0] - $-[0]) / length($window->{name});
            push @matches, { window => $window,
                               item => undef,
                              ratio => $win_ratio,
                               text => $window->{name} };
            print ":b $window->{name}: $win_ratio" if DEBUG;
        }
        # Matching Window item names (= channels).
        foreach my $item ($window->items()) {
            # Wrong server.
            if ($server and (!$item->{server} or
                              $item->{server}->{chatnet} !~ /^$server/i)) {
                next;
            }
            if ($item->{name} =~ /$buffer/i) {
                my $length = length($item->{name});
                $length-- if index($item->{name}, '#') == 0;
                my $item_ratio = ($+[0] - $-[0]) / $length;
                push @matches, { window => $window,
                                   item => $item,
                                  ratio => $item_ratio,
                                   text => $item->{name} };
                print ":b $window->{name} $item->{name}: $item_ratio" if DEBUG;
            }
        }
    }

    @matches = sort {$b->{ratio} <=> $a->{ratio}} @matches;

    return \@matches;
}


# vi mode status item.
sub vim_mode_cb {
    my ($sb_item, $get_size_only) = @_;
    my $mode_str = '';
    if ($mode == M_INS) {
        $mode_str = 'Insert';
    } elsif ($mode == M_EX) {
        $mode_str = '%_Ex%_';
    } else {
        $mode_str = '%_Command%_';
        if ($register ne '"' or $numeric_prefix or $operator or $movement) {
            $mode_str .= ' (';
            if ($register ne '"') {
                $mode_str .= '"' . $register;
            }
            if ($numeric_prefix) {
                $mode_str .= $numeric_prefix;
            }
            if ($operator) {
                $mode_str .= $operator;
            }
            if ($movement) {
                $mode_str .= $movement;
            }
            $mode_str .= ')';
        }
    }
    $sb_item->default_handler($get_size_only, "{sb $mode_str}", '', 0);
}

# :b window list item.
sub b_windows_cb {
    my ($sb_item, $get_size_only) = @_;

    my $windows = '';

    # A little code duplication of cmd_ex_command()!
    my $arg_str = join '', @ex_buf;
    if ($arg_str =~ m|b(?:uffer)?\s*(.+)$|) {
        my $buffer = $1;
        if ($buffer !~ /^[0-9]$/ and $buffer ne '#') {
            # Display matching windows.
            my $matches = _matching_windows($buffer);
            $windows = join ',', map { $_->{text} } @$matches;
        }
    }

    $sb_item->default_handler($get_size_only, "{sb $windows}", '', 0);
}


sub got_key {
    my ($key) = @_;

    return if ($should_ignore);

    # Esc key
    if ($key == 27) {
        print "Esc seen, starting buffer" if DEBUG;
        $input_buf_enabled = 1;

        # NOTE: this timeout might be too low on laggy systems, but
        # it comes at the cost of keystroke latency for things that
        # contain escape sequences (arrow keys, etc)
        $input_buf_timer
          = Irssi::timeout_add_once(10, \&handle_input_buffer, undef);

    } elsif ($mode == M_INS) {
        if ($key == 3) { # Ctrl-C enter command mode
            _update_mode(M_CMD);
            _stop();
            return;

        } elsif ($key == 10) { # enter.
            _commit_line();

        } elsif ($input_buf_enabled and $imap) {
            print "Imap $imap active" if DEBUG;
            my $map = $imaps->{$imap};
            if (chr($key) eq $map->{map}) {
                $map->{func}();
                # Clear the buffer so the imap is not printed.
                @input_buf = ();
            } else {
                push @input_buf, $key;
            }
            flush_input_buffer();
            _stop();
            $imap = undef;
            return;

        } elsif (exists $imaps->{chr($key)}) {
            print "Imap " . chr($key) . " seen, starting buffer" if DEBUG;

            # start imap pending mode
            $imap = chr($key);

            $input_buf_enabled = 1;
            push @input_buf, $key;
            $input_buf_timer
              = Irssi::timeout_add_once(500, \&flush_input_buffer, undef);

            _stop();
            return;

        # Pressing delete resets insert mode repetition.
        # TODO: maybe allow it
        } elsif ($key == 127) {
            @insert_buf = ();
        # All other entered characters need to be stored to allow repeat of
        # insert mode. Ignore delete and ctrl characters.
        } elsif ($key > 31) {
            push @insert_buf, chr($key);
        }
    }

    if ($input_buf_enabled) {
        push @input_buf, $key;
        _stop();
        return;
    }

    if ($mode == M_CMD) {
        handle_command_cmd($key);
    } elsif ($mode == M_EX) {
        handle_command_ex($key);
    }
}

sub handle_input_buffer {

    Irssi::timeout_remove($input_buf_timer);
    $input_buf_timer = undef;
    # see what we've collected.
    print "Input buffer contains: ", join(", ", @input_buf) if DEBUG;

    if (@input_buf == 1 && $input_buf[0] == 27) {

        print "Enter Command Mode" if DEBUG;
        _update_mode(M_CMD);

    } else {
        # we need to identify what we got, and either replay it
        # or pass it off to the command handler.
        # if ($mode == M_CMD) {
        #     # command
        #     my $key_str = join '', map { chr } @input_buf;
        #     if ($key_str =~ m/^\e\[([ABCD])/) {
        #         print "Arrow key: $1" if DEBUG;
        #     } else {
        #         print "Dunno what that is." if DEBUG;
        #     }
        # } else {
        #     _emulate_keystrokes(@input_buf);
        # }
        _emulate_keystrokes(@input_buf);

        # Clear insert buffer, pressing "special" keys (like arrow keys)
        # resets it.
        @insert_buf = ();
    }

    @input_buf = ();
    $input_buf_enabled = 0;
}

sub flush_input_buffer {
    Irssi::timeout_remove($input_buf_timer);
    $input_buf_timer = undef;
    # see what we've collected.
    print "Input buffer flushed" if DEBUG;

    _emulate_keystrokes(@input_buf);

    @input_buf = ();
    $input_buf_enabled = 0;

    $imap = undef;
}

sub handle_numeric_prefix {
    my ($char) = @_;
    my $num = 0+$char;

    if (defined $numeric_prefix) {
        $numeric_prefix *= 10;
        $numeric_prefix += $num;
    } else {
        $numeric_prefix = $num;
    }
}

sub handle_command_cmd {
    my ($key) = @_;

    my $should_stop = 1;

    my $char = chr($key);

    # We need to treat $movements_multiple specially as they need another
    # argument.
    if ($movement) {
        $movement .= $char;
    }

    # S is an alias for cc.
    if (!$movement and !$operator and $char eq 'S') {
        print "Changing S to cc" if DEBUG;
        $char = 'c';
        $operator = 'c';
    }

    if (!$movement && ($char =~ m/[1-9]/ ||
                       ($numeric_prefix && $char =~ m/[0-9]/))) {
        print "Processing numeric prefix: $char" if DEBUG;
        handle_numeric_prefix($char);

    } elsif (!$movement && exists $movements_multiple->{$char}) {
        print "Processing movement: $char" if DEBUG;
        $movement = $char;

    } elsif (!$movement && exists $operators->{$char}) {
        print "Processing operator: $char" if DEBUG;

        # Abort operator if we already have one pending.
        if ($operator) {
            # But allow cc/dd/yy.
            if ($operator eq $char) {
                print "Processing operator: ", $operator, $char if DEBUG;
                my $pos = _input_pos();
                $operators->{$operator}->{func}->(0, _input_len(), '', 0);
                # Restore position for yy.
                if ($char eq 'y') {
                    _input_pos($pos);
                }
            }
            $numeric_prefix = undef;
            $operator = undef;
            $movement = undef;
        # Set new operator.
        } else {
            $operator = $char;
        }

    } elsif ($movement || exists $movements->{$char}) {
        print "Processing movement command: $char" if DEBUG;

        my $skip = 0;
        my $repeat = 0;

        if (!$movement) {
            # . repeats the last command.
            if ($char eq '.' and defined $last->{char}) {
                $char = $last->{char};
                # If . is given a count then it replaces original count.
                if (not defined $numeric_prefix) {
                    $numeric_prefix = $last->{numeric_prefix};
                }
                $operator = $last->{operator};
                $movement = $last->{movement};
                $register = $last->{register};
                $repeat = 1;
            } elsif ($char eq '.') {
                print '. pressed but $last->{char} not set' if DEBUG;
                $skip = 1;
            }
            # C and D force the matching operator
            if ($char eq 'C') {
                $operator = 'c';
            } elsif ($char eq 'D') {
                $operator = 'd';
            }
        }

        if ($skip) {
            print "Skipping movement and operator." if DEBUG;
        } else {
            # Make sure count is at least 1.
            if (not $numeric_prefix) {
                $numeric_prefix = 1;
            }

            # Execute the movement (multiple times).
            my $cur_pos = _input_pos();
            if (not $movement) {
                $movements->{$char}->{func}
                          ->($numeric_prefix, $cur_pos, $repeat);
            } else {
                # Use the real movement command (like t or f) for operator
                # below.
                $char = substr $movement, 0, 1;
                $movements->{$char}->{func}
                          ->($numeric_prefix, $cur_pos, $repeat,
                             substr $movement, 1);
            }
            my $new_pos = _input_pos();

            # If we have an operator pending then run it on the handled text.
            # But only if the movement changed the position (this prevents
            # problems with e.g. f when the search string doesn't exist).
            if ($operator and $cur_pos != $new_pos) {
                print "Processing operator: ", $operator if DEBUG;
                $operators->{$operator}->{func}->($cur_pos, $new_pos, $char,
                                                  $repeat);
            }

            # Store command, necessary for . But ignore movements and
            # registers.
            if ($operator or $char eq 'x' or $char eq 'X' or $char eq 'r' or
                             $char eq 'p' or $char eq 'P' or $char eq 'C' or
                             $char eq 'D' or $char eq '~' or $char eq '"' or
                             $char eq 'i' or $char eq 'I' or $char eq 'a' or
                             $char eq 'A') {
                $last->{char} = $char;
                $last->{numeric_prefix} = $numeric_prefix;
                $last->{operator} = $operator;
                $last->{movement} = $movement;
                $last->{register} = $register;
            }
        }

        # Reset the count unless we go into insert mode, _update_mode() needs
        # to know it when leaving insert mode to support insert with counts
        # (like 3i).
        if ($repeat or ($char ne 'i' and $char ne 'I' and $char ne 'a' and $char ne 'A')) {
            $numeric_prefix = undef;
        }
        $operator = undef;
        $movement = undef;

        if ($char ne '"' and $register ne '"') {
            print 'Changing register to "' if DEBUG;
            $register = '"';
        }

    # Start Ex mode.
    } elsif ($char eq ':') {
        if (not script_is_loaded('prompt_info')) {
            _warn("Warning: Ex mode requires the 'prompt_info' script. " .
                    "Please load it and try again.");
        } else {
            _update_mode(M_EX);
            _set_prompt(':');
        }

    # Enter key sends the current input line in command mode as well.
    } elsif ($key == 10) {
        $should_stop = 0;
        _commit_line();
    }

    Irssi::statusbar_items_redraw("vim_mode");

    _stop() if $should_stop;
}

sub handle_command_ex {
    my ($key) = @_;

    # DEL key - remove last character
    if ($key == 127) {
        print "Delete" if DEBUG;
        pop @ex_buf;
        _set_prompt(':' . join '', @ex_buf);

    # Return key - execute command
    } elsif ($key == 10) {
        print "Run ex-mode command" if DEBUG;
        cmd_ex_command();
        _set_prompt('');
        @ex_buf = ();
        _update_mode(M_CMD);

    # Append entered key
    } else {
        push @ex_buf, chr $key;
        _set_prompt(':' . join '', @ex_buf);
    }

    Irssi::statusbar_items_redraw("vim_windows");

    _stop();
}


sub vim_mode_init {
    Irssi::signal_add_first 'gui key pressed' => \&got_key;
    Irssi::signal_add 'setup changed' => \&setup_changed;
    Irssi::statusbar_item_register ('vim_mode', 0, 'vim_mode_cb');
    Irssi::statusbar_item_register ('vim_windows', 0, 'b_windows_cb');

    Irssi::settings_add_str('vim_mode', 'vim_mode_cmd_seq', '');
    Irssi::settings_add_bool('vim_mode', 'vim_mode_debug', 0);
    Irssi::settings_add_bool('vim_mode', 'vim_mode_utf8', 1);

    setup_changed();
    _reset_undo_buffer();
}

sub setup_changed {
    my $value;

    # TODO: okay for now, will cause problems when we have more imaps
    $imaps = {};

    $value = Irssi::settings_get_str('vim_mode_cmd_seq');
    if ($value) {
        if (length $value == 1) {
            $imaps->{$value} = { 'map'  => $value,
                                 'func' => sub { _update_mode(M_CMD) }
                               };
        } else {
            _warn("Error: vim_mode_cmd_seq must be a single character");
        }
    }

    $DEBUG_ENABLED = Irssi::settings_get_bool('vim_mode_debug');

    my $new_utf8 = Irssi::settings_get_bool('vim_mode_utf8');

    if ($new_utf8 != $utf8) {
        # recompile the patterns when switching to/from utf-8
        $word     = qr/[\w_]/o;
        $non_word = qr/[^\w_\s]/o;
    }

    if ($new_utf8 and (!$^V or $^V lt v5.8.1)) {
        _warn("Warning: UTF-8 isn't supported very well in perl < 5.8.1! " .
              "Please disable the vim_mode_utf8 setting.");
    }

    $utf8 = $new_utf8;
}

sub UNLOAD {
    Irssi::signal_remove('gui key pressed' => \&got_key);
    Irssi::statusbar_item_unregister ('vim_mode');
    Irssi::statusbar_item_unregister ('vim_windows');

}

sub _add_undo_entry {
    my ($line, $pos) = @_;
    # check it's not a dupe of the list head
    my $head = $undo_buffer[0];
    if ($line eq $head->[0] && $pos == $head->[1]) {
        print "Not adding duplicate to undo list" if DEBUG;
    } else {
        print "adding $line to undo list" if DEBUG;
        # add to the front of the buffer
        unshift @undo_buffer, [$line, $pos];
    }
    $undo_index = 0;
}

sub _restore_undo_entry {
    my $entry = $undo_buffer[$undo_index];
    _input($entry->[0], 1);
    _input_pos($entry->[1]);
}

sub _print_undo_buffer {

    my $i = 0;
    my @buf;
    foreach my $entry (@undo_buffer) {
        my $str = '';
        if ($i == $undo_index) {
            $str .= '* ';
        } else {
            $str .= '  ';
        }
        my ($line, $pos) = @$entry;
        substr($line, $pos, 0) = '*';
        # substr($line, $pos+3, 0) = '%_';

        $str .= sprintf('%02d %s [%d]', $i, $line, $pos);
        push @buf, $str;
        $i++;
    }
    print "------ undo buffer ------";
    print join("\n", @buf);
    print "------------------ ------";

}

sub _reset_undo_buffer {
    my ($line, $pos) = @_;
    $line = _input()     unless defined $line;
    $pos  = _input_pos() unless defined $pos;

    print "Clearing undo buffer" if DEBUG;
    @undo_buffer = ([$line, $pos]);
    $undo_index  = 0;
}


sub _commit_line {
    _update_mode(M_INS);
    _reset_undo_buffer('', 0);
}

sub _input {
    my ($data, $ignore_undo) = @_;

    my $current_data = Irssi::parse_special('$L', 0, 0);

    if ($utf8) {
        $current_data = decode_utf8($current_data);
    }

    if (defined $data) {
        if (!$ignore_undo && ($data ne $current_data)) {
            if ($undo_index != 0) { # ???
                print "Resetting undo buffer" if DEBUG;
                _reset_undo_buffer($current_data, _input_pos());
            } else {
                my $pos = _input_pos();
                print "Adding debug entry: $current_data $pos" if DEBUG;
                _add_undo_entry($current_data, $pos);
            }
        }
        if ($utf8) {
            Irssi::gui_input_set(encode_utf8($data));
        } else {
            Irssi::gui_input_set($data);
        }
    } else {
        $data = $current_data;
    }

    return $data;
}

sub _input_len {
    return length _input();
}

sub _input_pos {
    my ($pos) = @_;
    my $cur_pos = Irssi::gui_input_get_pos();

    if (defined $pos) {
        print "Input pos being set from $cur_pos to $pos" if DEBUG;
        Irssi::gui_input_set_pos($pos) if $pos != $cur_pos;
    } else {
        $pos = $cur_pos;
        print "Input pos retrieved as $pos" if DEBUG;
    }

    return $pos;
}

sub _emulate_keystrokes {
    my @keys = @_;
    $should_ignore = 1;
    for my $key (@keys) {
        Irssi::signal_emit('gui key pressed', $key);
    }
    $should_ignore = 0;
}

sub _stop() {
    Irssi::signal_stop_by_name('gui key pressed');
}

sub _update_mode {
    my ($new_mode) = @_;

    if ($mode == M_INS and $new_mode == M_CMD) {
        # Support counts with insert modes, like 3i.
        if ($numeric_prefix and $numeric_prefix > 1) {
            _insert_buffer($numeric_prefix - 1);
            $numeric_prefix = undef;

        # In insert mode we are "between" characters, in command mode "on top"
        # of keys. When leaving insert mode we have to move on key left to
        # accomplish that.
        } else {
            my $pos = _input_pos();
            if ($pos != 0) {
                _input_pos($pos - 1);
            }
        }
    # Change mode to i to support insert mode repetition. This doesn't affect
    # commands like i/a/I/A because handle_command_cmd() sets $last->{char}.
    # It's necessary when pressing enter.
    } elsif ($mode == M_CMD and $new_mode == M_INS) {
        $last->{char} = 'i';
    }

    $mode = $new_mode;
    if ($mode == M_INS) {
        $history_index = undef;
        $register = '"';
        @insert_buf = ();
    # Reset every command mode related status as a fallback in case something
    # goes wrong.
    } elsif ($mode == M_CMD) {
        $numeric_prefix = undef;
        $operator = undef;
        $movement = undef;
        $register = '"';
    }

    Irssi::statusbar_items_redraw("vim_mode");
}

sub _set_prompt {
    my $msg = shift;
    # add a leading space unless we're trying to clear it entirely.
    $msg = ' ' . $msg if length $msg;
    Irssi::signal_emit('change prompt', $msg);
}

sub _warn {
    my ($warning) = @_;

    print '%_vim_mode: ', $warning, '%_';
}

# TODO:
# 10gg -> go to window 10 (prefix.gg -> win <prefix>)
