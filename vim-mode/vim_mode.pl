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

my $mode = 0; # 0 is insert, 1 is command. no Ex for now.

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

    $mode = 0;

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
    if ($mode == 0) {
        $mode_str = 'Insert';
    } else {
        $mode_str = '%_Command%_';
    }
    $sb_item->default_handler($get_size_only, "{sb $mode_str}", '', 0);
}


sub got_key {
    my ($key) = @_;
    _key_buf_add($key);
    if ($mode == 0) {
        # we're in insert mode.
        if ($key == 27) { # esc

            $mode = 1;
            _update_mode();
            Irssi::signal_stop();
            return;
        }

        return;
    } else {
        # command mode
        handle_command($key);
    }
    print "Keys: ", join ', ', @key_buf;
}


sub handle_command {
    my ($key) = @_;
    my $char = chr($key);
    if (exists $commands->{$char}) {
        my $cmd = $commands->{$char};
        print "Going to execute command: ", $cmd->{command};
        $cmd->{func}->( $cmd->{params} );
    } else {
        # some error handling.
    }
}




Irssi::signal_add_first 'gui key pressed' => \&got_key;
Irssi::statusbar_item_register ('vim_mode', 0, 'vim_mode_cb');

sub _key_buf_add {
    my ($key) = @_;
    push @key_buf, $key;
    if (@key_buf > 5) {
        shift @key_buf;
    }
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
