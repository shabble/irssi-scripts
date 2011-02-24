#!/usr/bin/env perl

use strict;
use warnings;

use feature qw/say/;

use lib 'blib/lib';

use Test::Irssi;
use Test::Irssi::API;

my $test = Test::Irssi->new
  (irssi_binary  => "/opt/stow/repo/irssi-debug/bin/irssi",
   irssi_homedir => $ENV{HOME} . "/projects/tmp/test/irssi-debug");

say "Created test instance";

my $api = $test->api;

$api->create_test('test1', 'bacon');
$api->simulate_input("test1", "/echo This is a test\n");
$api->simulate_delay("test1", 0.5);
$api->expect_output("test1", qr/is a test/);

$api->run_tests;
$test->run;
