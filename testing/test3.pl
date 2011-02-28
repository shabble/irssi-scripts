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

$test->add_input_sequence("/echo Hello cats\n");
$test->add_delay(1);
$test->add_input_sequence("/echo Hello Again\n");
$test->add_input_sequence("this is a long test");
$test->add_pattern_match(qw/long/, 'prompt', 'prompt contains hello');

my $test2 = $tester->new_test('test2');
$test2->add_delay(1);
$test2->add_input_sequence("\x01");
$test2->add_delay(0.1);
$test2->add_input_sequence("\x0b");
$test2->add_delay(0.1);
$test2->add_input_sequence("/clear\n");
$test2->add_delay(0.1);
$test2->add_input_sequence("/echo moo\n");

# for (1..10) {
#     $test->add_input_sequence("\xff");
#     $test->add_delay(0.1);
    
# }

$tester->run;
