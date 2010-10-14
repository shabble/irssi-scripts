use strict;
use warnings;

my $VERSION = "0.3";
my %IRSSI = (
  authors => 'Bazerka <bazerka@quakenet.org>',
  contact => 'bazerka@quakenet.org',
  name => 'cmpusers',
  description => 'compare channels for two users',
  licence => 'BSD',
  url => 'n/a',
);

use Irssi;
use Data::Dumper;

sub request_whois($$);
sub event_whois_user($$);
sub event_whois_channels($$);
sub event_whois_end($$);
sub event_whois_nosuchnick($$);
sub event_whois_timeout($$);
sub compare_channels();
sub cleanup();
sub to_casemap($);
sub cmd_cmpusers($$$);

my $debug = 0;

my $running = 0;
my @nick_list = ();
my %nick_info = ();
my %isupport = ();

# bahamut - % hidden chan;
my $custom_chanprefix = '%';


sub request_whois ($$) {
  my ($server, $nick) = @_;

  $server->redirect_event(
    'whois',
    1,
    $nick,
    0,
    'redir cmpusers_whois_timeout',
    {
      'event 311' => 'redir cmpusers_whois_user',
      'event 318' => 'redir cmpusers_whois_end',
      'event 319' => 'redir cmpusers_whois_channels',
      'event 401' => 'redir cmpusers_whois_nosuchnick',
      ''          => 'event empty',
    }
  );

  $server->send_raw("WHOIS $nick");
}


sub event_whois_user ($$) {
  my ($server, $data) = @_;

  my ($nick, $user, $host) = (split / +/, $data, 6)[1,2,3];
  my $casenick = to_casemap($nick);

  $nick_info{$casenick} = {
    'nick'     => $nick,
    'username' => $user,
    'hostname' => $host,
    'channels' => {},
  };

  Irssi::print("cmpusers whois_user: $nick!$user\@$host", MSGLEVEL_CLIENTCRAP) if $debug;
}


sub event_whois_channels ($$) {
  my ($server, $data) = @_;

  my ($nick, $channels) = (split / +/, $data, 3)[1,2];
  my $casenick = to_casemap($nick);
  $channels =~ s/^://;

  my @channel_list = split / /, $channels;

  foreach my $channel (@channel_list) {
    my $prefix = '';
    my $unknown_prefix = '';
    my $stripped_channel;

    Irssi::print("cmpusers whois_channels: channel \"$channel\"", MSGLEVEL_CLIENTCRAP) if $debug;
    for (my $i=0; $i<length($channel); $i++) {
      my $char = substr($channel, $i, 1);
      Irssi::print("cmpusers whois_channels: char \"$char\"", MSGLEVEL_CLIENTCRAP) if $debug;;

      if (index ($custom_chanprefix, $char) > -1) {
        $stripped_channel .= $char;
        Irssi::print("cmpusers whois_channels: stripped_channel \"$stripped_channel\"", MSGLEVEL_CLIENTCRAP) if $debug;
        next;
      }

      if (index ($isupport{'CHANTYPES'}, $char) > -1) {
        $stripped_channel .= substr($channel, $i, length($channel));
        Irssi::print("cmpusers whois_channels: stripped_chan \"$stripped_channel\"", MSGLEVEL_CLIENTCRAP) if $debug;
        last;
      }
      if (index ($isupport{'PREFIX'}, $char) > -1) {
        $prefix .= $char;
        Irssi::print("cmpusers whois_channels: prefix \"$prefix\"", MSGLEVEL_CLIENTCRAP) if $debug;
      } else {
        $unknown_prefix .= $char;
        Irssi::print("cmpusers whois_channels: unknown_prefix \"$prefix\"", MSGLEVEL_CLIENTCRAP) if $debug;
      }
    }

    $nick_info{$casenick}{'channels'}{$stripped_channel}{prefix} = $prefix;
    $nick_info{$casenick}{'channels'}{$stripped_channel}{unknown_prefix} = $unknown_prefix;
    Irssi::print("cmpuser whois_channels: stripped_channel \"$stripped_channel\"", MSGLEVEL_CLIENTCRAP) if $debug;
  }

  Irssi::print("cmpusers whois_channels: $nick - $channels", MSGLEVEL_CLIENTCRAP) if $debug;
}


