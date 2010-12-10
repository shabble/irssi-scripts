# Search and select windows similar to ido-mode for emacs
#
# INSTALL:
#
# This script requires that you have first installed and loaded 'uberprompt.pl'
# Uberprompt can be downloaded from:
#
# http://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl
#
# and follow the instructions at the top of that file for installation.
#
# USAGE:
#
# * Setup: /bind ^R /history_search_start
#
# * Then type ctrl-R and type what you're searching for
#
# * You can cycle through multiple matches with ^R (older matches), and
#   ^S (newer matches)
#
# Based in part on window_switcher.pl script Copyright 2007 Wouter Coekaerts
# <coekie@irssi.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

use strict;
use Irssi;
use Irssi::TextUI;
use Data::Dumper;

use vars qw($VERSION %IRSSI);
$VERSION = '2.0';
%IRSSI =
  (
   authors     => 'Tom Feist, Wouter Coekaerts',
   contact     => 'shabble+irssi@metavore.org, shabble@#irssi/freenode',
   name        => 'ido_switcher',
   description => 'Select window(-items) using ido-mode like search interface',
   license     => 'GPLv2 or later',
   url         => 'http://github.com/shabble/irssi-scripts/tree/master/history-search/',
   changed     => '24/7/2010'
  );


# TODO:
# C-g - cancel
# C-spc - narrow
# flex matching (on by default, but optional)
# server/network narrowing
# colourised output (via uberprompt)
# C-r / C-s rotate matches
# toggle queries/channels
# remove inputline content, restore it afterwards.
# tab - display all possibilities in window (clean up aferwards)

my $input_copy = '';
my $input_pos_copy = 0;

my $ido_switch_active = 0;

my @window_cache  = ();
my @search_matches = ();

my $match_index = 0;
my $search_str = '';

# /set configurable settings
my $ido_show_count;
my $ido_use_flex;

my $DEBUG_ENABLED = 0;
sub DEBUG () { $DEBUG_ENABLED }

# check we have uberprompt loaded.

sub _print {
    my (@args) = @_;

    my $win = Irssi::active_win;
    $win->print(@args);
}

sub script_is_loaded {
    my $name = shift;
    _print "Checking if $name is loaded" if DEBUG;
    no strict 'refs';
    my $retval = defined %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}

unless (script_is_loaded('uberprompt')) {

    _print "This script requires 'uberprompt.pl' in order to work. "
     . "Attempting to load it now...";

    Irssi::signal_add('script error', 'load_uberprompt_failed');
    Irssi::command("script load uberprompt.pl");

    unless(script_is_loaded('uberprompt')) {
        load_uberprompt_failed("File does not exist");
    }
    ido_switch_init();
}

sub load_uberprompt_failed {
    Irssi::signal_remove('script error', 'load_uberprompt_failed');
    _print "Script could not be loaded. Script cannot continue. "
      . "Check you have uberprompt.pl installed in your path and "
        .  "try again.";
    die "Script Load Failed: " . join(" ", @_);
}

sub ido_switch_init {
    Irssi::settings_add_bool('ido_switch', 'ido_switch_debug', 0);
    Irssi::settings_add_bool('ido_switch', 'ido_use_flex',     1);
    Irssi::settings_add_int ('ido_switch', 'ido_show_count',   5);

    Irssi::command_bind('ido_switch_start', \&ido_switch_start);

    Irssi::signal_add      ('setup changed'   => \&setup_changed);
    Irssi::signal_add_first('gui key pressed' => \&handle_keypress);

    setup_changed();
}

sub setup_changed {
    $DEBUG_ENABLED  = Irssi::settings_get_bool('ido_switch_debug');
    $ido_show_count = Irssi::settings_get_int ('ido_show_count');
    $ido_use_flex   = Irssi::settings_get_bool('ido_use_flex');
}


sub ido_switch_start {
    # store copy of input line to restore later.
    $input_copy = Irssi::parse_special('$L');
    $input_pos_copy = Irssi::gui_input_get_pos();

    Irssi::gui_input_set('');

    # set startup flags
    $ido_switch_active = 1;
    $search_str = '';
    $match_index = 0;

    # refresh in case we toggled it last time.
    $ido_use_flex   = Irssi::settings_get_bool('ido_use_flex');

    _print "Win cache: " . join(", ", @window_cache) if DEBUG;

    _update_cache();

    update_matches();
    update_prompt();
}

sub _update_cache {
    @window_cache = get_all_windows();
}

sub get_all_windows {
    my @ret;

    foreach my $win (Irssi::windows()) {
        my @items = $win->items();

        if ($win->{name} ne '') {
            push @ret, {
                        name   => $win->{name},
                        type   => 'WINDOW',
                        num    => $win->{refnum},
                        server => $win->{active_server},
                       };

        } elsif (scalar @items) {
            foreach my $item (@items) {
                push @ret, {
                            name   => $item->{visible_name},
                            type   => $item->{type},
                            server => $item->{server},
                            num    => $win->{refnum},
                            itemname => $item->{name},
                           };
            }
        } else {
            #_print "Error occurred reading info from window: $win";
            #_print Dumper($win);
        }
    }

    @ret = sort { $b->{num} <=> $a->{num} } @ret;
    return @ret;
}

