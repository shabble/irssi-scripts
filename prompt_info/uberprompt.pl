# This script replaces the default prompt status-bar item with one capable
# of displaying additional information, under either user control or via
# scripts.
#
# INSTALL:
#
# Place script in ~/.irssi/scripts/ and potentially symlink into autorun/
# to ensure it starts at irssi startup.
#
# If not using autorun, manually load the script via:
#
# /script load uberprompt.pl
#
# If you have a custom prompt format, you may need to copy it to the
# uberprompt_format setting. See below for details.
#
# USAGE:
#
# Although the script is designed primarily for other scripts to set
# status information into the prompt, the following commands are available:
#
# TODO: Document positional settings.
#
# /prompt set   - sets the prompt to the given argument. $p in the argument will
#                 be replaced by the original prompt content.
# /prompt clear - clears the additional data provided to the prompt.
# /prompt on    - enables the uberprompt (things may get confused if this is used
#                 whilst the prompt is already enabled)
# /prompt off   - restore the original irssi prompt and prompt_empty statusbars.
#                 unloading the script has the same effect.
#
# Additionally, the format for the prompt can be set via:
#
# UBERPROMPT FORMAT:
#
# /set uberprompt_format <format>
#
# The default is [$*], which is the same as the default provided in default.theme.
# Changing this setting will update the prompt immediately, unlike editing your theme.
#
# An additional variable available within this format is '$uber', which expands to
# the content of prompt data provided with the UP_INNER placement argument. For all
# other placement arguments, it will expand to the empty string ''.
#
# NOTE: this setting completely overrides the prompt="..." line in your .theme
#       file, and may cause unexpected behaviour if your theme wishes to set a
#       different form of prompt. It can be simply copied from the theme file into
#       the above setting.
#
# Usage from other Scripts: signal 'change prompt' => 'string' => position
#
# eg:
#
# signal_emit 'change prompt' 'some_string', UberPrompt::UP_INNER;
#
# will set the prompt to include that content, by default '[$* some_string]'
#
# The possible position arguments are the following strings:
#
# UP_PRE   - place the provided string before the prompt -- $string$prompt
# UP_INNER - place the provided string inside the prompt -- {prompt $* $string}
# UP_POST  - place the provided string after the prompt  -- $prompt$string
# UP_ONLY  - replace the prompt with the provided string -- $string
#
# All strings may use the special variable '$prompt' to include the prompt
# verbatim at that position in the string.  It is probably only useful for
# the UP_ONLY mode however. '$prompt_nt' will include the prompt, minus any
# trailing whitespace.
#
# NOTIFICATIONS:
#
# You can also be notified when the prompt changes in response to the previous
# signal or manual commands via:
#
# signal_add 'prompt changed', sub { my ($text, $len) = @_; ... do something ... };
#
# Bugs:
#
# * Resizing the terminal rapidly whilst using this script in debug mode
#    may cause irssi to crash. See bug report at
#    http://bugs.irssi.org/index.php?do=details&task_id=772 for details.
#
# LICENCE:
#
# Copyright (c) 2010 Tom Feist
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw
use Data::Dumper;

our $VERSION = "0.2";
our %IRSSI =
  (
   authors         => "shabble",
   contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
   name            => "prompt_info",
   description     => "Helper script for dynamically adding text "
   . "into the input-bar prompt.",
   license         => "MIT",
   changed         => "24/7/2010"
  );


my $DEBUG_ENABLED = 0;
sub DEBUG { $DEBUG_ENABLED }

my $prompt_data     = undef;
my $prompt_data_pos = 'UP_INNER';

my $prompt_last     = '';
my $prompt_format   = '';

init();

sub prompt_subcmd_handler {
    my ($data, $server, $item) = @_;
    $data =~ s/\s+$//g;         # strip trailing whitespace.
    Irssi::command_runsub('prompt', $data, $server, $item);
}

sub UNLOAD {
    # remove uberprompt and return the original ones.
    print "Removing uberprompt and restoring original";
    restore_prompt_items();
}

sub init {

    Irssi::statusbar_item_register('uberprompt', 0, 'uberprompt_draw');

    Irssi::settings_add_str('uberprompt', 'uberprompt_format', '[$*$uber] ');
    Irssi::settings_add_bool('uberprompt', 'uberprompt_debug', 0);
    Irssi::settings_add_bool('uberprompt', 'uberprompt_autostart', 1);

    Irssi::command_bind("prompt",     \&prompt_subcmd_handler);
    Irssi::command_bind('prompt on',  \&replace_prompt_items);
    Irssi::command_bind('prompt off', \&restore_prompt_items);
    Irssi::command_bind('prompt set',
                        sub {
                            my $args = shift;
                            $args =~ s/^\s*(\w+)\s*(.*$)/$2/;
                            my $mode = 'UP_' . uc($1);
                            Irssi::signal_emit 'change prompt', $args, $mode;
                        });
    Irssi::command_bind('prompt clear',
                        sub {
                            Irssi::signal_emit 'change prompt', '$p', 'UP_POST';
                        });

    Irssi::signal_add('setup changed', \&reload_settings);

    # intialise the prompt format.
    reload_settings();

    # make sure we redraw when necessary.
    Irssi::signal_add('window changed',           \&uberprompt_draw);
    Irssi::signal_add('window name changed',      \&uberprompt_draw);
    Irssi::signal_add('window changed automatic', \&uberprompt_draw);
    Irssi::signal_add('window item changed',      \&uberprompt_draw);

    # install our statusbars if required.
    if (Irssi::settings_get_bool('uberprompt_autostart')) {
        replace_prompt_items();
    }

    # API signals

    Irssi::signal_register({'change prompt' => [qw/string string/]});
    Irssi::signal_add('change prompt' => \&change_prompt_handler);

    # other scripts (specifically overlay/visual) can subscribe to
    # this event to be notified when the prompt changes.
    # arguments are new contents (string), new length (int)
    Irssi::signal_register({'prompt changed' => [qw/string int/]});

    if (DEBUG) {
        Irssi::signal_add 'prompt changed', \&debug_prompt_changed;
    }
}

