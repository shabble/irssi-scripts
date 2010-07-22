#!/usr/bin/env perl

use strict;
use warnings;

use Glib::ParseXSDoc;
use File::Find;
use Data::Dumper;

my $home = $ENV{HOME};
my $src_dir = "$home/sources/irssi/src/perl";
$ENV{FORCE_DATA_DUMPER} = 1;
print "=over\n\n";

find(\&process_file, $src_dir);

print "=back\n\n";

sub process_file {
    my $filename = $_;
    return unless $filename =~ /\.xs$/;

    my $filepath = $File::Find::name;
#    print "Processing file: $filepath\n";

    my $parser = Glib::ParseXSDoc->new; #xsdocparse($filepath);

    $parser->parse_file($filepath);
    $parser->canonicalize_xsubs;
	$parser->swizzle_pods;
	$parser->preprocess_pods;
	$parser->clean_out_empty_pods;

    #print Dumper($parser->{data}), $/;
    my $data = $parser->{data};
    foreach my $package (keys %$data) {
        #print "Package: $package\n";
        my $subs = $data->{$package}->{xsubs};
        foreach my $sub (@$subs) {
            my $sub_name = $sub->{symname};
            next if $sub_name =~ m/::$/;
            print_msglevel($sub_name);
            #print $sub->{symname}, $/;
        }
    }
}

sub print_msglevel {
    my ($sym) = @_;
    if ($sym =~ m/::MSGLEVEL/) {
        $sym =~ s/^Irssi:://;
        print "=item C<$sym>\n\n";
    }
}
  
