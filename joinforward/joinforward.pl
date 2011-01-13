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
              name        => 'joinforward.pl',
              description => '',
              license     => 'Public Domain',
             );

my $forwards;


init();


sub init() {
    Irssi::signal_add('event 470', 'sig_470');
    Irssi::signal_add('event 473', 'sig_473');
}

sub sig_470 {
    my ($server, $args, $sender) = @_;
    #'shibble #mac ##mac :Forwarding to another channel',
    my $nick = quotemeta(Irssi::parse_special('$N'));
    if ($args =~ m/^$nick (#.*?)\s+(#.*?)\s+(.*)$/) {
        $forwards->{$1} = $2;
    }
}

sub sig_473 {
    my ($server, $args, $sender) = @_;
    #" shibble #mac :Cannot join channel (+i) - you must be invited',"
    if ($server->{version} =~ m/ircd-seven/) { # assume freenode
        my $nick = quotemeta(Irssi::parse_special('$N'));
        if ($args =~ m/^$nick\s+(#.*?)\s+/) {
            if (exists $forwards->{$1}) {
                $server->command("window goto " . $forwards->{$1});
            }
        }


    }
}
