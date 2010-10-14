use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw

Irssi::statusbar_item_register('uberprompt', 0, 'uberprompt_draw');
Irssi::command("STATUSBAR prompt add -alignment left -before input -priority '-1' uberprompt");

sub uberprompt_draw {
    my ($sb_item, $get_size_only) = @_;
    print "This is a test";
    return $sb_item->default_handler($get_size_only, '{uberprompt $winname}', '', 0);
}

