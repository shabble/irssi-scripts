# Search within your typed history as you type (like ctrl-R in bash)
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
# NOTE: Ctrl-S may not work if you have software flow control configured for
# your terminal. It may appear to freeze irssi entirely. If this happens, it can
# be restored with Ctrl-Q, but you will be unable to use the Ctrl-S binding.
# You can disable flow control by running the command `stty -ixon' in your
# terminal, or setting `defflow off' in your ~/.screenrc if using GNU Screen.
#
# * Hitting enter selects a match and terminates search mode.
#
# * You can use ^G to exit search mode without selecting.
#
# * Any other ctrl- or meta- key binding will terminate search mode, leaving the
#   selected item in the input line.
#
# Original script Copyright 2007  Wouter Coekaerts <coekie@irssi.org>
# Heavy modifications by Shabble <shabble+irssi@metavore.org>, 2010.
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

# TODO:
#
# * document tab behaviour
# * add keys (C-n/C-p) to scroll history list
# * if list is bigger than split size, centre it so selected item is visible
# * allow a mechanism to select by number from list

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
   name        => 'rl_history_search',
   description => 'Search within your typed history as you type'
                . ' (like ctrl-R in readline applications)',
   license     => 'GPLv2 or later',
   url         => 'http://github.com/shabble/irssi-scripts/tree/master/history-search/',
   changed     => '24/7/2010'
  );

my $search_str = '';
my $search_active = 0;

my @history_cache  = ();
my @search_matches = ();
my $match_index = 0;

# split info
my $split_ref;
my $original_win_ref;

# formats
my $list_format;

my $use_flex_match = 1;

my $DEBUG_ENABLED = 0;
sub DEBUG () { $DEBUG_ENABLED }

# check we have uberprompt loaded.

sub script_is_loaded {
    return exists($Irssi::Script::{$_[0] . '::'}) ;
}

if (not script_is_loaded('uberprompt')) {

    print "This script requires 'uberprompt.pl' in order to work. "
      . "Attempting to load it now...";

    Irssi::signal_add('script error', 'load_uberprompt_failed');
    Irssi::command("script load uberprompt.pl");

    unless(script_is_loaded('uberprompt')) {
        load_uberprompt_failed("File does not exist");
    }
    history_init();
} else {
    history_init();
}

sub load_uberprompt_failed {
    Irssi::signal_remove('script error', 'load_prompt_failed');

    print "Script could not be loaded. Script cannot continue. "
      . "Check you have uberprompt.pl installed in your path and "
        .  "try again.";

    die "Script Load Failed: " . join(" ", @_);
}

sub history_init {
    Irssi::settings_add_bool('history_search', 'histsearch_debug', 0);

    Irssi::command_bind('history_search_start', \&history_search);

    Irssi::signal_add      ('setup changed'   => \&setup_changed);
    Irssi::signal_add_first('gui key pressed' => \&handle_keypress);

    $list_format = Irssi::theme_register([ list_format => '$*' ]);
    setup_changed();
}

sub setup_changed {
    $DEBUG_ENABLED = Irssi::settings_get_bool('histsearch_debug');
}

sub history_search {
    $search_active = 1;
    $search_str = '';
    $match_index = 0;

    @history_cache = Irssi::active_win()->get_history_lines();
    @search_matches = ();

    $original_win_ref = Irssi::active_win;

    update_history_prompt();
}

sub history_exit {
    $search_active = 0;
    close_listing_split();
    Irssi::signal_emit('change prompt', '', 'UP_INNER');
}

sub update_history_prompt {
    my $col = scalar(@search_matches) ? '%g' : '%r';
    Irssi::signal_emit('change prompt',
                       ' reverse-i-search: `' . $col . $search_str
                       . '%n' . "'",
                       'UP_INNER');
}

sub update_history_matches {
    my ($match_str) = @_;
    $match_str = $search_str unless defined $match_str;

    my %unique;
    my @matches;

    if ($use_flex_match) {
        @matches = grep { flex_match($_) >= 0 } @history_cache;
    } else {
        @matches = grep { m/\Q$match_str/i } @history_cache;
    }

    @search_matches = ();

    # uniquify the results, whilst maintaining order.
    # TODO: duplicates should keep teh most recent one?
    foreach my $m (@matches) {
        unless (exists($unique{$m})) {
            # add them in reverse order.
            unshift @search_matches, $m;
        }
        $unique{$m}++;
    }

    print "updated matches: ", scalar(@search_matches), " ",
      join(", ", @search_matches) if DEBUG;
}

sub flex_match {
    my ($obj) = @_;

    my $pattern = $search_str;
    my $source  = $obj; #->{name};

    #_debug_print "Flex match: $pattern / $source";

    # default to matching everything if we don't have a pattern to compare
    # against.

    return 0 unless $pattern;

    my @chars = split '', lc($pattern);
    my $ret = -1;
    my $first = 0;

    my $lc_source = lc($source);

    #$obj->{hilight_field} = 'name';

    foreach my $char (@chars) {
        my $pos = index($lc_source, $char, $ret);
        if ($pos > -1) {

            # store the beginning of the match
            #$obj->{b_pos} = $pos unless $first;
            $first = 1;

            #_debug_print("matched: $char at $pos in $source");
            $ret = $pos + 1;

        } else {

            #$obj->{b_pos} = $obj->{e_pos} = -1;
            #_debug_print "Flex returning: -1";

            return -1;
        }
    }

    #_debug_print "Flex returning: $ret";

    #store the end of the match.
    #$obj->{e_pos} = $ret;

    return $ret;
}


sub get_history_match {
    return $search_matches[$match_index];
}

