
use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw


sub foo_sb {
    my ($sb_item, $get_size_only) = @_;

    # my $prompt = Irssi::parse_special('$L');
    # my $cmdchars = Irssi::parse_special('$K');

    # my $sb = '';

    # if ($prompt =~ /^(.)ws (.+)$/i && index($cmdchars,$1) != -1) {
    #     my $arg = $2;
    #     my $wins = find_wins($arg);

    #     foreach my $win (@$wins) {
    #         $sb .= $win->{text} . ' ';
    #     }
    #     $sb =~ s/ $//;
    # }
    my $sb = '%gmoo%n';
    print "Getsize: $get_size_only";
    $sb_item->default_handler($get_size_only, "{sb $sb}", '', 0);
}

Irssi::statusbar_item_register ('foo_bar', 0, 'foo_sb');

__END__
# Name                           Type   Placement Position Visible
# window                         window bottom    1        active
# window_inact                   window bottom    1        inactive
# prompt                         root   bottom    0        always
# topic                          root   top       1        always

# Statusbar: prompt
# Type     : root
# Placement: bottom
# Position : 0
# Visible  : always
# Items    : Name                                Priority  Alignment
#          : prompt                              0         left
#          : prompt_empty                        0         left
#          : input                               10        left
#
# STATUSBAR <name> ENABLE
# STATUSBAR <name> DISABLE
# STATUSBAR <name> RESET
# STATUSBAR <name> TYPE window|root
# STATUSBAR <name> PLACEMENT top|bottom
# STATUSBAR <name> POSITION <num>
# STATUSBAR <name> VISIBLE always|active|inactive
# STATUSBAR <name> ADD
#                  [-before | -after <item>] [-priority #]
#                  [-alignment left|right] <item>
#
# STATUSBAR <name> REMOVE <item>
#
# Commands for modifying the statusbar.
#
# /STATUSBAR
#    - Display all statusbars.
#
# /STATUSBAR <name>
#    - display elements of statusbar <name>
#
# Irssi commands:
# statusbar add     statusbar enable    statusbar position  statusbar reset
# statusbar visible statusbar disable   statusbar placement statusbar remove
# statusbar type

