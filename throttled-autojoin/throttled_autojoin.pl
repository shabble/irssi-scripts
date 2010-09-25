use strict;
use vars qw($VERSION %IRSSI);

use Irssi;

$VERSION = '0.1';
%IRSSI = (
          authors     => 'Shabble',
          contact     => 'shabble+irssi /at/ metavore /dot/ org',
          name        => 'Autojoin channels with a configurable delay',
          description => 'Mass autojoining can confuse some servers and slow/crash irssi.'
          . ' This is an alternative.',
          license     => 'WTFPL',
         );

# settings

Irssi::settings_add_int('throttled_autojoin', 'autojoin_initial_delay', 1000);
Irssi::settings_add_int('throttled_autojoin', 'autojoin_repeat_delay', 1000);
Irssi::settings_add_bool('throttled_autojoin', 'autojoin_auto_start', 0);

# format is space-separated list of '$tag/$channel'
Irssi::settings_add_str('throttled_autojoin', 'autojoin_channels', '');

my @join_queue = ();
my $autojoin_initialised = 0;
my $autojoin_running = 0;
my $autojoin_timer;
my $chan_list = {};

sub parse_channel_settings {
    my $chan_str = Irssi::settings_get_str('autojoin_channels');

    return unless length $chan_str;

    my @chans = split /\s+/, $chan_str;
    foreach my $chan (@chans) {
        if ($chan =~ m|(.*?)/(#.+)|) {
            push @{$chan_list->{$1}}, $2;
        } else {
            Irssi::print("Failed to parse channel setting: $chan");
        }
    }
}

sub handle_server_connected {
    my ($server) = @_;
    # add all the channels for the server in our setting into the queue.
    my $tag = $server->{tag};
    my $chatnet = $server->{chatnet};
    if (exists $chan_list->{$chatnet}) {
        my @chans = @{ $chan_list->{$chatnet} };
        foreach my $chan (@chans) {
            push @join_queue, [$server, $chan];
        }
        print "Server $tag ($chatnet) connected, adding "
          . join(", ", @chans) . " to join queue";

        # restart queue processing if it had stopped already.
        if ($autojoin_initialised && !$autojoin_running) {
            begin_queue_processing();
        }

    } else {
        print "Server joined, but no channels to autojoin";
    }
}

sub startup {
    my $initial_interval = Irssi::settings_get_int('autojoin_initial_delay') // 1000;

    parse_channel_settings();
    $autojoin_initialised = 0;

    Irssi::timeout_add_once($initial_interval, \&intialise_autojoin, 0);
}

sub intialise_autojoin {
    $autojoin_initialised = 1;
    begin_queue_processing();
}

sub begin_queue_processing {
    my $repeat_interval = Irssi::settings_get_int('autojoin_repeat_delay') // 1000;
    $autojoin_timer = Irssi::timeout_add($repeat_interval, \&process_queue, 0);
    $autojoin_running = 1;

}

sub process_queue {

    unless (@join_queue) {
        print "Join Queue empty, shutting down queue processor";
        $autojoin_running = 0;
        Irssi::timeout_remove($autojoin_timer);
        $autojoin_timer = undef;
        return;
    }
    # dequeue an item, and try to join it.
    my $next = shift @join_queue;
    my ($server, $channel) = @$next;
    if ($server->{connected} && !($server->channel_find($channel))) {
        $server->command("JOIN $channel");
    }
}

# listen for server connected.
Irssi::signal_add('server connected', \&handle_server_connected);

my $auto_start = Irssi::settings_get_bool('autojoin_auto_start') // 0;
if ($auto_start) {
    startup();
} else {
    Irssi::command_bind('autojoin', \&startup, 0);
}
