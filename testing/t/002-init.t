#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
    use_ok 'Test::Irssi';
}


my $test = new_ok 'Test::Irssi',
  [irssi_binary  => "/opt/stow/repo/irssi-debug/bin/irssi",
   irssi_homedir => $ENV{HOME} . "/projects/tmp/test/irssi-debug"];

if (-f $test->logfile) {
    ok(unlink $test->logfile, 'deleted old logfile');
}

my $drv = $test->driver;
isa_ok($drv, 'Test::Irssi::Driver', 'driver created ok');

diag "Starting POE session";
$test->run();

done_testing;

__END__



