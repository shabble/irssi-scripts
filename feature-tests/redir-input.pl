use strict;
use warnings;


use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;


our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'Public Domain',
             );


Irssi::command_bind("ri", \&cmd_ri);
Irssi::signal_register({ 'gui entry redirect' => [ qw/string string intptr intptr/]});
sub cmd_ri {
    my ($args, $server, $witem) = @_;
    my $win = Irssi::active_win();
    my ($x, $y) = (0, 0);
    Irssi::signal_emit('gui entry redirect', 'sub_blah', "bacon", $x, $y);
    #my $ref = Irssi::windows_refnum_last
#    $win->format_create_dest(Irssi::MSGLEVEL_ClIENTCRAP());
}

sub sub_blah { print "Moo" }
