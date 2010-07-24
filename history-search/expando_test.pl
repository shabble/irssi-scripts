use strict;
use Irssi;
use Irssi::TextUI; # for sbar_items_redraw

use vars qw($VERSION %IRSSI);
$VERSION = "1.0.1";
%IRSSI = (
	authors         => "shabble",
	contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
	name            => "",
	description     => "",
	license         => "Public Domain",
	changed         => ""
);

my $prompt_additional_content = '';

Irssi::expando_create('prompt_additional', \&expando_prompt, {});

#TODO: necessary?
#Irssi::signal_add_last 'gui print text finished' => \&redraw_prompts;

sub expando_prompt {
    my ($server, $witem, $arg) = @_;
    return $prompt_additional_content;
}

sub redraw_prompts {
    Irssi::statusbar_items_redraw ('prompt');
    Irssi::statusbar_items_redraw ('prompt_empty');
}

sub handle_change_prompt_sig {
    my ($text) = @_;

    print "Got prompt change sig with: $text";

    my $expanded_text = Irssi::parse_special($text);
    my $changed = ($expanded_text ne $prompt_additional_content);

    $prompt_additional_content = $expanded_text;

    if ($changed) {
        print "Redrawing prompts";
        redraw_prompts();
    }
}

sub prompt_additional_cmd {
    my ($str) = @_;
    print "Setting prompt to: $str";
    Irssi::signal_emit('change prompt', $str);
}

Irssi::signal_register({'change prompt' => [qw/string/]});
Irssi::signal_add('change prompt' => \&handle_change_prompt_sig);

Irssi::command_bind('set_prompt' => \&prompt_additional_cmd);
