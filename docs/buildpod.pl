#!/usr/bin/env perl

use strict;
use warnings;

use Pod::Simple::HTMLBatch;
use File::Find;


my $output_dir = "../../tmp/shab-irssi-scripts/docs/";
my $batchconv = Pod::Simple::HTMLBatch->new;
$batchconv->add_css('podstyle.css', 1);
$batchconv->css_flurry(0);
$batchconv->javascript_flurry(0);

$batchconv->batch_convert( [qw/./], $output_dir );

