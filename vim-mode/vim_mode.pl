# A script to emulate some of the vi(m) features for the Irssi inputline.
#
# Currently supported features:
#
# * Insert/Command mode. Escape enter command mode.
# * cursor motion with: h, l
# * cursor word motion with: w, b
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

sub DEBUG () { 1 }
#sub DEBUG () { 0 }

sub A_NUM() { 0 } # expects a specific number of args
sub A_RET() { 1 } # expects a return to indicate end of args.
sub A_NON() { 2 } # expects zero args.
# TODO: do we need a A_FUN that calls a function to check if we've got all of them?

sub M_CMD() { 1 } # command mode
sub M_INS() { 0 } # insert mode
sub M_EX () { 2 } # extended mode (after a :?)


#  buffer to keep track of the last N keystrokes following an Esc character.
my @esc_buf;
my $esc_buf_idx = 0;
my $esc_buf_timer;
my $esc_buf_enabled = 0;

# flag to allow us to emulate keystrokes without re-intercepting them
my $should_ignore = 0;

my $pending_command;

# argument handling.

my @args_buf;
my $collecting_args = 0; # if we're actively collecting them.
my $args_type = A_NON;   # what type of args (constants above)
my $args_num = 0;        # how many args we expect

# for commands like 10x
my $numeric_prefix = undef;

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


my $commands
  = {
     'i' => { command => 'insert at cur',
              func => \&cmd_insert,
              args => { type => A_NON },
              params => {pos => sub { _input_pos() }},
            },

     'A' => { command => 'insert at end',
              func => \&cmd_insert,
              args => { type => A_NON },
              params => {pos => sub { _input_len() }},
            },

     'I' => { command => 'insert at start',
              func => \&cmd_insert,
              args => { type => A_NON },
              params => { pos => sub { 0 } },
            },

     'h' => { command => 'move left',
              func => \&cmd_move,
              args => { type => A_NON },
              params => { 'dir' => 'left' },
            },
     'l' => { command => 'move right',
              func => \&cmd_move,
              args => { type => A_NON },
              params => { 'dir' => 'right' },
            },

     'w' => { command => 'move forward word',
              func => \&cmd_jump_word,
              args => { type => A_NON },
              params => { 'dir' => 'fwd',
                          'pos' => sub { _input_pos() }
                        },
            },
     'b' => { command => 'move backward word',
              func => \&cmd_jump_word,
              args => { type => A_NON },
              params => { 'dir' => 'back',
                          'pos' => sub { _input_pos() }
                        },
            },
     'd' => { command => 'delete',
              func => \&cmd_delete,
              args => { type => A_NUM,  num => 1 },
              params => { 'pos' => sub { _input_pos() } },
            },

     'x' => { command => 'delete char forward',
              func => \&cmd_delete_char,
              args => { type => A_NON },
              params => { 'dir' => 'fwd',
                          'pos' => sub { _input_pos() }
                        },
            },
     ':' => { command => 'Ex command',
              func => \&cmd_ex_command,
              args => { type => A_RET },
              params => { 'pos' => sub { _input_pos() } },
            },
    };


sub cmd_delete {
    my ($params) = @_;
    my @args = @{$params->{args}};
    my $arg = $args[0] // '';

    if ($arg eq '$') { # end of line
    } elsif ($arg eq '^') { #start of line
    } else {
        # dunno
    }
}
sub cmd_replace {
    my ($params) = @_;
}

