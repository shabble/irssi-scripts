# mangled from cmpusers.pl (unpublished, afaik) by Bazerka <bazerka@quakenet.org>.
# He is not to blame for any problems, contact me instead.

use strict;
use warnings;

use Irssi;

our $VERSION = "0.1";
our %IRSSI =
  (
   authors     => "shabble, Bazerka",
   contact     => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode,'
                . 'bazerka@quakenet.org',
   name        => "signal_redir",
   description => "Demonstration showing how to redirect a remote WHOIS" 
                . "command so the results can be captured by a script.",
   license     => "BSD",
   url         => "https://github.com/shabble/irssi-scripts/",
   changed     => "Fri Apr 1 00:05:39 2011"
  );

my $running = 0; # flag to prevent overlapping requests.
my $debug = 1;
sub redir_init {
    # set up event to handler mappings
    Irssi::signal_add
        ({
          'redir test_redir_whois_user'       => 'event_whois_user',
          'redir test_redir_whois_channels'   => 'event_whois_channels',
          'redir test_redir_whois_end'        => 'event_whois_end',
          'redir test_redir_whois_nosuchnick' => 'event_whois_nosuchnick',
          'redir test_redir_whois_timeout'    => 'event_whois_timeout',
         });
}

sub request_whois {
    my ($server, $nick) = @_;

    $server->redirect_event
      (
       'whois', 1, $nick, 0,             # command, remote, arg, timeout
       'redir test_redir_whois_timeout', # error handler
       {
        'event 311' => 'redir test_redir_whois_user', # event mappings
        'event 318' => 'redir test_redir_whois_end',
        'event 319' => 'redir test_redir_whois_channels',
        'event 401' => 'redir test_redir_whois_nosuchnick',
        ''          => 'event empty',
       }
      );
    Irssi::print("Sending Command: WHOIS $nick", MSGLEVEL_CLIENTCRAP) if $debug;
    # send the actual command directly to the server, rather than
    # with $server->command()
    $server->send_raw("WHOIS $nick");
}

sub event_whois_user {
    my ($server, $data) = @_;
    my ($nick, $user, $host) = ( split / +/, $data, 6 )[ 1, 2, 3 ];
    Irssi::print("test_redir whois_user: $nick!$user\@$host", MSGLEVEL_CLIENTCRAP);
}

sub event_whois_channels {
    my ($server, $data) = @_;
    my ($nick, $channels) = ( split / +/, $data, 3 )[ 1, 2 ];
    my $prefix = 'cowu.be'; # server name
    my $args = "shabble";   # match criteria
    my $event = 'event 319'; # triggering event
    my $sig = $server->redirect_get_signal($prefix, $event, $args);
    Irssi::print("test_redir whois_channels: $nick, $channels", MSGLEVEL_CLIENTCRAP);
    Irssi::print("test_redir get_signal: $sig", MSGLEVEL_CLIENTCRAP);

}

sub event_whois_end {
    my ($server, $data) = @_;
    my ($nick) = ( split / +/, $data, 3 )[1];
    Irssi::print("test_redir whois_end: $nick", MSGLEVEL_CLIENTCRAP);

    return if $running == 0; # catch 318 -> 401 (nosuchnick followed by endofwhois)
    $running = 0;
}

sub event_whois_nosuchnick {
    my ($server, $data) = @_;
    my $nick = ( split / +/, $data, 4)[1];
    Irssi::active_win->print("test_redir error: no such nick $nick - aborting.",
                             MSGLEVEL_CLIENTCRAP);
    $running = 0;
}

sub event_whois_timeout {
    my ($server, $data) = @_;
    Irssi::print("test_redir whois_timeout", MSGLEVEL_CLIENTCRAP);
    $running = 0;
}

sub cmd_test_redir {
    my ($args, $server, $witem) = @_;
    $args = lc $args;
    my @nicks = split /\s+/, $args;

    if ($running) {
        Irssi::active_win->print
            ("test_redir error: a request is currently being processed "
             . "- please try again shortly.", MSGLEVEL_CLIENTCRAP);
        return;
    }
    $running = 1;
    request_whois($server, $nicks[0]);
}

redir_init();
Irssi::command_bind("test_redir", \&cmd_test_redir);

