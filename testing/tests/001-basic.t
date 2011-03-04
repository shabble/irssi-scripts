#!/usr/bin/env perl

use strict;
use warnings;

use feature qw/say/;
use Test::Irssi;

my $tester = Test::Irssi->new
  (irssi_binary  => "/opt/stow/repo/irssi-debug/bin/irssi",
   irssi_homedir => $ENV{HOME} . "/projects/tmp/test/irssi-debug");

if (exists $ENV{IRSSI_TEST_HEADLESS} and $ENV{IRSSI_TEST_NOHEADLESS} == 1) {
    $tester->run_headless(0);
    $tester->generate_tap(0);
} else {
    $tester->run_headless(1);
    $tester->generate_tap(1);
}

my $test = $tester->new_test('test1');
$test->description("simple echo tests");

$test->add_input_sequence("/echo Hello cats\n");
$test->add_delay(1);
$test->add_input_sequence("/echo Hello Again\n");
$test->add_input_sequence("this is a long test");
$test->add_delay(0.5);
$test->add_pattern_match(qr/long/, 'prompt', 'prompt contains long');
$test->add_delay(1);

$test->add_pattern_match(qr/this is a .*? test/, 'prompt', 'prompt matches');

my $test2 = $tester->new_test('test2');
$test2->description("cursor movement and deletion");

$test2->add_delay(1);
$test2->add_input_sequence("\x01");
$test2->add_delay(0.1);
$test2->add_input_sequence("\x0b");
$test2->add_delay(0.1);
$test2->add_input_sequence("/clear\n");
$test2->add_delay(0.1);
$test2->add_input_sequence("/echo moo\n");

my $quit = $tester->new_test('quit');
$quit->description('quitting');
$quit->add_input_sequence("/quit\n");

$tester->run;
