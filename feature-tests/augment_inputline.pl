use strict;
use Irssi;
use Irssi::TextUI; # for sbar_items_redraw
use Term::Size;

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


my $buf = '';

Irssi::command_bind('dogui', \&print_to_input);
Irssi::signal_add_last('gui key pressed', \&key_pressed);

sub stuff {
    my $win = Irssi::active_win;
    my ($w, $h);
    $w = $win->{width};
    $h = $win->{height};

    my ($term_w, $term_h) = Term::Size::chars *STDOUT{IO};
    print "win size is $w,$h, term is $term_w, $term_h";
    print "Prompt len is: ", Irssi::format_get_length("{prompt foo bar}");
}

sub key_pressed {
    my ($key) = @_;
    my $char = chr($key);
    $buf .= $char;
    my $str = Irssi::parse_special('$L');

    print_to_input($str);
    
}

sub print_to_input {
    my ($str) = @_;
    $str = "%8$str%8";

    my ($term_w, $term_h) = Term::Size::chars *STDOUT{IO};

    my $prompt_offset = 11;
    my $theme = Irssi::current_theme();
    my $prompt = $theme->format_expand('{prompt $itemname $winname}',
                                       Irssi::EXPAND_FLAG_RECURSIVE_MASK);
    #print "Prompt is $prompt";
    Irssi::gui_printtext($prompt_offset, $term_h, $str);
}


sub parse_theme_file {
    my ($file) = @_;
    open my $fh, '<', $file or die "Couldn't open $file for reading: $!";
    while (my $line = <$fh>) {
        next if $line =~ m/^\s*#/; # comment
        if ($line =~ m/^\s*prompt\s*=\s*"([^"]+)";\s*$/) {
            my $prompt = $1;
        }
    }
    close $fh or die "Couldn't close fh for $file: $!";
}
