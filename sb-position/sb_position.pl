
# Display current position in scrollback in a statusbar item named 'position'.

# Copyright (C) 2010  Simon Ruderich & Tom Feist
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


use strict;
use warnings;

use Irssi;
use POSIX qw(ceil);

{ package Irssi::Nick }

our $VERSION = '0.1';
our %IRSSI = (
    authors     => 'Simon Ruderich, Tom Feist',
    contact     => 'simon@ruderich.org, shabble+irssi@metavore.org',
    name        => 'sb_position',
    description => 'Displays current position in scrollback.',
    license     => 'GPLv3 or later',
    changed     => '2010-12-02'
);

my ($buf, $size, $pos, $height);
my ($pages, $cur_page, $buf_percent);


init();

sub init {

    # (re-)register it so we can access the WIN_REC object directly.
    Irssi::signal_register({'gui page scrolled' => [qw/Irssi::UI::Window/]});
    # primary update signal.
    Irssi::signal_add('gui page scrolled', \&update_position);
    Irssi::statusbar_item_register('position', 0, 'position_statusbar');

    Irssi::signal_add("window changed",          \&update_position);
    Irssi::signal_add_last("command clear",      \&update_position);
    Irssi::signal_add_last("command scrollback", \&update_position);
    # Irssi::signal_add_last("gui print text finished", sig_statusbar_more_updated);

    update_position(Irssi::active_win());
}

sub update_position {

    my $win = shift;
    return unless $win;

    my $view = $win->view;

    $pos    = $view->{ypos};
    $buf    = $view->{buffer};
    $height = $view->{height};
    $size   = $buf->{lines_count};

    $pages    = ceil($size / $height);
    $pages    = 1 unless $pages;

    $cur_page = ceil(($size - $pos + $height -1) / $height);

    Irssi::statusbar_items_redraw('position');
}

sub position_statusbar {
    my ($statusbar_item, $get_size_only) = @_;

    my $percent;
    if ($size < $height) {
        $percent = 100;
    } else {
        $percent = ceil(($size - $pos - 1 + $height) / $size * 100);
    }

    # Alternate view.
    #my $sb = "p=$pos, s=$size, h=$height, pp:$cur_page/$pages $percent%%";
    my $sb = "Page: $cur_page/$pages $percent%%";
    $statusbar_item->default_handler($get_size_only, "{sb $sb}", 0, 1);
}
