
use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw
use POSIX qw/strftime/;

my $time_format;

sub any_time_sb {
    my ($sb_item, $get_size_only) = @_;

    my @time_now = localtime();
    my $formatted_time = strftime($time_format, @time_now);

    $sb_item->default_handler($get_size_only, "{sb $formatted_time}", '', 0);
}

sub sig_setup_changed {
    $time_format = Irssi::settings_get_str('any_time_format');
}

sub init {
    Irssi::settings_add_str('any_time', 'any_time_format', '%H:%M');
    Irssi::signal_add('setup changed', \&sig_setup_changed);

    sig_setup_changed();

    Irssi::signal_add('expando timer',
                      sub { Irssi::statusbar_items_redraw('any_time') });


    Irssi::statusbar_item_register ('any_time', 0, 'any_time_sb');
}

init();
