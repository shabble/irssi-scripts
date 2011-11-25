=pod

=head1 NAME

rl_history_search.pl

=head1 DESCRIPTION

Search within your typed history as you type (something like ctrl-R in bash or other
readline-type applications.)

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.

This script requires that you have first installed and loaded F<uberprompt.pl>

Uberprompt can be downloaded from:

L<https://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl>

and follow the instructions at the top of that file or its README for installation.

If uberprompt.pl is available, but not loaded, this script will make one
attempt to load it before giving up.  This eliminates the need to precisely
arrange the startup order of your scripts.

=head1 SETUP

C</bind ^R /history_search_start>

Where C<^R> is a key of your choice.

=head1 USAGE

Type C<ctrl-R> followed by your search string.  The prompt line will show
you the most recent command to match the string you've typed.

B<Tip:> You can cycle through multiple matches with C<Ctrl-R> (to select older
matches), and <Ctrl-S> (to select newer matches).  Cycling off the end of the
history list returns you to the other end again.

B<NOTE:> C<Ctrl-S> may not work if you have software flow control configured for
your terminal. It may appear to freeze irssi entirely. If this happens, it can
be restored with C<Ctrl-Q>, but you will be unable to use the C<Ctrl-S> binding.
You can disable flow control by running the command C<stty -ixon> in your
terminal, or setting C<defflow off> in your F<~/.screenrc>if using GNU Screen.

=head2 COMMANDS

=over 4

=item * C<Enter>

Selects a match and terminates search mode.
B<It will also run the currently selected command.>

=item * C<Ctrl-G>

Exits search mode without selecting.

=item * C<E<lt>TABE<gt>>

Opens a new split window, showing all matching completions.  C<E<lt>EscE<gt>>
will close the window again, as will any other action that exits history search
mode.  Possible candidates can be cycled through as normal using C<C-r> and
C<<C-s>.

=item * Any other ctrl- or meta- key

This will terminate search mode, leaving the selected item in the input line.
It will not run the command (Except for C<Ctrl-J> and C<Ctrl-M>, which are
functionally equivalent to C<Enter>).

=back

=head1 AUTHORS

Original script
L<http://github.com/coekie/irssi-scripts/blob/master/history_search.pl>
 Copyright E<copy> 2007 Wouter Coekaerts C<E<lt>coekie@irssi.orgE<gt>>


Most of the other fancy stuff Copyright E<copy> 2011 Tom Feist
C<E<lt>shabble+irssi@metavore.orgE<gt>>

=head1 LICENCE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

=head1 BUGS

Yeah, probably.

=head1 TODO

=over 1

=item * B<DONE> document tab behaviour

=item * add keys (C-n/C-p) to scroll history list if necessary.

=item * B<DONE> if list is bigger than split size, centre it so selected item is visible

=item * I<INPROG> allow a mechanism to select by number from list

=item * steal more of the code from ido_switcher to hilight match positions.

=item * make flex matching optional (key or setting)

=item * add some online help (? or C-h triggered, maybe?)

=item * make temp_split stuff more generic (to be used by help, etc)

=item * figure out why sometimes the split list doesn't update correctly (eg: no matches)

=item * consider tracking history manually (via send command/send text)

=over 4

=item * Pro: we could timestamp it.

=item * Con: Would involve catching up/down and all the other history selection mechanisms.

=item * Compromise - tag history as it comes it (match it with data via sig handlers?)

=back

=item * Possibility of saving/restoring history over sessions?

=back

=cut


use strict;
use warnings;

use Irssi;
use Irssi::TextUI;
use Data::Dumper;

our $VERSION = '2.7';
our %IRSSI =
  (
   authors     => 'Tom Feist, Wouter Coekaerts',
   contact     => 'shabble+irssi@metavore.org, shabble@#irssi/freenode',
   name        => 'rl_history_search',
   description => 'Search within your typed history as you type'
   . ' (like ctrl-R in readline applications)',
   license     => 'GPLv2 or later',
   url         => 'http://github.com/shabble/irssi-scripts/tree/master/history-search/',
   changed     => '25/5/2011',
   requires    => [qw/uberprompt.pl/],
  );

my $search_str = '';
my $search_active = 0;

my $select_num_active = 0;
my $num_buffer;

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
    return exists($Irssi::Script::{$_[0] . '::'});
}

if (not script_is_loaded('uberprompt')) {

    print "This script requires 'uberprompt.pl' in order to work. "
      . "Attempting to load it now...";

    Irssi::signal_add('script error', 'load_uberprompt_failed');
    Irssi::command("script load uberprompt.pl");

    unless(script_is_loaded('uberprompt')) {
        load_uberprompt_failed({name => 'uberprompt'}, "File does not exist");
    }
    history_init();
} else {
    history_init();
}

