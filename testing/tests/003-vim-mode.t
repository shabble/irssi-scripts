#!/usr/bin/env perl

# Must be run in a 80x24 terminal unless a fixed POE is released.
use strict;
use warnings;

use Test::Irssi;

sub statusbar_mode {
    my ($test, $mode) = @_;

    $test->add_pattern_match(qr/^ \[\d{2}:\d{2}\] \[\] \[1\] \[$mode\]\s+$/,
        'window_sbar', "[$mode] in vim-mode statusbar");
}

my $tester = Test::Irssi->new
  (irssi_binary  => "/opt/stow/repo/irssi-debug/bin/irssi",
   irssi_homedir => $ENV{HOME} . "/projects/tmp/test/irssi-debug");

$tester->run_headless(1);
$tester->generate_tap(1);

my $test = $tester->new_test('insert-command-mode');
$test->description("switching between insert and command mode in vim_mode script");

# Make sure irssi is finished - not entirely sure why this is necessary.
$test->add_delay(2);

# We start in insert mode.
statusbar_mode($test, 'Insert');

$test->add_input_sequence("\e");
$test->add_delay(1);
statusbar_mode($test, 'Command');

$test->add_input_sequence("i");
$test->add_delay(1);
statusbar_mode($test, 'Insert');

# Quit irssi, necessary to terminate the test.
$test->add_input_sequence("\n/quit\n");

$tester->run;