sub reload_settings {

    $DEBUG_ENABLED = Irssi::settings_get_bool('uberprompt_debug');

    my $new = Irssi::settings_get_str('uberprompt_format');
    if ($prompt_format ne $new) {
        print "Updated prompt format" if DEBUG;
        $prompt_format = $new;
        $prompt_format =~ s/\$uber/\$\$uber/;
        Irssi::abstracts_register(['uberprompt', $prompt_format]);
    }
}

sub debug_prompt_changed {
    my ($text, $len) = @_;

    $text =~ s/%/%%/g;

    print "DEBUG: Got $text, length: $len";
}

sub change_prompt_handler {
    my ($text, $pos) = @_;

    print "Got prompt change signal with: $text, $pos" if DEBUG;

    my ($changed_text, $changed_pos);
    $changed_text = defined $prompt_data     ? $prompt_data     ne $text : 1;
    $changed_pos  = defined $prompt_data_pos ? $prompt_data_pos ne $pos  : 1;

    $prompt_data     = $text;
    $prompt_data_pos = $pos;

    if ($changed_text || $changed_pos) {
        print "Redrawing prompt" if DEBUG;
        uberprompt_refresh();
    }
}

sub _escape_prompt_special {
    my $str = shift;
    $str =~ s/\$/\$\$/g;
    $str =~ s/\\/\\\\/g;
    return $str;
}

sub uberprompt_draw {
    my ($sb_item, $get_size_only) = @_;

    my $window = Irssi::active_win;
    my $prompt_arg = '';

    # default prompt sbar arguments (from config)
    if (scalar( () = $window->items )) {
        $prompt_arg = '$[.15]{itemname}';
    } else {
        $prompt_arg = '${winname}';
    }

    my $prompt = '';            # rendered content of the prompt.
    my $theme = Irssi::current_theme;

    $prompt = $theme->format_expand("{uberprompt $prompt_arg}");

    if ($prompt_data_pos eq 'UP_ONLY') {
        $prompt =~ s/\$\$uber//; # no need for recursive prompting, I hope.

        # TODO: only compute this if necessary?
        my $prompt_nt = $prompt;
        $prompt_nt =~ s/\s+$//;

        my $pdata_copy = $prompt_data;

        $pdata_copy =~ s/\$prompt_nt/$prompt_nt/;
        $pdata_copy =~ s/\$prompt/$prompt/;

        $prompt = $pdata_copy;

    } elsif ($prompt_data_pos eq 'UP_INNER' && defined $prompt_data) {
        my $esc = _escape_prompt_special($prompt_data);
        $prompt =~ s/\$\$uber/$esc/;

    } else {
        # remove the $uber marker
        $prompt =~ s/\$\$uber//;

        # and add the additional text at the appropriate position.
        if ($prompt_data_pos eq 'UP_PRE') {
            $prompt = $prompt_data . $prompt;
        } elsif ($prompt_data_pos eq 'UP_POST') {
            $prompt .= $prompt_data;
        }
    }

    print "Redrawing with: $prompt, size-only: $get_size_only" if DEBUG;


    if ($prompt ne $prompt_last) {

        # print "Emitting prompt changed signal" if DEBUG;
        # my $exp = Irssi::current_theme()->format_expand($text, 0);
        my $ps = Irssi::parse_special($prompt);

        Irssi::signal_emit('prompt changed', $ps, length($ps));
        $prompt_last = $prompt;
    }
    my $ret = $sb_item->default_handler($get_size_only, $prompt, '', 0);

    return $ret;
}

sub uberprompt_refresh {
    Irssi::statusbar_items_redraw('uberprompt');
}

sub replace_prompt_items {
    # remove existing ones.
    print "Removing original prompt" if DEBUG;

    _sbar_command('prompt', 'remove', 'prompt');
    _sbar_command('prompt', 'remove', 'prompt_empty');

    # add the new one.

    _sbar_command('prompt', 'add', 'uberprompt',
                  qw/-alignment left -before input -priority '-1'/);

    _sbar_command('prompt', 'position', '100');
}

sub restore_prompt_items {

    _sbar_command('prompt', 'remove', 'uberprompt');

    print "Restoring original prompt" if DEBUG;

    _sbar_command('prompt', 'add', 'prompt',
                  qw/-alignment left -before input -priority '-1'/);
    _sbar_command('prompt', 'add', 'prompt_empty',
                  qw/-alignment left -after prompt -priority '-1'/);

    _sbar_command('prompt', 'position', '100');

}

sub _sbar_command {
    my ($bar, $cmd, $item, @args) = @_;

    my $args_str = join ' ', @args;

    $args_str .= ' ' if length $args_str && defined $item;

    my $command = sprintf 'STATUSBAR %s %s %s%s',
      $bar, $cmd, $args_str, defined($item)?$item:'';

    print "Running command: $command" if DEBUG;
    Irssi::command($command);
}

