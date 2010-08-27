#!/usr/bin/env perl

use strict;
use warnings;

my $file = shift // 'allsigs.txt';

open my $fh, $file or die "couldn't open $file: $!";
my $sigs = {};

while (my $line = <$fh>) {
    chomp $line;
    if ($line =~ m/"(\w+(?:\s+\w+)*)"/) {
        #print "Found signal: $1\n";
        $sigs->{$1}++;
    }
}

close $fh;

my @signals = keys %$sigs;

print join("\n", sort @signals);
print "\n";