sub prev_match {

    $match_index++;
    if ($match_index > $#search_matches) {
        $match_index = 0;
    }
    print "index now: $match_index" if DEBUG;
}

sub next_match {

    $match_index--;
    if ($match_index < 0) {
        $match_index = $#search_matches;
    }
    print "index now: $match_index" if DEBUG;
}

sub update_input {
    my $match = get_history_match();
    Irssi::gui_input_set($match);
	Irssi::gui_input_set_pos(length $match);
}

sub handle_keypress {
	my ($key) = @_;

    return unless $search_active;

    if ($key == 7) { # Ctrl-G
        print "aborting search" if DEBUG;
        history_exit();

        # cancel empties the inputline.
        Irssi::gui_input_set('');
        Irssi::gui_input_set_pos(0);

        Irssi::signal_stop();
        return;
    }

    if ($key == 9) { # TAB
        update_history_matches();
        if (not defined $split_ref) {
            create_listing_split();
        } else {
            print_current_matches();
        }

        Irssi::signal_stop();
        return;
    }
	if ($key == 10) { # enter
        print "selecting history and quitting" if DEBUG;
        history_exit();
        return;
	}

    if ($key == 18) { # Ctrl-R
        print "skipping to prev match" if DEBUG;
        prev_match();
        update_input();
        update_history_prompt();
        print_current_matches();
        Irssi::signal_stop(); # prevent the bind from being re-triggered.
        return;
    }

    if ($key == 19) { # Ctrl-S
        print "skipping to next match" if DEBUG;
        next_match();
        update_input();
        update_history_prompt();
        print_current_matches();

        Irssi::signal_stop();
        return;
    }

    # TODO: handle arrow-keys?

    if ($key == 27) {
        close_listing_split();
        Irssi::signal_stop();
        return;
    }


    if ($key >= 32 and $key < 127) { # printable
        $search_str .= chr($key);

        update_history_matches();
        update_history_prompt();
        update_input();
        print_current_matches();

        Irssi::signal_stop();
        return;
    }

    if ($key == 127) { # DEL

        if (length $search_str) {
            $search_str = substr($search_str, 0, -1);
            print "Deleting char, now: $search_str" if DEBUG;
        }
        update_history_matches();
        update_history_prompt();
        update_input();
        print_current_matches();

        Irssi::signal_stop();
        return;
    }

    # any other key exits, for now.
    history_exit();
    #Irssi::signal_stop();
}

sub create_listing_split {

    return unless @search_matches > 0;

    Irssi::signal_add_first('window created', 'sig_win_created');
    Irssi::command('window new split');
    Irssi::signal_remove('window created', 'sig_win_created');
}

sub close_listing_split {

    if (defined $split_ref) {
        Irssi::command("window close $split_ref->{refnum}");
        undef $split_ref;
    }

    # restore original window focus
    if (Irssi::active_win()->{refnum} != $original_win_ref->{refnum}) {
        $original_win_ref->set_active();
    }
}

sub sig_win_created {
    my ($win) = @_;
    $split_ref = $win;
    # printing directly from this handler causes irssi to segfault.
    Irssi::timeout_add_once(10, \&print_current_matches, {});
}

sub print_current_matches {

    return unless defined $split_ref;

    my $num_matches = scalar(@search_matches);
    return unless $num_matches > 0;

    # for some woefully unobvious reason, we need to refetch
    # the window reference in order for its attribute hash
    # to be regenerated.
    my $s_win = Irssi::window_find_refnum($split_ref->{refnum});

    my $split_height = $s_win->{height};

    $s_win->command("^scrollback clear");

    # disable timestamps to ensure a clean window.
    my $orig_ts_level = Irssi::parse_special('$timestamp_level');
    $s_win->command("^set timestamp_level $orig_ts_level -CLIENTCRAP");


    $original_win_ref->print("Num matches: $num_matches, height: $split_height")
      if DEBUG;

    # print header
    # TODO: make this a format?
    $s_win->print('%_Current history matches. Press <esc> to close.%_',
                  MSGLEVEL_CLIENTCRAP | MSGLEVEL_NEVER);

    $split_height -= 2; # account for header line;

    my $hist_entry = get_history_match();

    my ($start, $end);

    if ($num_matches > $split_height) {
        # we have too many matches to fit in the window. decide on a new
        # start and end point.

        my $half_height = int ($split_height / 2);

        # initial start pos is in the middle of the screen.
        $start = $match_index >= $half_height
          ? $match_index - $half_height
          : 0;
        # and ends with the max number of matches we can fit
        $end   = $start + $split_height > $num_matches - 1
          ? $num_matches - 1
          : $start + $split_height;

        # readjust start if the screen isn't filled.
        if ($end - $start < $split_height) {
            $start = $end - $split_height;
        }

        _debug("sh: $split_height, hh: $half_height, "
                . "mi: $match_index, start: $start, end: $end");
    } else {
        $start = 0;
        $end   = $#search_matches;
    }

    foreach my $i ($start..$end) {
        my $j =  $num_matches - $i;
        my $entry = $search_matches[$i];

        my $hilight = $hist_entry eq $entry
          ? '%g'
          : '';
        $hilight = Irssi::parse_special($hilight);
        my $str = sprintf("%s%-6d %s%%n", $hilight, $j, $entry);
        $s_win->print($str, MSGLEVEL_CLIENTCRAP|MSGLEVEL_NEVER);
    }

    # restore timestamp settings.
    $s_win->command("^set timestamp_level $orig_ts_level");
}

sub _debug {
    return unless DEBUG;
    my ($msg, @args) = @_;
    my $str = sprintf($msg, @args);
    $original_win_ref->print($str);
}
