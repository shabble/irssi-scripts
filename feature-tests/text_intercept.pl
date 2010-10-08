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

my $ignore_flag = 0;

Irssi::signal_add 'print text' => \&handle_text;


sub handle_text {
    my ($dest, $text, $stripped) = @_;

    return if $ignore_flag;

    Irssi::signal_stop();

    $text =~ s/a/b/g;

    $ignore_flag = 1;
    $dest->print($text);
    $ignore_flag = 0;
}
