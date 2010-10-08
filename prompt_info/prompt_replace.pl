use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw
use Data::Dumper;



our $VERSION = "0.1";
our %IRSSI =
  (
   authors         => "shabble",
   contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
   name            => "prompt_info",
   description     => "Helper script for dynamically adding text "
   . "into the input-bar prompt.",
   license         => "Public Domain",
   changed         => "24/7/2010"
  );

sub DEBUG () { 1 }
#sub DEBUG () { 0 }

my $prompt_data = undef;
my $prompt_item = undef;

my $region_active = 0;

my ($term_w, $term_h) = (0, 0);

# visual region selected.
my ($region_start, $region_end) = (0, 0);
my $region_content = '';

my $prompt_format = '';

init();

sub update_terminal_size {

    my @stty_data = qx/stty -a/;
    my $line = $stty_data[0];

    # linux
    # speed 38400 baud; rows 36; columns 126; line = 0;
    if ($line =~ m/rows (\d+); columns (\d+);/) {
        $term_h = $1;
        $term_w = $2;
    # osx
    # speed 9600 baud; 40 rows; 235 columns;
    } elsif ($line =~ m/(\d+) rows; (\d+) columns;/) {
        $term_h = $1;
        $term_w = $2;
    } else {
        # guess?
        $term_h = 24;
        $term_w = 80;
    }

    print "Terminal detected as $term_w cols by $term_h rows" if DEBUG;
}

sub prompt_subcmd_handler {
    my ($data, $server, $item) = @_;
    $data =~ s/\s+$//g; # strip trailing whitespace.
    Irssi::command_runsub('prompt', $data, $server, $item);
}

sub visual_subcmd_handler {
    my ($data, $server, $item) = @_;
    $data =~ s/\s+$//g; # strip trailing whitespace.
    Irssi::command_runsub('visual', $data, $server, $item);
}

sub init {

    Irssi::statusbar_item_register ('uberprompt', 0, 'uberprompt_draw');

    Irssi::settings_add_str('uberprompt', 'uberprompt_format', '[$*] ');

    Irssi::command_bind("prompt", \&prompt_subcmd_handler);
    Irssi::command_bind('prompt on', \&replace_prompt_items);
    Irssi::command_bind('prompt off', \&restore_prompt_items);
    Irssi::command_bind('prompt set',
                        sub { Irssi::signal_emit 'change prompt', shift; });
    Irssi::command_bind('prompt clear',
                        sub { Irssi::signal_emit 'change prompt', '$p'; });

    # misc faff
    Irssi::command_bind('visual', \&visual_subcmd_handler);
    Irssi::command_bind('visual toggle', \&cmd_toggle_visual);
    Irssi::command_bind('visual clear',  \&cmd_clear_visual);

    Irssi::command("^BIND ^F /visual toggle");
    Irssi::command("^BIND ^G /visual clear");

    Irssi::command_bind 'print_test',
        sub {
            Irssi::gui_printtext(0, 0, '%8hello there%n');
            };

    # redraw interception
    Irssi::signal_add_last('command redraw',   \&augment_redraw);
    Irssi::signal_add_first('gui key pressed', \&ctrl_l_intercept);

    # for updating the overlay.
    Irssi::signal_add_last ('gui key pressed', \&key_pressed);

    # things to refresh the overlay for.
    Irssi::signal_add('window changed',           \&uberprompt_refresh);
    Irssi::signal_add('window name changed',      \&uberprompt_refresh);
    Irssi::signal_add('window changed automatic', \&uberprompt_refresh);
    Irssi::signal_add('window item changed',      \&uberprompt_refresh);

    Irssi::signal_add('terminal resized', \&update_terminal_size);
    Irssi::signal_add('setup changed',    \&reload_settings);

    # so we know where the bottom line is
    update_terminal_size();

    # intialise the prompt format.
    reload_settings();

    # install our statusbars.
    replace_prompt_items();

    # the actual API signals.
    Irssi::signal_register({'change prompt' => [qw/string/]});
    Irssi::signal_add('change prompt' => \&change_prompt_sig);

    Irssi::signal_register({'prompt changed' => [qw/string int/]});
}

sub change_prompt_sig {
    my ($text) = @_;

    $text = '$p' . $text;
    print "Got prompt change sig with: $text" if DEBUG;

    my $changed;
    $changed = defined $prompt_data ? $prompt_data ne $text : 1;

    $prompt_data = $text;

    if ($changed) {
        print "Redrawing prompt" if DEBUG;
        uberprompt_refresh();
    }
}


sub UNLOAD {
    # remove uberprompt and return the original ones.
    restore_prompt_items();
}

sub reload_settings {
    my $new = Irssi::settings_get_str('uberprompt_format');
    if ($prompt_format ne $new) {
        print "Updated prompt format" if DEBUG;
        $prompt_format = $new;
        Irssi::abstracts_register(['uberprompt', $prompt_format]);
    }
}

