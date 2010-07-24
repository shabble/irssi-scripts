#!/usr/bin/env perl

use strict;
use warnings;

use File::Find;
use File::Basename qw/basename/;
#use File::Spec ();
use Cwd qw/realpath/;

use FindBin;

my $scripts_dir = $FindBin::Bin . '/irssi/scripts';
print "Cleanup....\n";
find(\&cleanup, "irssi/scripts/");
print "Scanning for new....\n";
find(\&wanted, '../');
print "Done\n";

sub cleanup {
    my $file = $_;
    my $path = $File::Find::name;
    my $dir = $File::Find::dir;

    # only process symlinks
    my $abs_path = realpath($path); #File::Spec->rel2abs($path);
    return unless defined $abs_path;
    return unless (-l $abs_path);
    print "Thinking about deleting $path\n";

}

sub wanted {
    my $file = $_;
    my $path = $File::Find::name;
    my $dir = $File::Find::dir;

    my $abs_path = realpath($path); #File::Spec->rel2abs($path);
    #$abs_path = File::Spec->canonpath($abs_path);

    return if $dir =~ /(?:test|docs)$/;
    return unless $file =~ /\.pl$/;
    return unless defined $abs_path;
    return unless -f $abs_path;

    print "Thinking about $scripts_dir/$file => $abs_path\n";
    create_link($abs_path);
}


sub create_link {
    my $target = shift;
    my $name = basename($target);
    my $link = $scripts_dir . '/' . $name;

    my $ret = symlink($target, $link);
    die "link creation failed - T: $target, L: $link" unless $ret;
}
