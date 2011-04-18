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
# Then place this script to your ~/.irssi/scripts directory (~/.irssi/scripts/)
# and symlink it to the ~/.irssi/scripts/autorun directory (which may need to
# be created first)
#
# You can also load it manually once the theme has been edited via
#
# /script load prompt_info.pl
#
# You will also need to reload your theme with the following command:
#
# /script exec Irssi::themes_reload()
#
# Once loaded, you can modify your prompt content by using the following command:
#
# /set_prompt <string>
#
# You can also use it from other scripts by issuing a signal as follows:
#
# Irssi:signal_emit('change prompt',
#
# report bugs / feature requests to http://github.com/shabble/irssi-scripts/issues
#
# NOTE: it does not appear to be possible to use colours in your prompt at present.
# This is unlikely to change without source-code changes to Irssi itself.

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

test_abstract_setup();
Irssi::signal_register({'change prompt' => [qw/string/]});
Irssi::signal_add('change prompt' => \&handle_change_prompt_sig);

Irssi::command_bind('set_prompt' => \&prompt_additional_cmd);

sub test_abstract_setup {
    my $theme = Irssi::current_theme();
    my $prompt = $theme->format_expand('{prompt}', 0);
    if ($prompt !~ m/\$prompt_additional/) {
        print "Prompt_Info: It looks like you haven't modified your theme"
          . " to include the \$prompt_additional expando.  You will not see"
            . " any prompt info messages until you do. See script comments"
              . "for details";
    }
}