sub event_whois_end ($$) {
  my ($server, $data) = @_;
  my ($nick) = (split / +/, $data, 3)[1];
  Irssi::print("cmpusers whois_end: $nick", MSGLEVEL_CLIENTCRAP) if $debug;

  return if $running == 0; # catch 318 -> 401 (nosuchnick followed by endofwhois)

  if (to_casemap($nick) eq $nick_list[0]) {
    request_whois($server, $nick_list[1]);
  } else {
    compare_channels();
  }
}


sub event_whois_nosuchnick ($$) {
  my ($server, $data) = @_;
  my $nick = (split / +/, $data, 4)[1];
  Irssi::active_win->print("cmpusers error: no such nick $nick - aborting.", MSGLEVEL_CLIENTCRAP);
  cleanup();
}


sub event_whois_timeout($$) {
  my ($server, $data) = @_;
  Irssi::print("cmpusers whois_timeout", MSGLEVEL_CLIENTCRAP) if $debug;
  Irssi::active_win->print("cmpusers error: whois timed out or failed. please try again.", MSGLEVEL_CLIENTCRAP);
  cleanup();
}


sub cleanup () {
  $running = 0;
  print Dumper \@nick_list if $debug;
  print Dumper \%nick_info if $debug;
  print Dumper \%isupport if $debug;
  @nick_list = ();
  %nick_info = ();
  %isupport = ();
  Irssi::print("cmpusers cleanup", MSGLEVEL_CLIENTCRAP) if $debug;
}


sub to_casemap ($) {
  my $nick = shift;
  my $type = $isupport{'CASEMAPPING'};

  for (my $i = 0; $i < length($nick); $i++) {
    my $ord = ord(substr($nick, $i, 1));

    if ($type == 1) { # rfc1459
      substr($nick, $i, 1) = ($ord >= 65 && $ord <= 94) ? chr($ord + 32) : chr($ord);
    } elsif ($type == 2) { # ascii
      substr($nick, $i, 1) = ($ord >= 65 && $ord <= 90) ? chr($ord + 32) : chr($ord);
    } else { # unknown
    }
  }

  return $nick;
}


sub compare_channels() {
  my @intersection = my @uniq_chans_0 = my @uniq_chans_1 = ();
  my %count = ();

  foreach my $element ( keys %{$nick_info{$nick_list[0]}{'channels'}}, keys %{$nick_info{$nick_list[1]}{'channels'}} ) {
    $count{$element}++;
    # nasty :<
    if ( exists $nick_info{$nick_list[0]}{'channels'}{$element} && (!exists $nick_info{$nick_list[1]}{'channels'}{$element})) {
      push @uniq_chans_0, $element;
    } elsif ((!exists $nick_info{$nick_list[0]}{'channels'}{$element}) && exists $nick_info{$nick_list[1]}{'channels'}{$element}) {
      push @uniq_chans_1, $element;
    }
  }
  foreach my $element (keys %count) {
    push @intersection, $element if $count{$element} == 2;
  }

  my $common_chans = join " ", sort @intersection;
  my $uniq0 = join " ", sort @uniq_chans_0;
  my $uniq1 = join " ", sort @uniq_chans_1;

  # workaround Irssi's crappy % handling. No, really, this irssi issue needs fixing.
  $common_chans =~ s/%/%%/g;
  $uniq0 =~ s/%/%%/g;
  $uniq1 =~ s/%/%%/g;

  Irssi::active_win->print(sprintf('Comparing user <%s!%s@%s> with user <%s!%s@%s>',
                                   $nick_info{$nick_list[0]}{'nick'},
                                   $nick_info{$nick_list[0]}{'username'},
                                   $nick_info{$nick_list[0]}{'hostname'},
                                   $nick_info{$nick_list[1]}{'nick'},
                                   $nick_info{$nick_list[1]}{'username'},
                                   $nick_info{$nick_list[1]}{'hostname'}), MSGLEVEL_CLIENTCRAP );

  Irssi::active_win->print(sprintf("Common channels for both users: %s", $common_chans), MSGLEVEL_CLIENTCRAP);
  Irssi::active_win->print(sprintf("Unique channels for %s: %s", $nick_info{$nick_list[0]}{'nick'}, $uniq0), MSGLEVEL_CLIENTCRAP);
  Irssi::active_win->print(sprintf("Unique channels for %s: %s", $nick_info{$nick_list[1]}{'nick'}, $uniq1), MSGLEVEL_CLIENTCRAP);
  cleanup();
}


