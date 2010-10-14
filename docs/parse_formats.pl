#!/usr/bin/env perl

use strict;
use warnings;


use C::Scan;
use Data::Dumper;
use Config;

my $home = $ENV{HOME};
my $src_loc = "$home/sources/irssi/src";
my $file = "perl/module-formats.c";


my $scan = C::Scan->new(filename => $src_loc . "/". $file);
$scan->set('includeDirs' => [$src_loc,
                             $src_loc . "/perl",
                             "/opt/local/include",
                             "/opt/local/include/glib-2.0",
                             $Config::Config{shrpdir}]);

print Dumper($scan->get('typedef_structs'));
