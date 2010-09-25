# A script to emulate some of the vi(m) features for the Irssi inputline.
#
# Currently supported features:
#
# * Insert/Command mode. Escape enter command mode.
# * cursor motion with: h, l
# * cursor word motion with: w, b, e
# * delete at cursor: x
# * Insert mode at pos: i
# * Insert mode at start: I
# * insert mode at end: A

# Installation:
#
# The usual, stick in scripts dir, /script load vim_mode.pl ...
#
# Use the following command to get a statusbar item that shows which mode you're
# in. Annoying vi bleeping not yet supported :)

# /statusbar window add vim_mode to get the status.

# NOTE: This is still under extreme development, and there's a whole bunch of
# debugging output. Edit the script to remove all the print statements if it
# bothers you.

# Have fun!

use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw


use vars qw($VERSION %IRSSI);
$VERSION = "1.0.1";
%IRSSI =
  (
   authors         => "shabble",
   contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
   name            => "vim_mode",
   description     => "Give Irssi Vim-like commands for editing the inputline",
   license         => "Public Domain",
   changed         => "20/9/2010"
  );


# CONSTANTS

sub DEBUG () { 1 }
#sub DEBUG () { 0 }

sub M_CMD() { 1 } # command mode
sub M_INS() { 0 } # insert mode
sub M_EX () { 2 } # extended mode (after a :?)


# GLOBAL VARIABLES

#  buffer to keep track of the last N keystrokes following an Esc character.
my @esc_buf;
my $esc_buf_idx = 0;
my $esc_buf_timer;
my $esc_buf_enabled = 0;

# flag to allow us to emulate keystrokes without re-intercepting them
my $should_ignore = 0;

# ex mode buffer
my @ex_buf;

# for commands like 10x
my $numeric_prefix = undef;

# vi operators like d, c, ..
my $operator = undef;

# what Vi mode we're in. We start in insert mode.
my $mode = M_INS;


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
    vim_mode_init();
}


# vi-operators like d, c; they don't move the cursor
my $operators
  = {
     'c' => { func => \&cmd_operator_c },
     'd' => { func => \&cmd_operator_d },
     # char movement, works like an operator
     'f' => { func => \&cmd_movement_f },
     't' => { func => \&cmd_movement_t },
     'F' => { func => \&cmd_movement_F },
     'T' => { func => \&cmd_movement_T },
    };

# vi-moves like w,b; they move the cursor and may get combined with an
# operator; also things like i/I are listed here, not entirely correct but
# they work in a similar way
my $movements
  = {
     # arrow like movement
     'h' => { func => \&cmd_movement_h },
     'l' => { func => \&cmd_movement_l },
     #'j' => { func => \&cmd_movement_j },
     #'k' => { func => \&cmd_movement_k },
     # word movement
     'w' => { func => \&cmd_movement_w },
     'b' => { func => \&cmd_movement_b },
     'e' => { func => \&cmd_movement_e },
     # line movement
     '0' => { func => \&cmd_movement_0 },
     '$' => { func => \&cmd_movement_dollar },
     # delete chars
     'x' => { func => \&cmd_movement_x },
     # insert mode
     'i' => { func => \&cmd_movement_i },
     'I' => { func => \&cmd_movement_I },
     'A' => { func => \&cmd_movement_A },
    };

sub cmd_operator_c {
    my ($old_pos, $new_pos) = @_;

    cmd_operator_d($old_pos, $new_pos);
    _update_mode(M_INS);
}

sub cmd_operator_d {
    my ($old_pos, $new_pos) = @_;

    my $length = $new_pos - $old_pos;
    # We need a positive length and $old_pos must be smaller.
    if ($length < 0) {
        my $tmp = $old_pos;
        $old_pos = $new_pos;
        $new_pos = $tmp;
        $length *= -1;
    }

    # Remove the selected string from the input.
    my $input = _input();
    substr $input, $old_pos, $length, '';
    _input($input);

    # Move the cursor at the right position.
    _input_pos($old_pos);
}

sub cmd_movement_h {
    my ($count, $pos) = @_;

    $pos -= $count;
    $pos = 0 if $pos < 0;
    _input_pos($pos);
}
sub cmd_movement_l {
    my ($count, $pos) = @_;

    my $length = _input_len();
    $pos += $count;
    $pos = $length if $pos > $length;
    _input_pos($pos);
}

