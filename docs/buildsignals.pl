#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;

package Pod::Simple::IrssiSignalParser;

use base qw/Pod::Simple::PullParser/;

use Data::Dumper;

sub run {
    my $self = shift;

    my ($seen_start, $seen_end) = (0,0);
    my $text_token;

  Token:

    while(my $token = $self->get_token()) {
        #print "PRocessing token: $token\n";

        if (!$seen_start && $token->is_start) {
            if ($token->tag eq 'Data') {
                print "Start Data token: $token\n";

                $text_token = $self->get_token;

                if ($text_token->is_text && $text_token->text =~ /START/) {
                    print "Found start!\n\n";
                    $seen_start = 1;
                }
            }
        }
    }
}

package main;

my $input_file = $ARGV[0] // 'Signals.pm';
my $parser = Pod::Simple::IrssiSignalParser->new;

$parser->accept_targets('irssi_signal_defs', 'irssi_signal_types');
my $tree = $parser->parse_file($input_file);


#     if ($type eq 'Data' && $text =~ /START OF SIGNAL DEFINITIONS/) {
#         $seen_start = 1;
#     }

#     if ($type eq 'Data' && $text =~ /END OF SIGNAL DEFINITIONS/) {
#         $seen_end = 1;
#     }

