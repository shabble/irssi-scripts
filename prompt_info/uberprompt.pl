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
   license         => "Public Domain",
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

    # hack to produce the same defaults as prompt/prompt_empty sbars.

    if (scalar( () = $window->items )) {
        $default_prompt = '{uberprompt $[.15]itemname}';
    } else {
        $default_prompt = '{uberprompt $winname}';
    }

    my $p_copy = $prompt_data;

    if (defined $prompt_data) {
        # replace the special marker '$p' with the original prompt.
        $p_copy =~ s/\$p/$default_prompt/;
    } else {
        $p_copy = $default_prompt;
    }
    $p_copy =~ s/\$/\$\$/g; # escape all $ symbols
    $p_copy =~ s/\\/\\\\/g; # escape backslashes.

    print "Redrawing with: $p_copy, size-only: $get_size_only" if DEBUG;

    $prompt_item = $sb_item;

    my $ret = $sb_item->default_handler($get_size_only, $p_copy, '', 0);

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
