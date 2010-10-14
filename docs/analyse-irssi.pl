#!/usr/bin/env perl

use strict;
use warnings;

use C::Scan;
use Data::Dumper;

my $basedir = "/Users/tomfeist/sources/irssi/src";
my $filename = $basedir . "/fe-text/gui-printtext.c";

my $addflags = "-DUOFF_T_INT";

my $c = C::Scan->new( 'filename' => $filename,
#                      'filename_filter' => $filter,b
                      'add_cppflags' => $addflags,
                    );

my @includes = (
                $basedir,
                $basedir . "/fe-text/",
                $basedir . "/fe-common/",
                $basedir . "/fe-common/core/",


                $basedir . "/core/",
                "/opt/local/include/glib-2.0",
                "/opt/local/lib/glib-2.0/include/",
#                "/opt/local/include/",
               );

$c->set('includeDirs' => \@includes);

my $fdec = $c->get('parsed_fdecls');
print Dumper($fdec), $/;
