################################################################################
## WARNING!! BAD ENGLISH BELOW :P
##
## This script is designed for those who have been using muh irc bouncer.
## Basicly this script just monitors the proxy module and if new client
## connects it sets you automatically back from away state and when client
## disconnects it sets you automatically away if you arent allready away.
##
## Other hand if you dont use irssi-proxy you still have a good reason to
## use this if you want to forward messages that come to you while
## you are away to email box.
## This is useful for forwarding messages to an SMS-gateway ;)
##
## btw.. if you find any bugs or have any ideas for development of this
## script dont hesitate to send msg to BCOW@IrcNET
## or send email to anttip@n0-life.com
##
#### Version history:
# 0.1
#  * basic functionality
# 0.2b
#  * a patch from Wulf that gives a user ability to change the autoaway reason.
#  * Added away_level parameter that gives you ability to control how many
#    clients there can be connected to the irssi_proxy module before you are
#    set away.
#  * You arent set away when disconnecting from the irssi_proxy if you already
#    are away. This means that your current away reason isn't changed.
#  * Sends cumulated away messages back to the client when it connects to the
#    irssi_proxy module.
# 0.2c
#  * Fixes bug where cummulated messages weren't sent.
#  * Code cleanup.
#  * Text wrapping to standart 80x24 text console.
#  * Added debug mode.
#  * Added script modes.
#  * Got rid of crappy irssi setings system.
#  * New logging expansion capability, either time or line based.
# 0.2d
#  * Micro fix to get back only when needed
#### To come / planned / wanted:
#  * Make expansion system log several channels at once.
#  * Make this script server based.
################################################################################

use strict;
use warnings;

# irssi imports
use Irssi;
use Irssi::Irc;
#use vars qw($VERSION %IRSSI %config);

our $VERSION = "0.3";
our %IRSSI = (
              authors     => "shabble,BCOW",
              contact     => "anttip\@n0-life.com",
              name        => "awayproxy",
              description => "Sets nick away when client discconects from the "
              . "irssi-proxy. If away gathers messages targeted to nick and forwards "
              . "them to an email address.",
              license     => "GPLv2",
              url         => "http://www.n0-life.com",
             );

sub MODE_BOTH  () { 0 }
sub MODE_EMAIL () { 1 }
sub MODE_IRC   () { 2 }
sub MODE_OFF   () { 3 }

sub mode_should_email {
    return grep { $_ == $config{script_mode} } (MODE_EMAIL, MODE_BOTH);
}
sub mode_should_irc {
    return grep { $_ == $config{script_mode} } (MODE_IRC, MODE_BOTH);
}

my %config =
  (

   # After how much seconds we can check if there are any messages to send?
   check_interval => 45,

   # this setting controls that when this amout of clients are connected to the
   # proxy module script sets you away. If you set this to 0 you are set away when
   # no clients are connected to the proxy module. If you set this to lets say 5
   # then you will be set away allways when the amount of clients connected to the
   # proxy module is 5 or under.
   away_level => 0,

   # Controls expansion mode. This mode records pub msgs that come after one with
   # your nick in it. you can use line counting or time counting.
   #  0 - off
   #  line - line counting
   #  time - time counting
   expansion_mode => 'time',

   # How many lines include after start line?
   expansion_lines => 12,

   # After how many seconds stop gathering msgs?
   expansion_timeout => 90,

   # script operation mode:
   #  0 - to send messages both to email and when you get back to proxy
   #  1 - only email
   #  2 - only irc
   #  3 - off
   script_mode => MODE_EMAIL,

   # email address where to send the email
   email_to => 'email@email.org',

   # sendmail location
   sendmail => '/usr/sbin/sendmail',

   # who is the sender of the email
   email_from => 'email@email.org',

   # Subject of email
   email_subject => '[irssi-proxy]',

   # and the awayreason setting (Thanx Wulf)
   awayreason => 'Auto-away because client has disconnected from proxy.',

   # Debugging mode
   debug => 0,

   # -- Don't change anything below this line if you don't know Perl. --
   # number of clients connected
   clientcount => 0,
   # number of lines recorded
   expansion_lines_count => 0,

   expansion_started => 0,
   # the small list and archive list
   awaymsglist => [],
   awaymsglist_irc => [],

  );                            # end of config init

if (mode_should_email()) {

	# timeouts for check loop
	_debug('Timer on, timeout: ' . $config{check_interval});
	Irssi::timeout_add($config{check_interval} * 1000, 'msgsend_check', '');
}

sub _debug {
	if ($config{debug}) {
		my $text = shift;
		my $caller = caller;
		Irssi::print('From ' . $caller . ":\n" . $text);
	}
}

sub msgsend_check {
	# If there are any messages to send
	my $count = @{$config{awaymsglist}};
	_debug("Checking for messages: $count");
	# Check if we didn't grep msgs right now
	if ($count > 0 && !$config{expansion_started}) {
		# Concentate messages into one text.
		my $text = join "\n", @{$config{awaymsglist}};
		# Then empty list.
		$config{awaymsglist} = [];
		# Finally send email
		_debug("Concentated msgs: $text");
		send_mail($text);
	}
}

