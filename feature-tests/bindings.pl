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
              licence     => q(GNU GPLv2 or later),

             );

# code taken from adv_windowlist

my $keymap;

init();

sub init {
    update_keymap();
    Irssi::command_bind('showbinds', 'cmd_showbinds');
}

sub cmd_showbinds {
    my ($args, @rest) = @_;

    my $win = Irssi::active_win();
    $win->print("Change window bindings:", Irssi::MSGLEVEL_CLIENTCRAP);
    for my $w (sort keys %$keymap) {
        my $x = $keymap->{$w};
        $win->print("$w ==> $x", Irssi::MSGLEVEL_CLIENTCRAP);
    }
    $win->print("Done showing window bindings:", Irssi::MSGLEVEL_CLIENTCRAP);

}
sub get_keymap {
	my ($text_dest, $str, $str_stripped) = @_;

	if ($text_dest->{level} == Irssi::MSGLEVEL_CLIENTCRAP and $text_dest->{target} eq '') {
        if (not defined($text_dest->{'server'})) {
            if ($str_stripped =~ m/((?:meta-)+)(.)\s+change_window (\d+)/) {
                my ($level, $key, $window) = ($1, $2, $3);
                #my $numlevel = ($level =~ y/-//) - 1;
                my $kk = $level . $key;
                $keymap->{$kk} = $window;
            }
            Irssi::signal_stop();
        }
    }
}

sub update_keymap {
	$keymap = {};
	Irssi::signal_remove('command bind' => 'watch_keymap');
	Irssi::signal_add_first('print text' => 'get_keymap');
	Irssi::command('bind'); # stolen from grep
	Irssi::signal_remove('print text' => 'get_keymap');
	Irssi::signal_add('command bind' => 'watch_keymap');
	#Irssi::timeout_add_once(100, 'eventChanged', undef);
}

# watch keymap changes
sub watch_keymap {
	Irssi::timeout_add_once(1000, 'update_keymap', undef);
}



