#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
    use_ok 'Test::Irssi';
}


my $test = new_ok 'Test::Irssi';
my @methods = qw/logfile terminal_height terminal_width irssi_homedir irssi_binary/;
can_ok($trie, @methodss);

undef $test

done_testing;

__END__



