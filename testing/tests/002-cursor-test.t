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
$test->add_diag("Testing 123");

my $quit = $tester->new_test('quit');
$quit->description('quitting');
$quit->add_input_sequence("/quit\n");

$tester->run;