sub ido_switch_select {
    my ($selected) = @_;
    # /window goto $refnum
    # or
    # /window item goto $itemname
    _print "Selecting window: " . $selected->{name};
    Irssi::command("WINDOW GOTO " . $selected->{name});
    if ($selected->{type} ne 'WINDOW') {
        _print "Selecting window item: " . $selected->{itemname};
        Irssi::command("WINDOW ITEM GOTO " . $selected->{itemname});
    }

    ido_switch_exit();
}

sub ido_switch_exit {
    $ido_switch_active = 0;

    Irssi::gui_input_set($input_copy);
    Irssi::gui_input_set_pos($input_pos_copy);
    Irssi::signal_emit('change prompt', '', 'UP_INNER');
}

sub update_prompt {

    # take the top $ido_show_count entries and display them.
    my $match_num = scalar @search_matches;
    my $show_num = $ido_show_count;
    my $show_str = '(no matches) ';

    $show_num = $match_num if $match_num < $show_num;

    if ($show_num > 0) {
        _print "Showing: $show_num matches" if DEBUG;

        my @ordered_matches
         = @search_matches[$match_index .. $#search_matches,
                           0            .. $match_index - 1];

        my @show = @ordered_matches[0..$show_num - 1];

        $show[0] = sprintf '%%g%d:%s%%n', $show[0]->{num}, $show[0]->{name};
        @show[1..$#show] = map
          {
              sprintf '%%r%d:%s%%n', $_->{num}, $_->{name};
          } @show[1..$#show];

        $show_str = join ', ', @show;
    }
    my $flex = sprintf(' [%s]', $ido_use_flex ? 'F' : 'E');
    my $search = '';
    $search = ' `' . $search_str . "'" if length $search_str;
    Irssi::signal_emit('change prompt',
                       $flex . $search . ' win: ' . $show_str,
                       'UP_INNER');
}

sub update_matches {
    if ($ido_use_flex) {
        @search_matches = grep { flex_match($search_str, $_->{name}) } @window_cache;
    } else {
        @search_matches = grep { $_->{name} =~ m/\Q$search_str\E/ } @window_cache;
    }

}

sub flex_match {
    my ($pattern, $source) = @_;

    my @chars = split '', $pattern;
    my $i = -1;
    my $ret = 1;
    foreach my $char (@chars) {
        my $pos = index($source, $char, $i);
        if ($pos > -1) {
            $i = $pos;
        } else {
            $ret = 0;
            last;
        }
    }

    return $ret;
}

sub prev_match {

    $match_index++;
    if ($match_index > $#search_matches) {
        $match_index = 0;
    }
    _print "index now: $match_index" if DEBUG;
}

sub next_match {

    $match_index--;
    if ($match_index < 0) {
        $match_index = $#search_matches;
    }
    _print "index now: $match_index" if DEBUG;
}

sub get_window_match {
    return $search_matches[$match_index];
}

sub handle_keypress {
	my ($key) = @_;

    return unless $ido_switch_active;

    if ($key == 0) { # C-SPC?
        _print "Ctrl-space";

        $search_str = '';
        @window_cache = @search_matches;
        update_prompt();

        Irssi::signal_stop();
        return;
    }

    if ($key == 6) { # C-f

        $ido_use_flex = not $ido_use_flex;
        _update_cache();

        update_matches();
        update_prompt();

        Irssi::signal_stop();
        return;
    }

	if ($key == 10) { # enter
        _print "selecting history and quitting" if DEBUG;
        my $selected_win = get_window_match();
        ido_switch_select($selected_win);
        return;
	}

    if ($key == 18) { # Ctrl-R
        _print "skipping to prev match" if DEBUG;
        prev_match();
        #update_matches();
        update_prompt();
        Irssi::signal_stop(); # prevent the bind from being re-triggered.
        return;
    }

    if ($key == 19) {  # Ctrl-S
        _print "skipping to next match" if DEBUG;
        next_match();
        #update_matches();
        update_prompt();

        Irssi::signal_stop();
        return;
    }

    if ($key == 7) { # Ctrl-G
        _print "aborting search" if DEBUG;
        ido_switch_exit();
        Irssi::signal_stop();
        return;
    }

    if ($key == 127) { # DEL

        if (length $search_str) {
            $search_str = substr($search_str, 0, -1);
            _print "Deleting char, now: $search_str" if DEBUG;
        }

        update_matches();
        update_prompt();

        Irssi::signal_stop();
        return;
    }

    # TODO: handle esc- sequences and arrow-keys?

    if ($key == 27) { # Esc
        ido_switch_exit();
        return;
    }

    if ($key >= 32) { # printable
        $search_str .= chr($key);

        update_matches();
        update_prompt();

        Irssi::signal_stop();
        return;
    }

    # ignore all other keys.
    Irssi::signal_stop();
}

ido_switch_init();

