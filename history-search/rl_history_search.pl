# Search within your typed history as you type (like ctrl-R in bash)
# Usage:

# * Setup: /bind ^R /history_search_start

# * Then type ctrl-R and type what you're searching for

# * You can cycle through multiple matches with ^R (older matches), and
#   ^S (newer matches)

# NOTE: Ctrl-S may not work if you have software flow control configured for
# your terminal. It may appear to freeze irssi entirely. If this happens, it can
# be restored with Ctrl-Q, but you will be unable to use the Ctrl-S binding.
# You can disable flow control by running the command `stty -ixon' in your
# terminal, or setting `defflow off' in your ~/.screenrc if using GNU Screen.

# * Hitting enter selects a match and terminates search mode.

# * You can use ^G to exit search mode without selecting.

# * Any other ctrl- or meta- key binding will terminate search mode, leaving the
#   selected item in the input line.

# Original script Copyright 2007  Wouter Coekaerts <coekie@irssi.org>
# Heavy modifications by Shabble <shabble+irssi@metavore.org>, 2010.

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
$VERSION = '1.0';
%IRSSI =
  (
   authors     => 'Tom Feist, Wouter Coekaerts',
   contact     => 'shabble+irssi@metavore.org, shabble@#irssi/freenode',
   name        => 'rl_history_search',
   description => 'Search within your typed history as you type'
                . ' (like ctrl-R in readline applications)',
   license     => 'GPLv2 or later',
   url         => 'http://github.com/shabble/shab-irssi-scripts/tree/master/history-search/',
   changed     => '24/7/2010'
  );

my $search_str = '';
my $search_active = 0;

my @history_cache  = ();
my @search_matches = ();
my $match_index = 0;


sub DEBUG () { 0 }

# check we have prompt_info loaded.

sub script_is_loaded {
    my $name = shift;
    print "Checking if $name is loaded" if DEBUG;
    no strict 'refs';
    my $retval = defined %{ "Irssi::Script::${name}::" };
    use strict 'refs';

    return $retval;
}

unless (script_is_loaded('prompt_info')) {
    die "This script requires 'prompt_info' in order to work. "
      . "Please load it and try again";
} else {
    history_init();
}

sub history_init {
    Irssi::command_bind('history_search_start', \&history_search);
    #Irssi::command_bind('history_search_exit', \&history_search_exit);
    Irssi::signal_add_first('gui key pressed' => \&handle_keypress);
}

sub history_search {
    $search_active = 1;
    $search_str = '';
    $match_index = -1;

    @history_cache = Irssi::active_win()->get_history_lines();
    @search_matches = ();

    update_history_prompt();
}

sub history_exit {
    $search_active = 0;
    Irssi::signal_emit('change prompt', '');
}

sub update_history_prompt {
    Irssi::signal_emit('change prompt', " reverse-i-search: \`$search_str'");
}

sub update_history_matches {
    my ($match_str) = @_;
    $match_str //= $search_str;

    my %unique;
    my @matches = grep { m/\Q$match_str/i } @history_cache;

    @search_matches = ();

    # uniquify the results, whilst maintaining order.
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
        Irssi::signal_stop(); # prevent the bind from being re-triggered.
        return;
    }

    if ($key == 19) { # Ctrl-S
        print "skipping to next match" if DEBUG;
        next_match();
        update_input();
        update_history_prompt();

        Irssi::signal_stop();
        return;
    }

    if ($key == 7) { # Ctrl-G
        print "aborting search" if DEBUG;
        history_exit();

        # cancel empties the inputline.
        Irssi::gui_input_set('');
        Irssi::gui_input_set_pos(0);

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

        Irssi::signal_stop();
        return;
    }

    # TODO: handle esc- sequences and arrow-keys?

    if ($key >= 32) { # printable
        $search_str .= chr($key);

        update_history_matches();
        update_history_prompt();
        update_input();

        Irssi::signal_stop();
        return;
    }

    # any other key exits, for now.
    history_exit();
    #Irssi::signal_stop();
}
