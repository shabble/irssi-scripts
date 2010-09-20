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

    };

sub cmd_jump_word {
    my ($params) = @_;

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

    if ($dir eq 'left') {
        _input_pos($current_pos -1) if $current_pos;
    } elsif ($dir eq 'right') {
        my $current_len = _input_len();
        _input_pos($current_pos +1) unless $current_pos == $current_len;
    } else {
        print "Unknown direction: $dir";
    }

    _stop();
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

# goals:

# * all keys should work normally in insert mode (including Arrow keys)
# * we should be able to reliably detect a single press of the esc key and
#     switch to command mode
# *

# whenever we see an escape, we need to be sure it's not part of a
# longer escape sequence (eg ^[[A for arrowkeys or whatever)

# when we see an escape (27), we start a timer for a short period, and
# capture all additional keystrokes into a buffer.

# once the timer expires, we examine the buffer to see if it's a plain escape
# (hopefully time is short enough that we don't get user-repeated keypresses)
# or an escape sequence, which we can then parse and do whatever with.

# issues:

# do the buffered commands get evaluated? (ie: do we sig_stop them?)
#
    return if ($should_ignore);

    if ($key == 27) {
        print "Esc seen, starting buffer";
        $key_buf_enabled = 1;
        $key_buf_timer
          = Irssi::timeout_add_once(10, \&handle_key_buffer, undef);
    }

    if ($key_buf_enabled) {
        push @key_buf, $key;
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
            my $key_str = join '', map { chr $_ } @key_buf;
            if ($key_str =~ m/^\e\[([ABCD])/) {
                print "Arrow key: $1";
            } else {
                print "Dunno what that is."
            }
        } else {
            $should_ignore = 1;
            for my $key (@key_buf) {
                Irssi::signal_emit('gui key pressed', $key);
            }
            $should_ignore = 0;
        }
    }

    @key_buf = ();
    $key_buf_enabled = 0;
}

sub handle_command {
    my ($key) = @_;
    my $char = chr($key);
    if (exists $commands->{$char}) {
        my $cmd = $commands->{$char};
        print "Going to execute command: ", $cmd->{command};
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
    return length (Irssi::parse_special('$L', 0, 0));
}

sub _input_pos {
    my ($pos) = @_;
    if (defined $pos) {
        Irssi::gui_input_set_pos($pos);
    } else {
        $pos = Irssi::gui_input_get_pos();
    }
    return $pos;
}

sub _stop() {
    Irssi::signal_stop();
}

sub _update_mode() {
    Irssi::statusbar_items_redraw("vim_mode");
}
