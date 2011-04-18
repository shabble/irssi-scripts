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

    _err("processing file: $path");
    read_input_file($dir, $file);
}

sub read_input_file {
    my ($dir, $filename) = @_;

    my $filepath = File::Spec->catfile($dir, $filename);
    _err("reading $filepath");

    my $parser = Pod::Markdown->new;
    $parser->parse_from_file($filepath);

    create_output_file($dir, "README.md", $parser);
}

sub create_output_file {
    my ($dir, $filename, $parser) = @_;

    my $filepath = File::Spec->catfile($dir, $filename);

    my $markdown = $parser->as_markdown;

    return unless length chomp($markdown);
    return if $markdown =~ m/^\s*$/;


    my $sec_sep = '';

    if (-f $filepath and not $overwrite) {
        _err("$filepath already exists, going to append") unless $overwrite;
        $sec_sep = "\n\n* * * *\n\n";
    }

    my $mode = $overwrite ? '>' : '>>';

    _err("Writing to $mode $filepath");

    open my $wfh, $mode, $filepath
      or die "Couldn't open $filepath for $mode output: $!";

    print $wfh $sec_sep;
    print $wfh $parser->as_markdown; # fetch it again since we chomped $markdown.
    close $wfh;
}

sub _err {
    my ($msg, @args) = @_;
    my $str = sprintf($msg, @args);
    say STDERR $str;
}
