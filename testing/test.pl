#!/usr/bin/env perl

use strict;
use warnings;

use feature qw/say/;

use lib 'blib/lib';

use Test::Irssi;

my $test = Test::Irssi->new
  (irssi_binary  => "/opt/stow/repo/irssi-debug/bin/irssi",
   irssi_homedir => $ENV{HOME} . "/projects/tmp/test/irssi-debug");

say "Created test instance";

$test->run;
