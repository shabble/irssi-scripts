
use strict;
use warnings;

use Data::Dumper;

# not sure of hte original source author, but probably based on
# autorejoin.pl: http://scripts.irssi.org/html/autorejoin.pl.html

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble, dunno original source',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'GPLv2',
              updated     => '$DATE'
             );


use Irssi;
use Irssi::Irc;


sub event_rejoin_kick  {
    my ($server, $data) = @_;
    my ($channel, $nick) = split(/ +/, $data);

    return if ($server->{nick} ne $nick);

    my $chanrec = $server->channel_find($channel);
    my $password = $chanrec->{key} if ($chanrec);

    Irssi::print "Rejoining $channel...";

    $server->send_raw("JOIN $channel $password");
}

sub event_rejoin_unban {
    my ($server, $data, $nick, $address) = @_;
    my ($target, $text) = $data =~ /^(\S*)\s:(.*)/;

    if ($text =~ m/(\w+) has been unbanned from (#?\w+)/) {
        my ($nick, $channel) = ($1, $2);
        my $chanrec = $server->channel_find($channel);
        my $password = $chanrec->{key} if ($chanrec);

        Irssi::print "Rejoining $channel...";
        $server->command("JOIN $channel $password");
    }
}

sub event_unban {
    my ($server, $data) = @_;
    my ($nick, $channel) = split(/ +/, $data);

    Irssi::print "Attempting unban on $channel...";
    $server->send_raw("PRIVMSG ChanServ unban $channel");
}

sub sig_msg_kick {
    my ($server, $channel, $victim, $kicker, $addr, $reason) = @_;

}

sub sig_msg_notice {
    my ($server, $msg, $nick, $addr, $target) = @_;

}

sub sig_event_joinfail_banned {

}

sub init {

    Irssi::signal_add('message kick',   'sig_msg_kick');
    Irssi::signal_add('message notice', 'sig_msg_notice');
    Irssi::signal_add('event 474',      'sig_event_joinfail_banned');

}

init();
