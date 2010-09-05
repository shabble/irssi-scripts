#!/usr/bin/env perl

use strict;
use warnings;
#use Pod::Simple::Debug (3);
use Data::Dumper;
$|++;

package Pod::Simple::IrssiSignalParser;
$|++;

use base qw/Pod::Simple::PullParser/;
use Carp qw/cluck/;

use Data::Dumper;

sub new {
    my $self = __PACKAGE__->SUPER::new(@_);

    $self->{__type_mapping} = {};
    $self->{__signals} = {};

    return bless $self, __PACKAGE__;
}
sub run {
    my $self = shift;

    # my ($seen_start, $seen_end) = (0,0);
    my $text_token;

  Token:

    while(my $token = $self->get_token()) {
        #print "PRocessing token: $token\n";

        if ($token->is_start) {
            if ($token->tag eq 'Data') {
                print "Start Data token: ", $token->dump, "\n";

                $text_token = $self->get_token;
                print "next token: ", $text_token->dump, "\n";

                if ($text_token->is_text && $text_token->text =~ /START OF (.*)$/) {
                    print "Found start of $1!\n\n";
                    my $type = $1;

                    if ($type eq 'SIGNAL TYPES') {
                        $self->process_types;
                    } elsif ($type eq 'SIGNAL DEFINITIONS') {
                        $self->process_definitions;
                    }
                }
            }
        }
    }
}

sub process_types {
    my $self = shift;

    my $list_ended   = 0;
    my $list_started = 0;

    print "Processing signal types\n";

    while (!$list_ended) {

        my $token = $self->get_token;

        if (!$list_started) {
            if ($token->is_start && $token->tag eq 'over-text') {
                $list_started = 1;
            } else {
                next;
            }
        } else {
            if ($token->is_end && $token->tag eq 'over-text') {
                $list_ended = 1;
            } else {
                $self->unget_token($token);
                # do tag processing here
                print "Processing token ", $token->dump, $/;
                $self->process_type_entry;
            }
        }
    }

    print "Done Processing signal types\n";

}

sub validate_token {
    my ($self, $token, $expected, $type) = @_;

    unless ($token->type eq $type && $token->is_tag($expected)) {
        cluck "Eeek. Expected $expected: $type, got "
          . $token->dump();

        # cluck("Invalid token. " # on line " . $token->attr('start_line')
        #   . "expected $expected $type, got " . $token->tag
        #     . " " . $token->type . " : " . $token->dump);

    }
}

sub process_type_entry {
    my $self = shift;

    my $token = $self->get_token;
    $self->validate_token($token, 'item-text', 'start');

    $token = $self->get_token;
    $self->validate_token($token, 'C', 'start');

    $token = $self->get_token;
    my $c_type = $token->text;

    $token = $self->get_token;
    $self->validate_token($token, 'C', 'end');

    $token = $self->get_token; # consume the separator whitespace.
    die "incorrect separator" unless $token->text =~ /^\s+$/;

    $token = $self->get_token;
    $self->validate_token($token, 'C', 'start');

    $token = $self->get_token;
    my $perl_type = $token->text;

    $token = $self->get_token;
    $self->validate_token($token, 'C', 'end');

    $token = $self->get_token;
    $self->validate_token($token, 'item-text', 'end');

    print "*** Creating mapping for $c_type => $perl_type\n";
    $self->{__type_mapping}->{$c_type} = $perl_type;
}

sub process_definitions {
    my $self = shift;

    my $list_ended   = 0;
    my $list_started = 0;

    print "Processing signal definitions\n";

    while (!$list_ended) {

        my $token = $self->get_token;
        $list_ended = 1 unless $token;

        if (!$list_started) {
            if ($token->is_start && $token->tag eq 'over-text') {
                $list_started = 1;
            } else {
                next;
            }
        } else {
            if ($token->is_end && $token->tag eq 'over-text') {
                $list_ended = 1;
            } else {
                $self->unget_token($token);
                # do tag processing here
                print "Processing token ", $token->dump, $/;
                $self->process_def_entry;
            }
        }
    }

    print "Done Processing signal defs\n";

}

sub process_def_entry {
    my $self = shift;
    my $token;
    print "Processing definition entry\n";
    while ($token = $self->get_token()) {
        print "Token is ", $token->dump, "\n";

        last if $token->is_end && $token->tag eq 'item-text';

        $self->validate_token($token, 'item-text', 'start');
        $token = $self->get_token();
        $self->validate_token($token, 'C', 'start');
        $token = $self->get_token();

        if ($token->is_text) {
            my $sig_name = $token->text;
            print "Signal: $sig_name\n";
        }

        $token = $self->get_token();

        $self->validate_token($token, 'C', 'end');
        $token = $self->get_token();
        print "matched end of code\n";

        $self->validate_token($token, 'item-text', 'end');
        $token = $self->get_token();

        print "matched end of header list\n";

        $self->validate_token($token, 'over-text', 'start');
        $token = $self->get_token();

        print "matched start of args list\n";

        $self->validate_token($token, 'item-text', 'start');
        $token = $self->get_token();

        # consume argument list.
        until ($token->is_end && $token->tag eq 'over-text') {
            $token = $self->get_token();
            print "waiting for arglist Token: " . $token->dump() . "\n";
        }
        print "Token now: ", $token->dump(), $/;

        print "consumed arg list\n";
        $token = $self->get_token();
        print "Token now: ", $token->dump(), $/;
        $self->validate_token($token, 'item-text', 'end');
        $token = $self->get_token();

    }
    #$self->unget_token($token);
    print "Done Processing definition entry\n";

}

package main;

my $input_file = $ARGV[0] // 'General/Signals.pod';
my $parser = Pod::Simple::IrssiSignalParser->new;

$parser->accept_targets('irssi_signal_defs', 'irssi_signal_types');
my $tree = $parser->parse_file($input_file);