sub cmd_movement_f {
    my ($count, $pos, $char) = @_;

    $pos = _next_occurrence(_input(), $char, $count, $pos);
    if ($pos != -1) {
        _input_pos($pos);
    }
}
sub cmd_movement_t {
    my ($count, $pos, $char) = @_;

    $pos = _next_occurrence(_input(), $char, $count, $pos);
    if ($pos != -1) {
        _input_pos($pos - 1);
    }
}
sub cmd_movement_F {
    my ($count, $pos, $char) = @_;

    my $input = reverse _input();
    $pos = _next_occurrence($input, $char, $count, length($input) - $pos - 1);
    if ($pos != -1) {
        _input_pos(length($input) - $pos - 1);
    }
}
sub cmd_movement_T {
    my ($count, $pos, $char) = @_;

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
    my ($count, $pos) = @_;

    my $input = _input();
    while ($count-- > 0) {
        $pos = index $input, ' ', $pos + 1;
        if ($pos == -1) {
            return cmd_movement_dollar();
        }
        $pos++;
    }
    _input_pos($pos);
}
sub cmd_movement_b {
    my ($count, $pos) = @_;

    my $input = reverse _input();
    $pos = _end_of_word($input, $count, length($input) - $pos - 1);
    if ($pos == -1) {
        cmd_movement_0();
    } else {
        _input_pos(length($input) - $pos - 1);
    }
}
sub cmd_movement_e {
    my ($count, $pos) = @_;

    $pos = _end_of_word(_input(), $count, $pos);
    if ($pos == -1) {
        cmd_movement_dollar();
    } else {
        _input_pos($pos);
    }
}
# Go to the end of $count-th word, like vi's e.
sub _end_of_word {
    my ($input, $count, $pos) = @_;

    # We are already at the end of one a word, ignore the following space so
    # we can skip over it.
    if (index $input, ' ', $pos + 1 == $pos + 1) {
        $pos++;
    }

    while ($count-- > 0) {
        $pos = index $input, ' ', $pos + 1;
        if ($pos == -1) {
            return -1;
        }
    }
    return $pos - 1;
}

sub cmd_movement_0 {
    _input_pos(0);
}
sub cmd_movement_dollar {
    _input_pos(_input_len());
}

sub cmd_movement_x {
    my ($count, $pos) = @_;

    cmd_operator_d($pos, $pos + $count);
}

sub cmd_movement_i {
    _update_mode(M_INS);
}
sub cmd_movement_I {
    cmd_movement_0();
    _update_mode(M_INS);
}
sub cmd_movement_A {
    cmd_movement_dollar();
    _update_mode(M_INS);
}

sub cmd_ex_command {
    my $arg_str = join '', @ex_buf;
    if ($arg_str =~ m|s/(.+)/(.*)/([ig]*)|) {
        my ($search, $replace, $flags) = ($1, $2, $3);
        print "Searching for $search, replace: $replace, flags; $flags"
          if DEBUG;

        my $rep_fun = sub { $replace };

        my $line = _input();
        my @re_flags = split '', $flags // '';

        if (scalar grep { $_ eq 'i' } @re_flags) {
            $search = '(?i)' . $search;
        }

        print "Search is $search";

        my $re_pattern = qr/$search/;

        if (scalar grep { $_ eq 'g' } @re_flags) {
            $line =~ s/$re_pattern/$rep_fun->()/eg;
        } else {
            print "Single replace: $replace";
            $line =~ s/$re_pattern/$rep_fun->()/e;
        }

        print "New line is: $line";
        _input($line);
    }
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
    }
    $sb_item->default_handler($get_size_only, "{sb $mode_str}", '', 0);
}


sub got_key {
    my ($key) = @_;

    return if ($should_ignore);

    # Esc key
    if ($key == 27) {
        print "Esc seen, starting buffer" if DEBUG;
        $esc_buf_enabled = 1;

        # NOTE: this timeout might be too low on laggy systems, but
        # it comes at the cost of keystroke latency for things that
        # contain escape sequences (arrow keys, etc)
        $esc_buf_timer
          = Irssi::timeout_add_once(10, \&handle_esc_buffer, undef);

    # Ctrl-C
    } elsif ($key == 3 && $mode == M_INS) {
        _update_mode(M_CMD);
        _stop();
        return;
    }

    if ($esc_buf_enabled) {
        $esc_buf[$esc_buf_idx++] = $key;
        _stop();
        return;
    }

    if ($mode == M_CMD || $mode == M_EX) {
        handle_command($key);
    }
}

