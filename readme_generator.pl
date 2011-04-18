#!/usr/bin/env perl

use strict;
use warnings;

# Goal: extract the comments from the top of each script file, and
# turn them into some sort of markdown-style README.md for github to nom on.
#
# Not sure how it's going to work with multiple files in a dir though. Sections?


use File::Find;
use File::Spec;
use Pod::Markdown;
use feature qw/say/;
use Cwd;
my @dirs = map { File::Spec->catdir(getcwd(), $_) } @ARGV;

die unless @dirs;

find(\&wanted, @dirs);

sub wanted {
    my ($file, $dir, $path) = ($_, $File::Find::dir, $File::Find::name);
    return unless $file =~ m/\.pl$/;

    _err("processing file: $path");
    read_input_file($dir, $file);
}

sub read_input_file {
    my ($dir, $filename) = @_;

    my $filepath = File::Spec->catfile($dir, $filename);

    open my $rfh, '<', $filepath or die "Couldn't open $filepath for input: $!";

    _err("reading $filepath");

    my $parser = Pod::Markdown->new;

    $parser->parse_from_filehandle($rfh);

    close $rfh;

    create_output_file($dir, 'README.md', $parser);
}

sub create_output_file {
    my ($dir, $filename, $parser) = @_;

    my $filepath = File::Spec->catfile($dir, $filename);

    _err("Writing to $filepath");

    open my $wfh, '>', $filepath or die "Couldn't open $filepath for output: $!";
    print $wfh $parser->as_markdown;
    close $wfh;
}

sub _err {
    my ($msg, @args) = @_;
    my $str = sprintf($msg, @args);
    say STDERR $str;
}
