# This script was initially written by shabble, this fork (and molestation) is
# built upon his original work.
#
# USAGE:
#
# the primary command used is /join+ #channelname
#
# Mappings for channels and servers are retrieved from irssi's internal
# /channel list
#
# Then use /join+ #foo, and if you are not already connected to freenode, it
# will connect you, and then join that channel.

# TODO:
# address conflict resolution
# fix that disgusting race condition
# Fix incredibly slow shutdown time after a few days

use strict;
use warnings;


use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;


my $DEBUG_ENABLED = 0;
sub DEBUG () { $DEBUG_ENABLED }

sub _debug_print {
    return unless DEBUG;
    return unless scalar (grep { defined && length } @_) == @_;
    my $win = Irssi::active_win;
    my $str = join('', @_);
    $win->print($str, Irssi::MSGLEVEL_CLIENTCRAP);
}

our $VERSION = '0.1';

our %IRSSI = (
              authors     => 'shabble, richo',
              contact     => 'richo@psych0tik.net',
              name        => 'auto-join-ng',
              description => 'connects to a specified server in order to connect' .
                             ' to a channel there, without having first to' .
                             ' connect to the server',
              license     => 'Public Domain',
             );

my $channel_map = {};
my @hack_channels;
my $pending_joins;

sub auto_server_init {
    Irssi::command_bind('join+', \&join_plus);
    Irssi::settings_add_str('join_plus', 'joinplus_server_maps', '');
    Irssi::signal_add_last('setup changed', \&setup_changed);
    Irssi::settings_add_bool('join_plus', 'join_plus_debug', 0);

    setup_changed();
    $pending_joins = {};

}

sub setup_changed {
    $DEBUG_ENABLED  = Irssi::settings_get_bool('join_plus_debug');
    parse_channel_map();
}

# This is a tremendous kludge.
# If anyone knows a better way to get this listing, I'd like to hear it.
# This has so many race condition bugs I just don't even know where to start.
sub retrieve_channels {
    @hack_channels = ();
    Irssi::signal_add_first('print text', 'haxy_print_hook');
    Irssi::command("CHANNEL LIST");
    Irssi::signal_remove('print text', 'haxy_print_hook');
    return join(" ", @hack_channels);
}


# The idea for how to do this courtesy of http://wouter.coekaerts.be/site/irssi/aliases
sub haxy_print_hook {
    Irssi::signal_remove('print text', 'haxy_print_hook');
    Irssi::signal_stop();
    my $data = $_[1];
    # Hose control characters
    $data =~ s/\x04.//g;
    if ($data =~ m/^[#&!]/) {
        my @items = split /\s+/, $data;
        push(@hack_channels, $items[0]);
        push(@hack_channels, $items[1]);
    }
    Irssi::signal_add_first('print text', 'haxy_print_hook');
}

sub parse_channel_map {
    #my $data = Irssi::settings_get_str('joinplus_server_maps');
    my $data = retrieve_channels();
    unbind_completion();
    my @items = split /\s+/, $data;
    if (@items % 2 == 0) {
        $channel_map = { @items }; # risky?
    } else {
        Irssi::active_win->print("Could not process channel => server mappings");
        $channel_map = {};
    }
    #_debug_print Dumper($channel_map);
    bind_completion();
}

sub bind_completion {
    foreach(%$channel_map) {
        Irssi::command_bind("join+ $_", \&join_plus);
    }
}

sub unbind_completion {
    foreach(%$channel_map) {
        Irssi::command_unbind("join+ $_", \&join_plus);
    }
}

sub join_plus {
    my ($args, $cmd_server, $witem) = @_;
    #print Dumper($cmd, "moo", $win);

    # parse out channel name from args:
    my $channel;
    if ($args =~ m/^([#&!]?[^ ]*)/) {
        $channel = $1;
        _debug_print ("Channel is: $channel");
    }

    unless ($channel) {
        Irssi::active_win()->print("Channel $args not recognised");
        return;
    }

    # lookup server
    my $server_id = $channel_map->{$channel};
    _debug_print($server_id);

    unless ($server_id) {
        Irssi::active_win()->print("Channel $channel does not have an"
                                   . " appropriate server mapping");
            return;
    }
    # TODO: search values() and give a 'did you mean' for closest channel
    # TODO: Fuzzy match for ## channels (Would be nice to hax at teh tab
    # completion too)

    # check if we're connected to that server
    my $server = Irssi::server_find_tag($server_id);

    if (not defined $server) {
        $server = Irssi::server_find_chatnet($server_id);
    }

    if (not defined $server) {
        # still no server, walk the server list looking for address matches.
        my @servers = Irssi::servers();
        foreach my $srv (@servers) {
            if (($srv->{address} eq $server_id) or
                ($srv->{real_address} eq $server_id)) {
                $server = $srv;
                last;
            }
        }
    }

    if (defined $server) {

        _debug_print ("Already connected to server: " . $server->{tag} );

        # check if we're already on the required channel
        my $on_channel = $server->channel_find($channel);

        # FIXME
        # Should this be $on_channel? Need docs..
        if (defined $channel && ref($channel) eq 'Irssi::Irc::Channel') {
            Irssi::active_win()->print("You are already connected to "
                                       . " $channel on " . $server->{tag});
            return;
        } else {
            _debug_print ("joining channel: $channel");
            $server->command("JOIN $channel");
        }
    } else {
        # not connected to server.
        _debug_print ("connecting to server: $server_id");

        Irssi::command("CONNECT $server_id");
        _debug_print ("awaiting connection for join");

        $pending_joins->{$server_id} = $channel;
        # This comes tumbling down if the server doesn't have a MOTD.
        # is that RFC required?
        Irssi::signal_add_last("event 376", 'do_channel_join');
    }
}

sub do_channel_join {
    Irssi::signal_remove("event 376", 'do_channel_join');
    my ($serv) = @_;
    #_debug_print("server is " . Dumper($serv));
    _debug_print(sprintf("server is %s (%s)", $serv->{address}, $serv->{tag}));

    my $channel = $pending_joins->{$serv->{address}};
    $channel = $pending_joins->{$serv->{tag}} unless $channel;
    if ($channel) {
        _debug_print ("attempting to join $channel");

        Irssi::server_find_tag($serv->{tag})->command("JOIN $channel");

        delete $pending_joins->{$serv->{address}};
        delete $pending_joins->{$serv->{tag}};
    }

}

auto_server_init();