sub uberprompt_draw {
    my ($sb_item, $get_size_only) = @_;

    my $default_prompt = '';

    my $window = Irssi::active_win;

    # hack to produce the same defaults as prompt/prompt_empty sbars.

    if (scalar( () = $window->items )) {
        $default_prompt = '{uberprompt $[.15]itemname}';
    } else {
        $default_prompt = '{uberprompt $winname}';
    }

    my $p_copy = $prompt_data;

    if (defined $prompt_data) {
        # replace the special marker '$p' with the original prompt.
        $p_copy =~ s/\$p/$default_prompt/;
    } else {
        $p_copy = $default_prompt;
    }
    print "Redrawing with: $p_copy, size-only: $get_size_only" if DEBUG;

    $prompt_item = $sb_item;

    my $ret = $sb_item->default_handler($get_size_only, $p_copy, '', 0);

    Irssi::signal_emit('prompt changed', $p_copy, $sb_item->{size});

    return $ret;
}

sub augment_redraw {
    print "Redraw called" if DEBUG;
    uberprompt_refresh();
    Irssi::timeout_add_once(10, \&refresh_visual_overlay, 0);
}

sub uberprompt_refresh {
    Irssi::statusbar_items_redraw('uberprompt');
}


sub cmd_clear_visual {
    _clear_visual_region();
    #refresh_visual_overlay();
    Irssi::statusbar_items_redraw('input');
}

sub cmd_toggle_visual {

    $region_active = not $region_active;

    if ($region_active) {
        $region_start = _pos();
        $region_end   = 0; # reset end marker.
        print "visual mode started at $region_start" if DEBUG;
    } else {
        $region_end = _pos();
        print "Visual mode ended at $region_end" if DEBUG;

        if ($region_end > $region_start) {
            my $input = Irssi::parse_special('$L', 0, 0);
            my $str = substr($input, $region_start, $region_end - $region_start);
            print "Region selected: $str" if DEBUG;
        } else {
            print "Invalid region selection: [ $region_start - $region_end ]"
              if DEBUG;
            $region_start = $region_end = 0;
        }
        cmd_clear_visual();
    }
}

sub ctrl_l_intercept {
    my $key = shift;

    if ($key == 12) { # C-l
        print "C-l pressed" if DEBUG;
        Irssi::command("redraw");
        Irssi::signal_stop();
    } elsif ($key == 10) { # RET
        _clear_visual_region();
    }
}

sub key_pressed {
    # this handler needs to be last so the actual character is printed by irssi
    # before we overlay on it. Otherwise things are all a bit off-by-1
    return unless $region_active;

    refresh_visual_overlay();
}

sub _clear_visual_region {
    print "Clearing Region markers" if DEBUG;
    $region_end = 0;
    $region_start = 0;
}


sub refresh_visual_overlay {

    my $end_pos = $region_end;
    $end_pos  ||= _pos(); # if not set, take current position as end.

    my $len = $end_pos - $region_start;
    return unless $len; # no point drawing an empty overlay

    my $input = Irssi::parse_special('$L');
    my $offset = $prompt_item->{size} + $region_start;

    my $text = substr($input, $region_start, $len);

    print "printing '$text' at $offset [$region_start, $end_pos] ($len)" if DEBUG;

    $text = '%8' . $text . '%8';
    _draw_overlay($offset, $text, $len);

}

sub _draw_overlay {
    my ($offset, $text, $len) = @_;
    Irssi::gui_printtext($offset, $term_h, $text);
}

sub replace_prompt_items {
    # remove existing ones.
    print "Removing original prompt" if DEBUG;

    _sbar_command('prompt', 'remove', 'prompt');
    _sbar_command('prompt', 'remove', 'prompt_empty');

    # add the new one.

    _sbar_command('prompt', 'add', 'uberprompt',
                  qw/-alignment left -before input -priority '-1'/);

    _sbar_command('prompt', 'position', '100');
}

sub restore_prompt_items {

    _sbar_command('prompt', 'remove', 'uberprompt');

    print "Restoring original prompt" if DEBUG;

    _sbar_command('prompt', 'add', 'prompt',
                  qw/-alignment left -before input -priority '-1'/);
    _sbar_command('prompt', 'add', 'prompt_empty',
                  qw/-alignment left -after prompt -priority '-1'/);

    _sbar_command('prompt', 'position', '100');

}

sub _sbar_command {
    my ($bar, $cmd, $item, @args) = @_;

    my $args_str = join ' ', @args;

    $args_str .= ' ' if length $args_str && defined $item;

    my $command = sprintf 'STATUSBAR %s %s %s%s',
      $bar, $cmd, $args_str, defined($item)?$item:'';

    print "Running command: $command" if DEBUG;
    Irssi::command($command);
}

sub _pos {
    return Irssi::gui_input_get_pos();
}


# bit of fakery so things don't complain about the lack of prompt_info (hoepfully)

%Irssi::Script::prompt_info:: = ();
