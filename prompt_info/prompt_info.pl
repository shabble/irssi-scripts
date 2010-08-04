# Usage:

# edit your theme, find the line beginning:
#
#    prompt = "..."
#
# and add the string `$prompt_additional' somewhere inside it.
# If using the default: prompt = "[$*] ", then a good value would be:
#
#    prompt = "[$*$prompt_additional] "
#
# Then add this script to your autorun directory (~/.irssi/scripts/autorun/)
#
# You can modify your prompt content by using the '/set_prompt <string>' command,
# or from scripts by Irssi:signal_emit('change prompt', $string);

use strict;
use warnings;

use Irssi;
use Irssi::TextUI; # for sbar_items_redraw

use vars qw($VERSION %IRSSI);
$VERSION = "1.0.1";
%IRSSI =
  (
   authors         => "shabble",
   contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
   name            => "prompt_info",
   description     => "Helper script for dynamically adding text "
                    . "into the input-bar prompt.",
   license         => "Public Domain",
   changed         => "24/7/2010"
  );

#sub DEBUG () { 1 }
sub DEBUG () { 0 }


my $prompt_additional_content = '';

Irssi::expando_create('prompt_additional', \&expando_prompt, {});

sub expando_prompt {
    my ($server, $witem, $arg) = @_;
    return $prompt_additional_content;
    #return Irssi::current_theme->format_expand("{sb
    #$prompt_additional_content}", 0x0f);
}

sub redraw_prompts {
    Irssi::statusbar_items_redraw ('prompt');
    Irssi::statusbar_items_redraw ('prompt_empty');
}

sub handle_change_prompt_sig {
    my ($text) = @_;

    my $expanded_text = Irssi::parse_special($text);

    print "Got prompt change sig with: $text -> $expanded_text" if DEBUG;

    my $changed = ($expanded_text ne $prompt_additional_content);

    $prompt_additional_content = $expanded_text;

    if ($changed) {
        print "Redrawing prompts" if DEBUG;
        redraw_prompts();
    }
}

sub prompt_additional_cmd {
    my ($str) = @_;
    print "Setting prompt to: $str" if DEBUG;
    Irssi::signal_emit('change prompt', $str);
}

Irssi::signal_register({'change prompt' => [qw/string/]});
Irssi::signal_add('change prompt' => \&handle_change_prompt_sig);

Irssi::command_bind('set_prompt' => \&prompt_additional_cmd);
