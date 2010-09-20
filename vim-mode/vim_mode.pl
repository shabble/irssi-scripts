use strict;
use warnings;

use Irssi;
use Irssi::TextUI; # for sbar_items_redraw

# /statusbar window add vim_mode to get the status.

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

#sub DEBUG () { 1 }
sub DEBUG () { 0 }

# circular buffer to keep track of the last N keystrokes.
my @key_buf;
my $buf_idx = 0;
my $key_buf_timer;
my $key_buf_enabled = 0;
my $should_ignore = 0;

sub M_CMD() { 1 } # command mode
sub M_INS() { 0 } # insert mode

my $mode = M_INS;


my $commands
  = {
     'i' => { command => 'insert at cur',
              func => \&cmd_insert,
              params => {pos => sub { _input_pos() }},
            },

     'I' => { command => 'insert at end',
              func => \&cmd_insert,
              params => {pos => sub { _input_len() }},
            },

     'A' => { command => 'insert at start',
              func => \&cmd_insert,
              params => { pos => sub { 0 } },
            },

     'h' => { command => 'move left',
              func => \&cmd_move,
              params => { 'dir' => 'left' },
            },
     'l' => { command => 'move right',
              func => \&cmd_move,
              params => { 'dir' => 'right' },
            },

     'w' => { command => 'move forward word',
              func => \&cmd_jump_word,
              params => { 'dir' => 'fwd',
                          'pos' => sub { _input_pos() }
                        },
            },
     'b' => { command => 'move backward word',
              func => \&cmd_jump_word,
              params => { 'dir' => 'back',
                          'pos' => sub { _input_pos() }
                        },
            },

     'x' => { command => 'delete char forward',
              func => \&cmd_delete_char,
              params => { 'dir' => 'fwd',
                          'pos' => sub { _input_pos() }
                        },
            },
    };

sub cmd_delete_char {
    my ($params) = @_;
    my $pos = $params->{pos}->();
    my $direction = $params->{dir};
    print "Sending keystrokes for delete-char";
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
    _emulate_keystrokes(@buf);
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

    if ($key == 27) {
        print "Esc seen, starting buffer";
        $key_buf_enabled = 1;

        # NOTE: this timeout might be too low on laggy systems, but
        # it comes at the cost of keystroke latency for things that
        # contain escape sequences (arrow keys, etc)
        $key_buf_timer
          = Irssi::timeout_add_once(10, \&handle_key_buffer, undef);
    }

    if ($key_buf_enabled) {
        $key_buf[$buf_idx++] = $key;
        _stop();
    }

    if ($mode == M_CMD) {
        # command mode
        handle_command($key);
    }
}

sub handle_key_buffer {

    Irssi::timeout_remove($key_buf_timer);
    $key_buf_timer = undef;
    # see what we've collected.
    print "Key buffer contains: ", join(", ", @key_buf);

    if (@key_buf == 1 && $key_buf[0] == 27) {

        print "Command Mode";
        $mode = M_CMD;
        _update_mode();

    } else {
        # we need to identify what we got, and either replay it
        # or pass it off to the command handler.
        if ($mode == M_CMD) {
            # command
            my $key_str = join '', map { chr } @key_buf;
            if ($key_str =~ m/^\e\[([ABCD])/) {
                print "Arrow key: $1";
            } else {
                print "Dunno what that is."
            }
        } else {
            _emulate_keystrokes(@key_buf);
        }
    }

    @key_buf = ();
    $buf_idx = 0;
    $key_buf_enabled = 0;
}

sub handle_command {
    my ($key) = @_;
    my $char = chr($key);
    if (exists $commands->{$char}) {
        my $cmd = $commands->{$char};
        # print "Going to execute command: ", $cmd->{command};
        $cmd->{func}->( $cmd->{params} );
    } else {
        _stop(); # disable everything else
    }
}

Irssi::signal_add_first 'gui key pressed' => \&got_key;
Irssi::statusbar_item_register ('vim_mode', 0, 'vim_mode_cb');

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
