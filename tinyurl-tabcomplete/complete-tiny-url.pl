use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
use WWW::Shorten::TinyURL;

$VERSION = '2.1';
%IRSSI = (
    authors     => 'Shabble',
    contact     => 'shabble+irssi /at/ metavore /dot/ org',
    name        => 'Shorten URLs using Tab',
    description => '',
    license     => 'WTFPL',
);

sub do_complete {
	my ($strings, $window, $word, $linestart, $want_space) = @_;
	return if $word eq '';
    my $found_uri = match_uri($word);
    if (defined $found_uri && $found_uri !~ m/tinyurl\./i) {
        print "Going to reduce: $found_uri";
        my $uri = makeashorterlink($found_uri);
        push @$strings, $uri if $uri;
        $$want_space = 1;
        Irssi::signal_stop();
    }
}

sub match_uri {
    my $text = shift;

    my $regex = qr((?xi)
\b
(                           # Capture 1: entire matched URL
  (?:
    [a-z][\w-]+:                # URL protocol and colon
    (?:
      /{1,3}                        # 1-3 slashes
      |                             #   or
      [a-z0-9%]                     # Single letter or digit or '%'
                                    # (Trying not to match e.g. "URI::Escape")
    )
    |                           #   or
    www\d{0,3}[.]               # "www.", "www1.", "www2." … "www999."
    |                           #   or
    [a-z0-9.\-]+[.][a-z]{2,4}/  # looks like domain name followed by a slash
  )
  (?:                           # One or more:
    [^\s()<>]+                      # Run of non-space, non-()<>
    |                               #   or
    \(([^\s()<>]+|(\([^\s()<>]+\)))*\)  # balanced parens, up to 2 levels
  )+
  (?:                           # End with:
    \(([^\s()<>]+|(\([^\s()<>]+\)))*\)  # balanced parens, up to 2 levels
    |                                   #   or
    [^\s`!()\[\]{};:'".,<>?«»“”‘’]        # not a space or one of these punct chars
  )
));

    if ($text =~ $regex) {
        my $uri = $1;
        $uri = 'http://' . $uri if $uri !~ m(http://);
        return $uri;
    } else {
        return undef;
    }
}

Irssi::signal_add_first( 'complete word',  \&do_complete);

