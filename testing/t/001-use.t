#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
    use_ok 'Test::Irssi';
}


my $test = new_ok 'Test::Irssi',
  [irssi_binary => 'null', irssi_homedir => 'null'];

my @methods = qw/logfile terminal_height terminal_width irssi_homedir irssi_binary/;
can_ok($test, @methods);

undef $test;

done_testing;

__END__



