use strict;
use warnings;


use Irssi;


our $VERSION = '0.1';
our %IRSSI = (
              authors     => '',
              contact     => '',
              name        => '',
              description => '',
              license     => 'Public Domain',
             );

init();

sub init {
    Irssi::command_bind('ft', \&format_test);
}


sub format_test {
    my ($args, $win, $server) = @_;
}
