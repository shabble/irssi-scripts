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


sub init {
    Irssi::signal_add('event 470', 'sig_470'); # forwarding (on freenode, anhywya)
    Irssi::signal_add('event 473', 'sig_473'); # notinvited.
    # or better to just overload /join?
    Irssi::command_bind('fwdlist', 'cmd_fwdlist');
    print "Joinforward loaded";
}

sub cmd_fwdlist {
    print "Known Forwards:";
    foreach my $fwd (sort keys %$forwards) {
        print "$fwd -> " . $forwards->{$fwd};
    }
}

sub sig_470 {
    my ($server, $args, $sender) = @_;
    #'shibble #mac ##mac :Forwarding to another channel',
    print "Sig 470: $args";
    if ($args =~ m/(#.*?)\s+(#.*?)/) {
        $forwards->{$1} = $2;
        print "adding $1 -> $2";
    }
}

sub sig_473 {
    my ($server, $args, $sender) = @_;
    print "Sig 473: $args";
    #" shibble #mac :Cannot join channel (+i) - you must be invited',"
    if ($server->{version} =~ m/ircd-seven/) { # assume freenode
        if ($args =~ m/^(#.*?)\s+/) {
            if (exists $forwards->{$1}) {
                $server->command("join " . $forwards->{$1});
            }
        }


    }
}