sub cmd_ex_command {
    my ($params) = @_;
    my $args = $params->{arg_buf};
    my $arg_str = join '', @$args;
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

sub cmd_delete_char {
    my ($params) = @_;
    my $pos = $params->{pos}->();
    my $direction = $params->{dir};
    print "Sending keystrokes for delete-char" if DEBUG;
    _stop();
    my @buf = (4);
    _emulate_keystrokes(@buf);

}

sub cmd_jump_word {
    my ($params) = @_;
    my $pos = $params->{pos}->();
    my $direction = $params->{dir};
    _stop();
    my @buf;
    if ($direction eq 'fwd') {
        push @buf, (27, 102);
    } else {
        push @buf, (27, 98);
    }
    _emulate_keystrokes(@buf);
}

sub cmd_insert {
    my ($params) = @_;
    my $pos = $params->{pos}->();

    _input_pos($pos);

    $mode = M_INS;

    _update_mode();

    _stop();
}

sub cmd_move {
    my ($params) = @_;
    my $dir = $params->{dir};
    my $current_pos = _input_pos();
    _stop();
    my @buf = (27, 91);
    if ($dir eq 'left') {
        push @buf, 68;
    } else {
        push @buf, 67;
    }
    my $count = $params->{prefix} // 1;
    _emulate_keystrokes(@buf) for 1..$count;
}

sub vim_mode_cb {
    my ($sb_item, $get_size_only) = @_;
    my $mode_str = '';
    if ($mode == M_INS) {
        $mode_str = 'Insert';
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
        $mode = M_CMD;
        _update_mode();
        _stop();
        return;
    }

    if ($esc_buf_enabled) {
        $esc_buf[$esc_buf_idx++] = $key;
        _stop();
        return;
    }

    if ($mode == M_CMD) {
        # command mode
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
        $mode = M_CMD;
        _update_mode();

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

sub collect_args {
    my $key = shift;

    print "Collecting arguments" if DEBUG;

    if ($key == 127) { # DEL key - remove last argument
        print "Delete" if DEBUG;
        pop @args_buf;
        _set_prompt(':' . join '', @args_buf);
        return;
    }

    if ($args_type == A_NUM) {
        push @args_buf, chr $key;

        print "numbered args, expect: $args_num, got: " .scalar(@args_buf)
          if DEBUG;

        if (scalar @args_buf == $args_num) {
            dispatch_command($pending_command, @args_buf);
        }
    } elsif ($args_type == A_RET) {
        print "ret terminated args. Key is $key" if DEBUG;

        if ($key == 10) {
            dispatch_command($pending_command, @args_buf);
        } else {
            push @args_buf, chr $key;
            _set_prompt(':' . join '', @args_buf);
        }
    }
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

    if ($collecting_args) {

        collect_args($key);
        _stop();

    } else {
        my $char = chr($key);
        if ($char =~ m/[0-9]/) {
            print "Processing numeric prefix: $char" if DEBUG;
            handle_numeric_prefix($char);
            _stop();
        } else {
            print "Processing new command: $char" if DEBUG;
            if (exists $commands->{$char}) {

                my $cmd = $commands->{$char};
                $args_type = $cmd->{args}->{type};

                if ($args_type == A_NON) {

                    # we can dispatch straight away
                    $pending_command = undef;
                    dispatch_command($cmd);

                } elsif ($args_type == A_NUM) {

                    @args_buf = ();
                    $args_num = $cmd->{args}->{num};
                    $collecting_args = 1;
                    $pending_command = $commands->{$char};
                    _stop();
                } elsif ($args_type == A_RET) {

                    $collecting_args = 1;
                    $pending_command = $commands->{$char};
                    _stop();
                }
            } else {
                _stop(); # disable everything else
            }
        }
    }
}

sub dispatch_command {
    my ($cmd, @args) = @_;
    $collecting_args = 0;
    $pending_command = undef;
    @args_buf = ();
    _set_prompt('');

    if (defined $numeric_prefix) {
        $cmd->{params}->{prefix} = $numeric_prefix;
        print "Commadn has numeric prefix: $numeric_prefix" if DEBUG;
        $numeric_prefix = undef;
    }

    print "Dispatchign command with args: " . join(", ", @args) if DEBUG;
    $cmd->{params}->{arg_buf} = \@args;

    # actually call the function
    $cmd->{func}->($cmd->{params} );
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

sub _update_mode() {
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