sub handle_esc_buffer {

    Irssi::timeout_remove($esc_buf_timer);
    $esc_buf_timer = undef;
    # see what we've collected.
    print "Esc buffer contains: ", join(", ", @esc_buf) if DEBUG;

    if (@esc_buf == 1 && $esc_buf[0] == 27) {

        print "Enter Command Mode" if DEBUG;
        _update_mode(M_CMD);

    } else {
        # we need to identify what we got, and either replay it
        # or pass it off to the command handler.
        if ($mode == M_CMD) {
            # command
            my $key_str = join '', map { chr } @esc_buf;
            if ($key_str =~ m/^\e\[([ABCD])/) {
                print "Arrow key: $1" if DEBUG;
            } else {
                print "Dunno what that is." if DEBUG;
            }
        } else {
            _emulate_keystrokes(@esc_buf);
        }
    }

    @esc_buf = ();
    $esc_buf_idx = 0;
    $esc_buf_enabled = 0;
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

sub handle_command {
    my ($key) = @_;

    if ($mode == M_EX) {
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

    } else {
        my $char = chr($key);
        if ($char =~ m/[1-9]/ || ($numeric_prefix && $char =~ m/[0-9]/)) {
            print "Processing numeric prefix: $char" if DEBUG;
            handle_numeric_prefix($char);

        # Special case for f,t,F,T as they take an additional argument
        } elsif ($operator and
                 ($operator eq 'f' or $operator eq 't' or
                  $operator eq 'F' or $operator eq 'T')) {
            $numeric_prefix = 1 if not $numeric_prefix;
            $operators->{$operator}->{func}
                      ->($numeric_prefix, _input_pos(), $char);
            $operator = undef;
            $numeric_prefix = undef;

        } elsif (exists $operators->{$char}) {
            print "Processing operator: $char" if DEBUG;

            # Abort operator if we already have one pending.
            if ($operator) {
                $operator = undef;
            # Set new operator.
            } else {
                $operator = $char;
            }

        } elsif (exists $movements->{$char}) {
            print "Processing movement command: $char" if DEBUG;

            $numeric_prefix = 1 if not $numeric_prefix;

            # Execute the movement (multiple times).
            my $cur_pos = _input_pos();
            $movements->{$char}->{func}->($numeric_prefix, $cur_pos);
            my $new_pos = _input_pos();

            # If we have an operator pending then run it on the handled text.
            if ($operator) {
                print "Processing operator: ", $operator if DEBUG;
                $operators->{$operator}->{func}->($cur_pos, $new_pos);
                $operator = undef;
            }

            $numeric_prefix = undef;

        # Start Ex mode.
        } elsif ($char eq ':') {
            _update_mode(M_EX);
            _set_prompt(':');

        # Enter key sends the current input line in command mode as well.
        } elsif ($key == 10) {
            my $input = _input();
            my $cmdchars = Irssi::settings_get_str('cmdkeys');

            my $signal;
            if ($input =~ /^[\Q$cmdchars\E]/) {
                $signal = 'send command';
            } else {
                $signal = 'send text';
            }
            Irssi::signal_emit $signal, $input, Irssi::active_server(),
                                                Irssi::active_win()->{active};
            _input('');
            _update_mode(M_INS);
        }
    }

    _stop();
}

sub vim_mode_init {
    Irssi::signal_add_first 'gui key pressed' => \&got_key;
    Irssi::statusbar_item_register ('vim_mode', 0, 'vim_mode_cb');
}

sub _input {
    my ($data) = @_;
    if (defined $data) {
        Irssi::gui_input_set($data);
    } else {
        $data = Irssi::parse_special('$L', 0, 0)
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
        Irssi::gui_input_set_pos($pos) if $pos != $cur_pos;
    } else {
        $pos = $cur_pos;
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
    Irssi::signal_stop();
}

sub _update_mode {
    my ($new_mode) = @_;
    $mode = $new_mode;
    Irssi::statusbar_items_redraw("vim_mode");
}

sub _set_prompt {
    my $msg = shift;
    # add a leading space unless we're trying to clear it entirely.
    $msg = ' ' . $msg if length $msg;
    Irssi::signal_emit('change prompt', $msg);
}
# TODO:
# 10gg -> go to window 10 (prefix.gg -> win <prefix>)

