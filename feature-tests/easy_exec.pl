use strict;
use warnings;

use Irssi (@Irssi::EXPORT_OK);
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => '',
              contact     => '',
              name        => '',
              description => '',
              license     => 'Public Domain',
             );

Irssi::signal_add_first 'command script exec', \&better_exec;

sub better_exec {
    my ($args, $serv, $witem) = @_;
    eval $args;
    Irssi::signal_stop();
}
