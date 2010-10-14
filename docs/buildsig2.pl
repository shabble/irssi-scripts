#!/usr/bin/env perl

use strict;
use warnings;
#use Pod::Simple::Debug (3);
use Data::Dumper;
use Pod::Simple::SimpleTree;
use Carp qw/croak/;
$|++;

#package Pod::Simple::Tree;


#package main;

my $input_file = $ARGV[0] // 'General/Signals.pod';
my $parser = Pod::Simple::SimpleTree->new;

$parser->accept_targets('irssi_signal_defs', 'irssi_signal_types');
my $root = $parser->parse_file($input_file)->root;

#print Dumper($root);
my @sig_tree;

my $in_list = 0;
foreach my $node (get_children($root)) {
    #print name($node), "\n";

    if (name($node) eq 'for') {

        if (attr($node)->{target} eq 'irssi_signal_defs') {
            print "Found For\n";
            my $text = text(get_children($node));

            if ($text =~ /START OF SIGNAL DEFINITIONS/) {
                print "start of defs\n";
                $in_list = 1;
                next;
            } elsif ($text =~ /END OF SIGNAL DEFINITIONS/) {
                print "end of defs\n";
                $in_list = 0;
                next;
            }
        }

    }
    push @sig_tree, $node if $in_list;

}
# we've got what we came for
undef $root;
undef $parser;

my $module = '';
my $file = '';


print Dumper(\@sig_tree), "\n\n";

foreach my $node (@sig_tree) {
    my $name = name($node);

    if ($name eq 'head2') {
        $module = text($node);
        print "Module: $module\n";
    } elsif ($name eq 'head3') {
        $file = text(get_children($node));
        print "File: $file\n";
    } elsif ($name eq 'over-text') {
        my @children = get_children($node);
        while (@children) {

            # fetch in pairs $sig => $parameter list
            my ($signal, $params) = (shift @children, shift @children);
            print "Signal: ", Dumper($signal), $/;
            print "Params: ", Dumper($params), $/;

            my $sig_name = text(get_children($signal));

            print "Sig: $sig_name\n";

            my @param_list = get_children($params);
            foreach my $param (@param_list) {
                $param = get_children($param);
                print "Param: ", Dumper($param), "\n";
                my $type = '';
                my $var = '';
                if (!ref $param->[0]) {
                    $type = $param->[0];
                    my @param_array = @$param;
                    foreach my $thing (@param_array) {
                        $var = text($thing);
                        last if $var =~ m/\$\w+/;
                    }
                } elsif (name($param->[0]) eq 'B') {
                    # skip
                    next;
                } elsif (name($param->[0]) eq 'L') {
                    $type = text($param->[0]);
                    #$var = text($param->[1]);
                    my @param_array = @$param;
                    foreach my $thing (@param_array) {
                        $var = text($thing);
                        last if $var =~ m/\$\w+/;
                    }
                } else {
                    $var = text($param->[0]);
                }
                $type =~ s/\s*(\w+)\s*/$1/;
                $var  =~ s/\s*(\w+)\s*/$1/;

                print "Type: $type, Var: >$var<\n";
            }
        }
    }
}

sub attr {
    my $node = shift;
    return $node->[1];
}
sub name {
    my $node = shift;
    return $node->[0];
}

sub text {
    my $node = shift;
    my $text = ref $node ? $node->[2] : '' ;
    croak("text() called on non-terminal: " . Dumper($node)) if ref($text);
    return $text;
}

sub get_children {
    my $node = shift;

    my @node_arr = ref $node ? @$node : ();
    my @child_slice = @node_arr[2..$#node_arr];
    return wantarray ? @child_slice : \@child_slice;
}
