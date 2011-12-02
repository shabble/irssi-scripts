# todo: grap topic changes

use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '0.0.1';
%IRSSI = (
    authors     => 'richo',
    contact     => 'richo@psych0tik.net',
    name        => 'bnotify',
    description => 'Write notifications based on who\'s talking to you, also handle some window management and tmux alerts',
    url         => 'http://natalya.psych0tik.net/~richo/bnotify',
    license     => 'GNU General Public License',
    changed     => '$Date: 2011-06-21 21:51:30 +1000 (Tue, 21 Jun 2011) $'
);
# Originally based on fnotify.pl 0.0.3 by Thorsten Leemhuis
# fedora@leemhuis.info
# 'http://www.leemhuis.info/files/fnotify/',
#
#--------------------------------------------------------------------
# In parts based on knotify.pl 0.1.1 by Hugo Haas
# http://larve.net/people/hugo/2005/01/knotify.pl
# which is based on osd.pl 0.3.3 by Jeroen Coekaerts, Koenraad Heijlen
# http://www.irssi.org/scripts/scripts/osd.pl
#
# Other parts based on notify.pl from Luke Macken
# http://fedora.feedjack.org/user/918/
#
#--------------------------------------------------------------------

# TODO
# Add settings for which networks to beep on

my @alert_nets = ();
sub bnotify_init {
    Irssi::settings_add_str('bnotify', 'bnotify_alert_nets', '');
    @alert_nets = split(/ /, Irssi::settings_get_str('bnotify_alert_nets'));
}

#--------------------------------------------------------------------
# Private message parsing
#--------------------------------------------------------------------
# TODO
# Test to see if the privmsg went to a status window, and is from bitlbee in
# which case send it to it's own window

sub priv_msg {
    my ($server,$msg,$nick,$address,$target) = @_;
    # Does this expose issues if someone includes regexp chars in their server
    # tag?
    if (grep(/^$server->{tag}$/, @alert_nets)) {
        Irssi::command('beep');
    }
    filewrite($server->{tag}.":".$nick." private");
    #Irssi::settings_set_str('autocreate_query_level', 'DCCMSGS MSGS');
}

#--------------------------------------------------------------------
# Private msg windowing
#--------------------------------------------------------------------

sub priv_msg_winhook {
    my ($server,$msg,$nick,$address,$target) = @_;
    if (grep($server->{tag}, @alert_nets)) {
        Irssi::settings_set_str('autocreate_query_level', 'DCCMSGS MSGS');
    }
}

#--------------------------------------------------------------------
# Printing hilight's
#--------------------------------------------------------------------

sub hilight {
    my ($dest, $text, $stripped) = @_;
    if ($dest->{level} & MSGLEVEL_HILIGHT) {
        filewrite($dest->{server}->{tag}.":".$dest->{target}. " " .$stripped );
    }
}

#--------------------------------------------------------------------
# Handle Arguments
#--------------------------------------------------------------------

sub cmd_add {
    my $net = shift;
    if (not grep($net, @alert_nets)) {
        push @alert_nets, $net;
        Irssi::active_win->print("Added $net to alert networks.");
    } else {
        Irssi::active_win->print("$net already configured to alert.");
    }
}

sub cmd_del {
    my $net = shift;
    my @valid;
    my $idx = 0;
    while ($idx <= $#alert_nets) {
        if (lc($alert_nets[$idx]) eq lc($net)) {
            push @valid, $alert_nets[$idx];
        }
        $idx++;
    }
    if ($#alert_nets != $#valid) {
        Irssi::active_win->print("Removed $net from alert networks.");
    } else {
        Irssi::active_win->print("$net didn't exist in alert networks.");
    }
    @alert_nets = @valid;
}

#--------------------------------------------------------------------
# The actual printing
#--------------------------------------------------------------------

sub filewrite {
    my ($text) = @_;
    open(FILE, '>' .Irssi::get_irssi_dir() . '/fnotify');
    print FILE $text . "\n";
    close (FILE);
}

#--------------------------------------------------------------------
# Irssi::signal_add_last / Irssi::command_bind
#--------------------------------------------------------------------

Irssi::signal_add_first("message private", "priv_msg_winhook");
Irssi::signal_add_last("message private", "priv_msg");
Irssi::signal_add_last("print text", "hilight");

Irssi::command_bind('bnotify add', \&cmd_add);
Irssi::command_bind('bnotify del', \&cmd_del);
bnotify_init();

#- end
