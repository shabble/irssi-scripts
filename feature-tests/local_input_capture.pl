use strict;
use warnings;


use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;


our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'Public Domain',
             );

my $buffer = '';
init();

sub init {

    Irssi::signal_add_first 'print text', 'sig_print_text';
    Irssi::command 'echo Hello there';
    Irssi::signal_remove 'print text', 'sig_print_text';
    Irssi::command_bind 'showbuf', 'cmd_showbuf';
}

sub cmd_showbuf {
    my ($args, $server, $win_item) = @_;
    my $win;
    if (defined $win_item) {
        $win = $win_item->window();
    } else {
        $win = Irssi::active_win();
    }

    $win->print("buffer is: $buffer");
    $buffer = '';
}

sub sig_print_text {
    my ($text_dest, $str, $stripped_str) = @_;

    $buffer .= $stripped_str;
    Irssi::signal_stop;
}
