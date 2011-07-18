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

my $region_active = 0;

my ($term_w, $term_h) = (0, 0);

# visual region selected.
my ($region_start, $region_end) = (0, 0);
my $region_content = '';


sub visual_subcmd_handler {
    my ($data, $server, $item) = @_;
    $data =~ s/\s+$//g; # strip trailing whitespace.
    Irssi::command_runsub('visual', $data, $server, $item);
}

sub init {

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

    # so we know where the bottom line is
    update_terminal_size();


}
sub cmd_clear_visual {
    _clear_visual_region();
    #refresh_visual_overlay();
    Irssi::statusbar_items_redraw('input');
}


sub augment_redraw {
    print "Redraw called" if DEBUG;
    uberprompt_refresh();
    Irssi::timeout_add_once(10, \&refresh_visual_overlay, 0);
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

sub _pos {
    return Irssi::gui_input_get_pos();
}
