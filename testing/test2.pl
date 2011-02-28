#!/usr/bin/env perl

use strict;
use warnings;

use feature qw/say/;

use lib 'blib/lib';

use Test::Irssi;

my $tester = Test::Irssi->new
  (irssi_binary  => "/opt/stow/repo/irssi-debug/bin/irssi",
   irssi_homedir => $ENV{HOME} . "/projects/tmp/test/irssi-debug");

my $test = $tester->new_test('test2');
$test->add_input_sequence("/echo 'Window one'\n");
$test->add_delay(5);
$test->add_input_sequence("/window new hide\n");
$test->add_input_sequence("/win 2\n");
for (1..10) {
    $test->add_input_sequence($_);
    $test->add_delay(0.2);
}
$test->add_input_sequence("\x01/echo \x05\n");
$test->add_delay(10);
$test->add_input_sequence("\x1b\x31");
$test->add_delay(10);
#$test->add_input_sequence("This is\x0acursor movement\x0a");
# $test->add_delay(5);



# $test->add_expected_output("Hello");



$tester->run;
