# This script replaces the default prompt status-bar item with one capable
# of displaying additional information, under either user control or via
# scripts.
#
# Installation:
#
# Place script in ~/.irssi/scripts/ and potentially symlink into autorun/
# to ensure it starts at irssi startup.
#
# If not using autorun, manually load the script via:
#
# /script load uberprompt.pl
#
# Usage:
#
# Although the script is designed primarily for other scripts to set
# status information into the prompt, the following commands are available:
#
# /prompt set   - sets the prompt to the given argument. $p in the argument will
#                 be replaced by the original prompt content.
# /prompt clear - clears the additional data provided to the prompt.
# /prompt on    - enables the uberprompt (things may get confused if this is used
#                 whilst the prompt is already enabled)
# /prompt off   - restore the original irssi prompt and prompt_empty statusbars.
#                 unloading the script has the same effect.
#
# Usage from other Scripts:
#
# signal_emit 'change prompt' 'some_string $p other string';
#
# will set the prompt to include that content.
#
# You can also be notified when the prompt changes in response to the previous
# signal or manual commands via:
#
# signal_add 'prompt changed', sub { my ($text, $len) = @_; ... do something ... };
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



our $VERSION = "0.1";
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

sub DEBUG () { 1 }
#sub DEBUG () { 0 }

my $prompt_data = undef;
my $prompt_item = undef;

my $prompt_format = '';

init();


sub prompt_subcmd_handler {
    my ($data, $server, $item) = @_;
    $data =~ s/\s+$//g; # strip trailing whitespace.
    Irssi::command_runsub('prompt', $data, $server, $item);
}

sub init {

    Irssi::statusbar_item_register('uberprompt', 0, 'uberprompt_draw');

    Irssi::settings_add_str('uberprompt', 'uberprompt_format', '[$*] ');

    Irssi::command_bind("prompt",     \&prompt_subcmd_handler);
    Irssi::command_bind('prompt on',  \&replace_prompt_items);
    Irssi::command_bind('prompt off', \&restore_prompt_items);
    Irssi::command_bind('prompt set',
                        sub { Irssi::signal_emit 'change prompt', shift; });
    Irssi::command_bind('prompt clear',
                        sub { Irssi::signal_emit 'change prompt', '$p'; });

    Irssi::signal_add('setup changed', \&reload_settings);

    # intialise the prompt format.
    reload_settings();

    # install our statusbars.
    replace_prompt_items();

    # the actual API signal.
    Irssi::signal_register({'change prompt' => [qw/string/]});
    Irssi::signal_add('change prompt' => \&change_prompt_sig);

    # other scripts (specifically overlay/visual) can subscribe to
    # this event to be notified when the prompt changes.
    # arguments are new contents (string), new length (int)
    Irssi::signal_register({'prompt changed' => [qw/string int/]});
}

sub change_prompt_sig {
    my ($text) = @_;

    # TODO: mroe intelligence about where to insert $p?
    $text = '$p' . $text;
    print "Got prompt change sig with: $text" if DEBUG;

    my $changed;
    $changed = defined $prompt_data ? $prompt_data ne $text : 1;

    $prompt_data = $text;

    if ($changed) {
        print "Redrawing prompt" if DEBUG;
        uberprompt_refresh();
    }
}

sub UNLOAD {
    # remove uberprompt and return the original ones.
    print "Removing uberprompt and restoring original";
    restore_prompt_items();
}

sub reload_settings {
    my $new = Irssi::settings_get_str('uberprompt_format');
    if ($prompt_format ne $new) {
        print "Updated prompt format" if DEBUG;
        $prompt_format = $new;
        Irssi::abstracts_register(['uberprompt', $prompt_format]);
    }
}

sub uberprompt_draw {
    my ($sb_item, $get_size_only) = @_;

    my $default_prompt = '';

    my $window = Irssi::active_win;

    #print Dumper($sb_item);

    # hack to produce the same defaults as prompt/prompt_empty sbars.
    if (scalar( () = $window->items )) {
        $default_prompt = '{uberprompt $[.15]itemname}';
    } else {
        $default_prompt = '{uberprompt $winname}';
    }

    my $p_copy = $prompt_data;

    if (defined $prompt_data) {
        # replace the special marker '$p' with the original prompt.
        $p_copy =~ s/\$/\$\$/g; # escape all $ symbols
        $p_copy =~ s/\\/\\\\/g; # escape backslashes.

        $p_copy =~ s/\$\$p/$default_prompt/;

    } else {
        $p_copy = $default_prompt;
    }

    print "Redrawing with: $p_copy, size-only: $get_size_only" if DEBUG;

    $prompt_item = $sb_item;

    my $ret = $sb_item->default_handler($get_size_only, $p_copy, '', 0);
    # TODO: do this properly, and also make sure it's only emitted once per
    # change.

    Irssi::signal_emit('prompt changed', $p_copy, $sb_item->{size});

    return $ret;
}


sub uberprompt_refresh {
    Irssi::statusbar_items_redraw('uberprompt');
}


sub cmd_clear_visual {
    _clear_visual_region();
    #refresh_visual_overlay();
    Irssi::statusbar_items_redraw('input');
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



# bit of fakery so things don't complain about the lack of prompt_info (hoepfully)

%Irssi::Script::prompt_info:: = ();
