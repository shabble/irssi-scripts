#!/usr/bin/env perl

use strict;
use warnings;

use feature qw/say/;
#use lib 'blib/lib';

use TAP::Harness;
my $harness = TAP::Harness->new({ verbosity => 1,
                                  lib => 'blib/lib',
                                  color => 1,
                                });

my @tests = glob($ARGV[0]);
say "Tests: " . join (", ", @tests);
$harness->runtests(@tests);
