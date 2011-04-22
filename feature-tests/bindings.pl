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

sub STATE_HEADER () { 0 }
sub STATE_BODY   () { 1 }
sub STATE_END    () { 2 }
my $parse_state = STATE_HEADER;

my $binding_formats = {};

init();

sub init {

    $keymap = {};

    Irssi::command_bind('showbinds', 'cmd_showbinds');
	Irssi::signal_add('command bind' => 'watch_keymap');

    $binding_formats = get_binding_formats();

    capture_bind_data();
}

sub get_binding_formats {
    my $theme = Irssi::current_theme();
    my @keys = qw/bind_header bind_list bind_command_list
                  bind_footer bind_unknown_id/;

    my $ret = {};
    foreach my $key (@keys) {
        my $tmp = $theme->get_format('fe-common/core', $key);
        #$tmp =~ s/%/%%/g; # escape colour codes?
        $ret->{$key} = $tmp;
    }
    return $ret;
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

sub sig_print_text {
	my ($text_dest, $str, $str_stripped) = @_;

    return unless $text_dest->{level} == Irssi::MSGLEVEL_CLIENTCRAP;
    return unless $text_dest->{target} eq '';
    return unless not defined $text_dest->{server};

    # if ($parse_state = STATE_HEADER) {
    #     if ($str =~ m/\Q$binding_formats->{bind_header}\E/) {
    #         $parse_state = STATE_BODY;
    #     }
    # } elsif ($parse_state = STATE_BODY) {
    print "Data is: $str_stripped";
    if ($str_stripped =~ m/^.*?(\S{,20})\s+(\S+)\s+(\S+)/) {
        $keymap->{$1} = "$2, $3";
        print "Parsed $1 as $2, $3";
    }
    Irssi::signal_stop();
    #     } elsif ($str =~ m/$binding_formats->{bind_footer}\E/) {
    #         $parse_state = STATE_END;
    #     }
    # }
}


sub capture_bind_data {
	Irssi::signal_remove('command bind' => 'watch_keymap');
	Irssi::signal_add_first('print text' => 'sig_print_text');
	Irssi::command('bind'); # stolen from grep
	Irssi::signal_remove('print text' => 'sig_print_text');

}


# watch keymap changes
sub watch_keymap {
	Irssi::timeout_add_once(1000, 'capture_bind_data', undef);
}



