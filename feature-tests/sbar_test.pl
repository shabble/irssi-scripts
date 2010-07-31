
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