sub cmd_cmpusers($$$) {
  my ($args, $server, $witem) = @_;
  $args = lc $args;
  my @nicks = split /\s+/, $args;

  if (scalar @nicks != 2) {
    Irssi::active_win->print("cmpusers error: please supply two nickname arguments.", MSGLEVEL_CLIENTCRAP);
    return;
  }

  if ($nicks[0] eq $nicks[1]) {
    Irssi::active_win->print("cmpusers error: please supply two unique nicknames.", MSGLEVEL_CLIENTCRAP);
    return;
  }

  if (!defined $server) {
    Irssi::active_win->print("cmpusers error: active window not connected to a server.", MSGLEVEL_CLIENTCRAP);
    return;
  }

  if ($server->{'chat_type'} ne 'IRC') {
    Irssi::active_win->print("cmpusers error: server is not of type IRC.", MSGLEVEL_CLIENTCRAP);
  }

  if ($running) {
    Irssi::active_win->print("cmpusers error: a request is currently being processed - please try again shortly.", MSGLEVEL_CLIENTCRAP);
    return;
  }

  $running = 1;

  if ($server->{'isupport_sent'}) {
    if (defined $server->isupport('PREFIX')) {
      my $prefix = $server->isupport('PREFIX');
      my $l = (length($prefix) - 2) / 2;
      $isupport{'PREFIX'} = substr($prefix, $l + 2, $l);
      Irssi::print("cmpusers prefix: $prefix", MSGLEVEL_CLIENTCRAP) if $debug;
    }
    if (defined $server->isupport('CASEMAPPING')) {
      my $casemap = $server->isupport('CASEMAPPING');
      $isupport{'CASEMAPPING'} = $casemap eq 'rfc1459' ? 1
                               : $casemap eq 'ascii'   ? 2
                               : 3;
      Irssi::print("cmpusers casemap: $casemap", MSGLEVEL_CLIENTCRAP) if $debug;
    }
    if (defined $server->isupport('CHANTYPES')) {
      $isupport{'CHANTYPES'} = $server->isupport('CHANTYPES');
      Irssi::print("cmpusers chantypes: $isupport{CHANTYPES}", MSGLEVEL_CLIENTCRAP) if $debug;
    }
  }

  for (my $i=0; $i <= $#nicks; $i++) {
    $nicks[$i] = to_casemap($nicks[$i]);
  }

  push @nick_list, @nicks;
  request_whois($server, $nicks[0]);
}


Irssi::signal_add(
  {
    'redir cmpusers_whois_user'       => \&event_whois_user,
    'redir cmpusers_whois_channels'   => \&event_whois_channels,
    'redir cmpusers_whois_end'        => \&event_whois_end,
    'redir cmpusers_whois_nosuchnick' => \&event_whois_nosuchnick,
    'redir cmpusers_whois_timeout'    => \&event_whois_timeout,
  }
);


Irssi::command_bind("cmpusers", \&cmd_cmpusers);
Irssi::print(sprintf("Loaded %s v%s...", $IRSSI{'name'}, $VERSION));
