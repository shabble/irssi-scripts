use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw
use Data::Dumper;
use Term::Size;



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

my $vis_enabled = 0;

my ($term_w, $term_h);

my ($region_start, $region_end);

init();

sub update_terminal_size {
    my @stty_lines = qx/stty -a/;
    my $line = $stty_lines[0];
    @stty_lines = (); # don't need the rest.

    if ($line =~ m/\s*(\d+)\s*rows\s*;\s*(\d+)\s*columns\s*;/) {
        $term_h = $1;
        $term_w = $2;
    } else {
        print "Failed to detect terminal size";
    }
}

sub init {

    Irssi::command_bind('prompt_on', \&replace_prompt_items);
    Irssi::command_bind('prompt_off', \&restore_prompt_items);

    Irssi::command_bind('prompt_set',
                        sub {
                            my $data = shift;
                            $prompt_data = $data;
                            refresh_prompt();
                        });

    Irssi::command_bind('prompt_clear',
                        sub {
                            $prompt_data = undef;
                            refresh_prompt();
                        });

    Irssi::command_bind('visual', \&cmd_vis);
    Irssi::command("^BIND meta-l /visual");

    Irssi::statusbar_item_register ('new_prompt', 0, 'new_prompt_render');


    Irssi::signal_add_last('gui key pressed', \&key_pressed);
    Irssi::signal_add('window changed', \&refresh_prompt);
    Irssi::signal_add('window name changed', \&refresh_prompt);
    Irssi::signal_add('window changed automatic', \&refresh_prompt);
    Irssi::signal_add('window item changed', \&refresh_prompt);

    Irssi::signal_add('terminal resized', \&update_terminal_size);

    update_terminal_size();
    replace_prompt_items();
}

# Irssi::signal_add('window changed automatic', \&refresh_prompt);
# Irssi::signal_add('window changed automatic', \&refresh_prompt);


sub UNLOAD {
    restore_prompt_items();
}

sub cmd_vis {
    $vis_enabled = not $vis_enabled;
    if ($vis_enabled) {
        print "visual mode started";
        $region_start = _pos();
    } else {
        print "Visual mode ended";
        $region_end = _pos();

        if ($region_end > $region_start) {
            my $input = Irssi::parse_special('$L', 0, 0);
            my $str = substr($input, $region_start, $region_end - $region_start);
            print "Region selected: $str";
        } else {
            print "Invalid region selection: [ $region_start - $region_end ]";
            $region_start = $region_end = undef;
        }
    }

}

sub refresh_prompt {
    Irssi::statusbar_items_redraw('new_prompt');
}

my $buf = '';

sub key_pressed {
    my ($key) = @_;
    my $char = chr($key);
    $buf .= $char;
    my $str = Irssi::parse_special('$L');

    return unless $vis_enabled;

    print_to_input($str, $prompt_item->{size});
}

sub print_to_input {
    my ($str, $offset) = @_;
    $str = "%8$str%8";

    #    my ($term_w, $term_h) = Term::Size::chars *STDOUT{IO};


    # my $theme = Irssi::current_theme();
    # my $prompt = $theme->format_expand('{prompt $itemname $winname}',
    #                                    Irssi::EXPAND_FLAG_RECURSIVE_MASK);
    #print "Prompt is $prompt";

    Irssi::gui_printtext($offset, $term_h, $str);
}


  sub new_prompt_render {
      my ($sb_item, $get_size_only) = @_;


      my $default_prompt = '';

      my $window = Irssi::active_win();
      if (scalar( () = $window->items )) {
          $default_prompt = '{prompt $[.15]itemname}';
      } else {
          $default_prompt = '{prompt $winname}';
      }

      my $p_copy = $prompt_data;
      if (defined $prompt_data) {
          # check if we have a marker
          $p_copy =~ s/\$p/$default_prompt/;
      } else {
          $p_copy = $default_prompt;
      }
      print "Redrawing with: $p_copy";

      $prompt_item = $sb_item;

      $sb_item->default_handler($get_size_only, $p_copy, '', 0);
  }

sub replace_prompt_items {
    # remove existing ones.
    print "Removing original prompt" if DEBUG;

    _sbar_command('prompt', 'remove', 'prompt');
    _sbar_command('prompt', 'remove', 'prompt_empty');

    # add the new one.

    _sbar_command('prompt', 'add', 'new_prompt',
                  qw/-alignment left -before input -priority 0/);

}

sub restore_prompt_items {

    _sbar_command('prompt', 'remove', 'new_prompt');

    print "Restoring original prompt" if DEBUG;
    _sbar_command('prompt', 'add', 'prompt',
                  qw/-alignment left -before input -priority 0/);
    _sbar_command('prompt', 'add', 'prompt_empty',
                  qw/-alignment left -after prompt -priority 0/);
}


sub _sbar_command {
    my ($bar, $cmd, $item, @args) = @_;

    my $args_str = join ' ', @args;

    $args_str .= ' ' if length $args_str;

    my $command = sprintf 'STATUSBAR %s %s %s%s',
      $bar, $cmd, $args_str, defined($item)?$item:'';

    print "Running command: $command" if DEBUG;
    Irssi::command($command);
}


sub _pos {
    return Irssi::gui_input_get_pos();
}


# my $prompt_additional_content = '';

# Irssi::expando_create('prompt_additional', \&expando_prompt, {});

# sub expando_prompt {
#     my ($server, $witem, $arg) = @_;
#     return $prompt_additional_content;
#     #return Irssi::current_theme->format_expand("{sb
#     #$prompt_additional_content}", 0x0f);
# }

# sub redraw_prompts {
#     Irssi::statusbar_items_redraw ('prompt');
#     Irssi::statusbar_items_redraw ('prompt_empty');
# }

# sub handle_change_prompt_sig {
#     my ($text) = @_;

#     my $expanded_text = Irssi::parse_special($text);

#     print "Got prompt change sig with: $text -> $expanded_text" if DEBUG;

#     my $changed = ($expanded_text ne $prompt_additional_content);

#     $prompt_additional_content = $expanded_text;

#     if ($changed) {
#         print "Redrawing prompts" if DEBUG;
#         redraw_prompts();
#     }
# }

# sub prompt_additional_cmd {
#     my ($str) = @_;
#     print "Setting prompt to: $str" if DEBUG;
#     Irssi::signal_emit('change prompt', $str);
# }

# test_abstract_setup();
# Irssi::signal_register({'change prompt' => [qw/string/]});
# Irssi::signal_add('change prompt' => \&handle_change_prompt_sig);

# Irssi::command_bind('set_prompt' => \&prompt_additional_cmd);

# sub test_abstract_setup {
#     my $theme = Irssi::current_theme();
#     my $prompt = $theme->format_expand('{prompt}', 0);
#     if ($prompt !~ m/\$prompt_additional/) {
#         print "Prompt_Info: It looks like you haven't modified your theme"
#           . " to include the \$prompt_additional expando.  You will not see"
#             . " any prompt info messages until you do. See script comments"
#               . "for details";
#     }
# }
