use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
use Regexp::Common qw/URI/;
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
    if ($word =~ m/$RE{URI}{HTTP}{-keep}/) {
        my $uri = makeashorterlink($1);
        push @$strings, $uri if $uri;
        $$want_space = 1;
        Irssi::signal_stop();
    }
}

Irssi::signal_add_first( 'complete word',  \&do_complete);

