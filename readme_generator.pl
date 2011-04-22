#!/usr/bin/env perl

use strict;
use warnings;

# Goal: extract the comments from the top of each script file, and
# turn them into some sort of markdown-style README.md for github to nom on.
#
# Not sure how it's going to work with multiple files in a dir though. Sections?

# Change of plan! Github supports POD, so we just use Pod::Select to scrape it.

use File::Find;
use File::Spec;
use Pod::Select;

use feature qw/say/;
use Cwd;

my $overwrite = $ARGV[0];
if ($overwrite =~ m/--overwrite/) {
    shift @ARGV; # remove it form list of dirs.
    $overwrite = 1;
} else {
    $overwrite = 0;
}

my @dirs = map { File::Spec->catdir(getcwd(), $_) } @ARGV;

die unless @dirs;

find(\&wanted, @dirs);

sub wanted {
    my ($file, $dir, $path) = ($_, $File::Find::dir, $File::Find::name);
    return unless $file =~ m/\.pl$/;
    return if $file =~ m/^\./;

    _err("processing file: $path");
    create_output_file($dir, $file);
}

sub create_output_file {
    my ($dir, $in_file) = @_;

    my $parser = Pod::Select->new;

    my $out_file = "README.pod";

    my $in_file_path = File::Spec->catfile($dir, $in_file);
    my $out_file_path = File::Spec->catfile($dir, $out_file);
    my $sec_sep = '';

    if (-f $out_file_path and not $overwrite) {
        _err("$out_file_path already exists, going to append") unless $overwrite;
        $sec_sep = "\n\n=for html <br />\n\n";
    }

    my $mode = $overwrite ? '>' : '>>';

    _err("Writing to $mode $out_file_path");

    open my $wfh, $mode, $out_file_path
      or die "Couldn't open $out_file_path for $mode output: $!";

    $parser->parse_from_file($in_file_path, $wfh);

    print $wfh "\n\n=cut\n\n";

    close $wfh;
}

sub _err {
    my ($msg, @args) = @_;
    my $str = sprintf($msg, @args);
    say STDERR $str;
}
