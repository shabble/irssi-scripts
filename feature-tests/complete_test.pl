use strict;
use vars qw($VERSION %IRSSI);

use Irssi;
$VERSION = '2.1';
%IRSSI = (
    authors     => 'Daenyth',
    contact     => 'Daenyth /at/ gmail /dot/ com',
    name        => 'Complete Last-Spoke',
    description => 'When using tab completion on an empty input buffer, complete to the nick of the person who spoke most recently.',
    license     => 'GPL2',
);

sub do_complete {
	my ($strings, $window, $word, $linestart, $want_space) = @_;
	return unless ($linestart eq '' && $word eq '');

#	my $suffix = Irssi::settings_get_str('completion_char');
#	@$strings = $last_speaker . $suffix;
    push @$strings, qw|/foo /bar /baz /bacon|;

#	$$want_space = 1;
#	Irssi::signal_stop();
}

 Irssi::signal_add_first( 'complete word',  \&do_complete);

