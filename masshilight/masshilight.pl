# disable hilighting of mass-hilights
# (messages which contain a lot of nicknames)
#
# DESCRIPTION
# sometimes a jester annoys a channel with a message
# containing a lot of nicks that are in that channel.
# this script prevents hilighting of a window in this
# case. number of nicks in the message is user
# configurable in the variable mass_highlight_threshold.
#
# CHANGELOG
# * 01.05.2004
# fixed problems with nicks containing brackets
# added comments, description and this changelog :)
# * 30.05.2004
# first version of the script
# * 21.08.2010
# modified it a lot to work with pubmessages so it has access to
# the sender and channel more easily. Also added configurable actions
# to take when flooding is detected.

use Irssi;
use strict;
use warnings;

use vars qw($VERSION %IRSSI);

$VERSION = "0.2";
%IRSSI = (
    authors         => "Uli Baumann, Tom Feist",
    contact         => 'f-zappa@irc-muenster.de, shabble+irssi@metavore.org',
    name            => "mass_hilight_action",
    description     => "Customisable command on messages containing a lot of nicknames",
    license         => "GPL",
    changed         => "Sat 21 Aug 2010 22:29:22 BST",
);

sub sig_msg_pub {
    my ($server, $msg, $nick, $address, $target) = @_;

    my $num_nicks= -1;                    # don't count target's nick
    my $max_num_nicks
      = Irssi::settings_get_int('mass_hilight_threshold');

    my $channel =  $server->channel_find($target);

    foreach my $nick ($channel->nicks()) {
        $nick = $nick->{nick};
        $nick =~ s/([\]\[])/\\$1/g;   # ']' and '[' need masking

        $num_nicks++ if ($msg =~ /\Q$nick\E/);
    }

    if ($num_nicks >= $max_num_nicks) {
        my $action_val = Irssi::settings_get_str('mass_hilight_action');
        my @actions = split /\s*;\s*/, $action_val;
        foreach my $action (@actions) {
            if ($action =~ m/suppress/i) {
                Irssi::signal_stop(); # don't display it at all.
            } elsif ($action =~ m/kick/) {
                $server->command("/KICK $target $nick");
            } else {
                $action =~ s/\$nick/$nick/;
                $action =~ s/\$chan/$target/;
                $action =~ s/\$host/$address/;

                $server->command($action);
            }
        }
    }
}

# tell irssi to use this and initialize variable if necessary

Irssi::signal_add_first('message public', \&sig_msg_pub);
Irssi::settings_add_int('misc','mass_hilight_threshold', 3);
Irssi::settings_add_str('misc', 'mass_hilight_action', 'suppress');

# Irssi::command_bind('testmasshilight', sub { my $args = shift;
#                                              sig_msg_pub(Irssi::active_server(),
#                                                          $args,
#                                                          "bob",
#                                                          "bob!bob\@bob.bob",
#                                                          "#jfkdalfad");
#                                              });


__END__

Usage:

use /set mass_hilight_threshold to set how many matching nicks from the current
 are required to trigger the hilight flood detection.

use /set mass_hilight_action to configure what happens when they do.  You can specify
multiple actions, separated by ; (semicolons)

Two special actions exist: 'suppress', which prevents the message from being
displayed to you at all, and 'kick', which expands to the action '/kick #channel
$nick'.

Any other actions you wish to take are processed as regular Irssi commands, but
the following variables are replaced:

$nick - becomes the nick of the person who triggered this script
$chan - the channel in which it happened
$host - the hostmask of the offender

For example:

/set mass_hilight_action /echo hilight flooding by: $nick ; /kickban $chan $nick "Hilight flooding is not permitted here."
