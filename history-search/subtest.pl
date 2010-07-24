use strict;
use Irssi;
use Irssi::TextUI;
use Data::Dumper;

use vars qw($VERSION %IRSSI);
$VERSION = '1.0';
%IRSSI = (
    authors     => 'Wouter Coekaerts',
    contact     => 'coekie@irssi.org',
    name        => 'history_search',
    description => 'Search within your typed history as you type (like ctrl-R in bash)',
    license     => 'GPLv2 or later',
    url         => 'http://wouter.coekaerts.be/irssi/',
    changed     => '04/08/07'
);


Irssi::command_bind("foo bar", \&subcmd_bar);
Irssi::command_bind("foo", \&subcmd_handler);

sub subcmd_handler {
    my ($data, $server, $item) = @_;
    $data =~ s/\s+$//g;
    Irssi::command_runsub('foo', $data, $server, $item);
}

sub subcmd_bar {
    my ($args) = @_;
    print "subcommand called with: $args";
}

# my $prev_typed;
# my $prev_startpos;
# my $enabled = 0;

# Irssi::command_bind('history_search', sub {
# 	$enabled = ! $enabled;
# 	if ($enabled) {
# 		$prev_typed = '';
# 		$prev_startpos = 0;
# 	}
# });

# Irssi::signal_add_last 'gui key pressed' => sub {
# 	my ($key) = @_;
	
# 	if ($key == 10) { # enter
# 		$enabled = 0;
# 	}

# 	return unless $enabled;
	
# 	my $prompt = Irssi::parse_special('$L');
# 	my $pos = Irssi::gui_input_get_pos();
	
# 	if ($pos < $prev_startpos) {
# 		$enabled = 0;
# 		return;
# 	}
	
# 	my $typed = substr($prompt, $prev_startpos, ($pos-$prev_startpos));
	
# 	my $history = ($typed eq '') ? '' : Irssi::parse_special('$!' . $typed . '!');
# 	if ($history eq '') {
# 		$history = $typed;
# 	}
	
# 	my $startpos = index(lc($history), lc($typed));
		
# 	Irssi::gui_input_set($history);
# 	Irssi::gui_input_set_pos($startpos + length($typed));
	
# 	$prev_typed = $typed;
# 	$prev_startpos = $startpos;
# };