sub send_mail {
	my $text = shift;
	_debug("Sending mail");

	open my $mail_fh, '|', $config{sendmail} . " -t"
                                  or warn "Failed to open pipe to sendmail";

    return unless $mail_fh;

	print $mail_fh "To: $config{email_to}\n";
	print $mail_fh "From: $config{email_from}\n";
	print $mail_fh "Subject: $config{email_subject}\n";
	print $mail_fh "\n$text\n";
	close $mail_fh;
}

sub client_connect {
	my (@servers) = Irssi::servers;

	$config{clientcount}++;

	_debug("Client connected, current script mode: $config{script_mode}");

	# setback
	foreach my $server (@servers) {
		# if you're away on that server send yourself back
		if ($server->{usermode_away} == 1) {
			$server->send_raw('AWAY :');
			# and then send the current contents of archive list as notify's to
			# your self ;)
			# .. weird huh? :)
			# This sends all the away messages to ALL the servers where you are
			# connected... this is somewhat weird i know
			# but if someone wants to make a patch to this i would really
			# appreciate it.
			if (mode_should_irc()) {
				_debug('Sending notices');
				$server->send_raw('NOTICE ' . $server->{nick} . " :$_")
                  for @{$config{awaymsglist_irc}};
			}
		}
	}
	# and "clear" the irc awaymessage list
	$config{awaymsglist_irc} = [] if mode_should_irc();
}

sub client_disconnect {
	my (@servers) = Irssi::servers;
	_debug('Client Disconnectted');

	$config{clientcount}-- unless $config{clientcount} == 0;

	# setaway
	if ($config{clientcount} <= $config{away_level}) {
		# ok.. we have the away_level of clients connected or less.
		foreach my $server (@servers) {
			if ($server->{usermode_away} == "0") {
				# we are not away on this server allready.. set the autoaway
				# reason
				$server->send_raw(
                                  'AWAY :' . $config{awayreason}
                                 );
			}
		}
	}
}

sub msg_pub {
	my ($server, $data, $nick, $mask, $target) = @_;

	if ($config{expansion_started}) {
		if ($config{expansion_mode} eq 'line') {
			if ($config{expansion_lines_count} <= $config{expansion_lines} -1) {
				if ($config{expansion_chan} eq $target) {
					_debug("In effect from line expansion, pushing on. Cnt: "
                           . $config{expansion_lines_count});
					push_into_archive($nick, $mask, $target, $data);
					$config{expansion_lines_count}++;
				}
			} else {
				_debug("Line counter reached max, stopping expansion");
				$config{expansion_lines_count} = 0;
				$config{expansion_started} = 0;
				$config{expansion_chan} = '';
			}
		} elsif ($config{expansion_mode} eq 'time') {
			if ($config{expansion_chan} eq $target) {
				_debug("Time expansion in effect, pushing on.");
				push_into_archive($nick, $mask, $target, $data);
			}
		}
	} elsif ($server->{usermode_away} == 1 && $data =~ /$server->{nick}/i) {
		_debug("Got pub msg with my name");
		push_into_archive($nick, $mask, $target, $data);
		if ($config{expansion_mode}) {
			_debug("Starting expansion in mode: " . $config{expansion_mode});
			$config{expansion_started} = 1;
			$config{expansion_chan} = $target;

            if ($config{expansion_mode} eq 'time') {
                $config{expansion_time_out}
                  = Irssi::timeout_add(
                                       $config{expansion_timeout} * 1000,
                                       'expansion_stop',
                                       ''
                                      );
            }

		}
	}
}

sub push_into_archive {
    my ($nick, $mask, $target, $data) = @_;

    # simple list that is emptied on the email run
    push @{$config{awaymsglist}}, "<$nick!$mask\@$target> $data"
                                  if mode_should_email();
    # archive list that is emptied only on the client connect run
    push @{$config{awaymsglist_irc}}, "<$nick!$mask\@$target> $data"
                                  if mode_should_irc();
}

sub expansion_stop {
	_debug("Stopping expansion from timer");
	$config{expansion_started} = 0;
	$config{expansion_chan} = '';
}

sub msg_pri {
	my ($server, $data, $nick, $address) = @_;
	if ($server->{usermode_away} == 1) {
		_debug("Got priv msg");
		# simple list that is emptied on the email run
		push @{$config{awaymsglist}}, "<$nick!$address> $data"
          if mode_should_email();
		# archive list that is emptied only on the client connect run
		push @{$config{awaymsglist_irc}}, "<$nick!$address> $data"
          if mode_should_irc();
	}
}

sub init {

    Irssi::settings_add_string('awayproxy', 'awayproxy_send_mode', MODE_EMAIL);

    Irssi::signal_add_last('proxy client connected',    \&sig_client_connect);
    Irssi::signal_add_last('proxy client disconnected', \&sig_client_disconnect);
    Irssi::signal_add_last('message public',            \&sig_msg_public);
    Irssi::signal_add_last('message private',           \&sig_msg_private);
    Irssi::signal_add('setup changed',                  \&sig_setup_changed);

    sig_setup_changed();
}

sub sig_setup_changed {
     # load values from settings.
}
