#!/usr/bin/env perl

use strict;
use warnings;

use feature qw/say/;

use lib 'blib/lib';

use Test::Irssi;

my $tester = Test::Irssi->new
  (irssi_binary  => "/opt/stow/repo/irssi-debug/bin/irssi",
   irssi_homedir => $ENV{HOME} . "/projects/tmp/test/irssi-debug");

say "Created test instance";



my $test = $tester->new_test('test1');

$test->add_input_sequence("/echo Hello\n");
$test->add_delay(2);
$test->add_input_sequence("/echo Hello Again\n");
for (1..10) {
    $test->add_input_sequence($_);
    $test->add_delay(0.2);
}

#$test->add_input_sequence("This is\x0acursor movement\x0a");
# $test->add_delay(5);
 $test->add_input_sequence("\n");

 $test->add_input_sequence("/clear\n");
# $test->add_expected_output("Hello");



$tester->run;
