#!/usr/bin/env perl

# Must be run in a 80x24 terminal unless a fixed POE is released.


use strict;
use warnings;

use lib '../testing/blib/lib';

use Test::Irssi;

# Mode constants: C(ommand), I(nsert).
sub C () { 0 }
sub I () { 1 }


sub statusbar_mode {
    my ($test, $mode) = @_;

    $test->add_pattern_match(qr/^ \[\d{2}:\d{2}\] \[\] \[1\] \[$mode\]\s+$/,
        'window_sbar', "[$mode] in vim-mode statusbar");
}
sub cursor_position {
    my ($test, $position) = @_;

    $test->test_cursor_position($position, 24, "Checking cursor position");
}

sub check {
    my ($test, $input, $mode, $position, $delay) = @_;

    if (defined $input) {
        $test->add_input_sequence($input);
        if (not defined $delay) {
            $delay = 0.1;
            $delay += 0.4 if $input =~ /\e/; # esc needs a longer delay
        }
        $test->add_delay($delay);
    }

    cursor_position($test, $position);
    if ($mode == C) {
        statusbar_mode($test, 'Command');
    } elsif ($mode == I) {
        statusbar_mode($test, 'Insert');
    } else {
        die "Wrong mode: $mode";
    }
}

my $tester = Test::Irssi->new
  (irssi_binary  => "irssi",
   irssi_homedir => "./irssi/");


$tester->run_headless(1);
$tester->generate_tap(1);

my $test = $tester->new_test('insert-command-mode');
$test->description("switching between insert and command mode");
# Make sure irssi is finished - not entirely sure why this is necessary.
$test->add_delay(2);

# We start in insert mode.
check $test, undef, I, 12 + 0;
check $test, "\e",  C, 12 + 0;
check $test, 'i',   I, 12 + 0;

# Quit irssi, necessary to terminate the test.
#$test->add_input_sequence("\n/quit\n");


# FIXME: multiple tests don't work
#$test = $tester->new_test('basic-movement');
#$test->description('basic movement');
#$test->add_delay(2);

my $test_string =
    'Test $tring. with a 4711, words , w.r#s42  etc.   and more123! ..';

check $test, $test_string, I, 12 + length $test_string;
check $test, "\e",         C, 12 + 64;

# h l
check $test, "0",    C, 12 + 0;
check $test, "l",    C, 12 + 1;
check $test, "l",    C, 12 + 2;
check $test, "l",    C, 12 + 3;
check $test, "l",    C, 12 + 4;
check $test, "l",    C, 12 + 5;
check $test, "l",    C, 12 + 6;
check $test, "l",    C, 12 + 7;
check $test, "h",    C, 12 + 6;
check $test, "h",    C, 12 + 5;
check $test, "h",    C, 12 + 4;
check $test, "h",    C, 12 + 3;
check $test, "h",    C, 12 + 2;
check $test, "10l",  C, 12 + 12;
check $test, "7l",   C, 12 + 19;
check $test, "3l",   C, 12 + 22;
check $test, "3h",   C, 12 + 19;
check $test, "50l",  C, 12 + 64;
check $test, "10l",  C, 12 + 64;
check $test, "24h",  C, 12 + 40;
check $test, "100h", C, 12 + 0;

# 0 ^ $
check $test, "I     \e", C, 12 + 4; # insert test string for ^
check $test, "0",        C, 12 + 0;
check $test, "^",        C, 12 + 5;
check $test, "3^",       C, 12 + 5;
check $test, "12^",      C, 12 + 5;
check $test, "\$",       C, 12 + 46;
check $test, "05x",      C, 12 + 0; # remove test string for ^

# <Space> <BS>
check $test, "0",      C, 12 + 0;
check $test, " ",      C, 12 + 1;
check $test, " ",      C, 12 + 2;
check $test, " ",      C, 12 + 3;
check $test, " ",      C, 12 + 4;
check $test, " ",      C, 12 + 5;
check $test, " ",      C, 12 + 6;
check $test, " ",      C, 12 + 7;
check $test, " ",      C, 12 + 8;
check $test, "5 ",     C, 12 + 13;
check $test, "2 ",     C, 12 + 15;
check $test, "10 ",    C, 12 + 25;
check $test, "30 ",    C, 12 + 55;
check $test, "20 ",    C, 12 + 64;
check $test, "10 ",    C, 12 + 64;
check $test, " ",      C, 12 + 64;
check $test, "\x7f",   C, 12 + 63;
check $test, "\x7f",   C, 12 + 62;
check $test, "\x7f",   C, 12 + 61;
check $test, "\x7f",   C, 12 + 60;
check $test, "1\x7f",  C, 12 + 59;
check $test, "3\x7f",  C, 12 + 56;
check $test, "5\x7f",  C, 12 + 51;
check $test, "10\x7f", C, 12 + 41;
check $test, "50\x7f", C, 12 + 0;
check $test, "\x7f",   C, 12 + 0;
check $test, "5\x7f",  C, 12 + 0;

# f t
check $test, "0",   C, 12 + 0;
check $test, "fe",  C, 12 + 1;
check $test, "fs",  C, 12 + 2;
check $test, "ft",  C, 12 + 3;
check $test, "f ",  C, 12 + 4;
check $test, "2f ", C, 12 + 17;
check $test, "5f,", C, 12 + 17;
check $test, "2f,", C, 12 + 32;
check $test, "tw",  C, 12 + 33;
check $test, "t ",  C, 12 + 40;
check $test, "t ",  C, 12 + 40;
check $test, "t ",  C, 12 + 40;
check $test, "2t ", C, 12 + 41;
check $test, "2t ", C, 12 + 46;
check $test, "3t ", C, 12 + 48;
check $test, "t!",  C, 12 + 60;
check $test, "t ",  C, 12 + 61;
check $test, "t.",  C, 12 + 62;
check $test, "t.",  C, 12 + 62;
check $test, "5t.", C, 12 + 62;
check $test, "\$",  C, 12 + 64;

$test->add_input_sequence("\n/quit\n");

$tester->run;
