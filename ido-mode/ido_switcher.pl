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
# tab - display all possibilities in window (clean up afterwards)

my $input_copy     = '';
my $input_pos_copy = 0;

my $ido_switch_active = 0;

my @window_cache   = ();
my @search_matches = ();

my $match_index = 0;
my $search_str  = '';

# /set configurable settings
my $ido_show_count;
my $ido_use_flex;

my $DEBUG_ENABLED = 0;
sub DEBUG () { $DEBUG_ENABLED }

sub MODE_A () { 0 } # all
sub MODE_Q () { 1 } # queries
sub MODE_C () { 2 } # channels
sub MODE_S () { 3 } # select server
sub MODE_W () { 4 } # select window

# check we have uberprompt loaded.

sub _print {
    my $win = Irssi::active_win;
    my $str = join('', @_);
    $win->print($str, Irssi::MSGLEVEL_NEVER);
}

sub _debug_print { 
    my $win = Irssi::active_win;
    my $str = join('', @_);
    $win->print($str, Irssi::MSGLEVEL_CLIENTCRAP);
}

sub _print_clear {
    my $win = Irssi::active_win();
    $win->command('/scrollback levelclear -level NEVER');
}

sub print_all_matches {
    my $msg = join(", ", map { $_->{name} } @search_matches);
    # $msg =~ s/(.{80}.*?,)/$1\n/g;
    # my @lines = split "\n", $msg;
    # foreach my $line (@lines) {
    #     _print($line);
    # }
    _print($msg);
}

sub script_is_loaded {
    my $name = shift;
    _debug_print "Checking if $name is loaded" if DEBUG;
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
    $input_copy     = Irssi::parse_special('$L');
    $input_pos_copy = Irssi::gui_input_get_pos();

    Irssi::gui_input_set('');

    # set startup flags
    $ido_switch_active = 1;
    $search_str        = '';
    $match_index       = 0;

    # refresh in case we toggled it last time.
    $ido_use_flex   = Irssi::settings_get_bool('ido_use_flex');

    _debug_print "Win cache: " . join(", ", @window_cache) if DEBUG;

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
                            name     => $item->{visible_name},
                            type     => $item->{type},
                            server   => $item->{server},
                            num      => $win->{refnum},
                            itemname => $item->{name},
                           };
            }
        } else {
            #_debug_print "Error occurred reading info from window: $win";
            #_debug_print Dumper($win);
        }
    }

    @ret = sort { $a->{num} <=> $b->{num} } @ret;
    return @ret;
}

sub ido_switch_select {
    my ($selected, $is_refnum) = @_;

    _debug_print "Selecting window: " . $selected->{name} if DEBUG;

    Irssi::command("WINDOW GOTO " . $selected->{name});

    if ($selected->{type} ne 'WINDOW') {
        _debug_print "Selecting window item: " . $selected->{itemname} if DEBUG;
        Irssi::command("WINDOW ITEM GOTO " . $selected->{itemname});
    }

    ido_switch_exit();
}

sub ido_switch_exit {
    $ido_switch_active = 0;

    _print_clear();

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
        _debug_print "Showing: $show_num matches" if DEBUG;

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
        @search_matches = grep { $_->{name} =~ m/\Q$search_str\E/i   } @window_cache;
    }

}

sub flex_match {
    my ($pattern, $source) = @_;

    my @chars = split '', lc($pattern);
    my $i = -1;
    my $ret = 1;

    my $lc_source = lc($source);

    foreach my $char (@chars) {
        my $pos = index($lc_source, $char, $i);
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
    _debug_print "index now: $match_index" if DEBUG;
}

sub next_match {

    $match_index--;
    if ($match_index < 0) {
        $match_index = $#search_matches;
    }
    _debug_print "index now: $match_index" if DEBUG;
}

sub get_window_match {
    return $search_matches[$match_index];
}

sub handle_keypress {
	my ($key) = @_;

    return unless $ido_switch_active;

    if ($key == 0) { # C-SPC?
        _debug_print "\%_Ctrl-space\%_" if DEBUG;

        $search_str = '';
        @window_cache = @search_matches;
        update_prompt();

        Irssi::signal_stop();
        return;
    }

    if ($key == 3) { # C-C
        # $search_str = '';
        # @window_cache = @search_matches;
        # update_prompt();
        _print_clear();
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
    if ($key == 9) { # TAB
        _debug_print "Tab complete" if DEBUG;
        print_all_matches();
        Irssi::signal_stop();
    }

	if ($key == 10) { # enter
        _debug_print "selecting history and quitting" if DEBUG;
        my $selected_win = get_window_match();
        ido_switch_select($selected_win);
        return;
	}

    if ($key == 18) { # Ctrl-R
        _debug_print "skipping to prev match" if DEBUG;
        #update_matches();
        next_match();

        update_prompt();
        Irssi::signal_stop(); # prevent the bind from being re-triggered.
        return;
    }

    if ($key == 19) {  # Ctrl-S
        _debug_print "skipping to next match" if DEBUG;
        prev_match();

        #update_matches();
        update_prompt();

        Irssi::signal_stop();
        return;
    }

    if ($key == 7) { # Ctrl-G
        _debug_print "aborting search" if DEBUG;
        ido_switch_exit();
        Irssi::signal_stop();
        return;
    }

    if ($key == 127) { # DEL

        if (length $search_str) {
            $search_str = substr($search_str, 0, -1);
            _debug_print "Deleting char, now: $search_str" if DEBUG;
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