sub load_uberprompt_failed {
    my ($script, $error_msg) = @_;
    Irssi::signal_remove('script error', 'load_uberprompt_failed');
    my $script_name = $script->{name};

    print "Script could not be loaded. Script cannot continue. "
        . "Check you have uberprompt.pl installed in your path and "
        .  "try again.";

    die "Script '$script_name' Load Failed: $error_msg";
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

sub temp_split_active () {
    return defined $split_ref;
}

sub history_search {
    $search_active = 1;
    $search_str = '';
    $match_index = 0;

    my $win = Irssi::active_win;
    @history_cache = $win->get_history_lines();
    @search_matches = ();

    $original_win_ref = $win;

    update_history_matches();
    update_history_prompt();
}

sub history_exit {
    $search_active = 0;
    close_temp_split();
    _set_prompt('');
}

sub update_history_prompt {
    my $col = scalar(@search_matches) ? '%g' : '%r';
    _set_prompt(' reverse-i-search: `' . $col . $search_str . '%n' . "'");
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
    my $source  = $obj;         #->{name};

    #_debug("Flex match: $pattern / $source");

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

sub enter_select_num_mode {
    # require that the list be shown.
    return unless temp_split_active();
    return if $select_num_active; # TODO: should we prevent restarting?

    $num_buffer = 0;
    _set_prompt("Num select: ");
    $select_num_active = 1;
}

sub exit_select_num_mode {

    $select_num_active = 0;
    $num_buffer = 0;
    update_history_prompt();
}

sub history_select_num {
    if ($num_buffer > 0 && $num_buffer <= $#search_matches) {
        $match_index = $num_buffer;
        my $match = get_history_match();
        _debug("Num select: got $match");
    }
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
    # TODO: Use of uninitialized value in subroutine entry at /Users/shabble/projects/tmp/test/irssi-shab/scripts/rl_history_search.pl line 399.
    Irssi::gui_input_set($match); # <--- here.
	Irssi::gui_input_set_pos(length $match);
}

sub handle_keypress {
	my ($key) = @_;

    return unless $search_active;

    if ($select_num_active) {
        if ($key >= 48 and $key <= 57) { # Number key

            $num_buffer = ($num_buffer * 10) + $key - 48;
            _set_prompt("Num select: $num_buffer");

        } elsif ($key == 10) {  # ENTER

            history_select_num();
            update_input();
            exit_select_num_mode();
            history_exit();

        } else {                # anything else quits.
            exit_select_num_mode();
        }
        Irssi::signal_stop();
        return;
    }

    if ($key == 6) {            # Ctrl-F
        enter_select_num_mode();
        Irssi::signal_stop();
        return;
    }

    if ($key == 7) {            # Ctrl-G
        print "aborting search" if DEBUG;
        history_exit();

        # cancel empties the inputline.
        Irssi::gui_input_set('');
        Irssi::gui_input_set_pos(0);

        Irssi::signal_stop();
        return;
    }
    if ($key == 8) {            # C-h
        $original_win_ref->print("This would show help, "
                                 . "if there was any. Coming soon!");
    }

    if ($key == 9) {            # TAB
        update_history_matches();
        if (not temp_split_active()) {
            create_temp_split() if @search_matches > 0;
        } else {
            print_current_matches();
        }

        Irssi::signal_stop();
        return;
    }
	if ($key == 10) {           # enter
        print "selecting history and quitting" if DEBUG;
        history_exit();
        return;
	}

    if ($key == 18) {           # Ctrl-R
        print "skipping to prev match" if DEBUG;
        prev_match();
        update_input();
        update_history_prompt();
        print_current_matches();
        Irssi::signal_stop();   # prevent the bind from being re-triggered.
        return;
    }

    if ($key == 19) {           # Ctrl-S
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
        close_temp_split();
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

    if ($key == 127) {          # DEL

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

sub create_temp_split {

    Irssi::signal_add_first('window created', 'sig_win_created');
    Irssi::command('window new split');
    Irssi::signal_remove('window created', 'sig_win_created');
}

sub close_temp_split {

    if (temp_split_active()) {
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

    return unless temp_split_active();

    my $num_matches = scalar(@search_matches);
    #return unless $num_matches > 0;

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

    if ($num_matches == 0) {
        $s_win->print('(No Matches)', MSGLEVEL_CLIENTCRAP | MSGLEVEL_NEVER);
        return;
    }
    $split_height -= 2;         # account for header line;

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

sub print_help {

}

sub _print_to_active {
    my ($msg, @args) = @_;
    my $str = sprintf($msg, @args);
    $original_win_ref->print($str,MSGLEVEL_CLIENTCRAP | MSGLEVEL_NEVER);
}

sub _debug {
    return unless DEBUG;
    my ($msg, @args) = @_;
    my $str = sprintf($msg, @args);
    $original_win_ref->print($str, MSGLEVEL_CLIENTCRAP | MSGLEVEL_NEVER);
}
sub _set_prompt {
    my ($str) = @_;
    $str = ' ' . $str if length $str;
    Irssi::signal_emit('change prompt', $str, 'UP_INNER');
}
