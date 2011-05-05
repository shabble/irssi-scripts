#!/usr/bin/env perl

use strict;
use warnings;

use feature qw/say/;
use DateTime;

my $infile = $ARGV[0] // die "No File provided"; #'feature-tests/template.pl.copy';
my $transform = PPI::Transform::UpdateTimestamp->new
  (
   updated => DateTime->now,
   quiet   => 1
  );


my $ret = $transform->file($infile);

#say "Return value: " . 

exit (defined $ret && $ret ? 0 : 1);



package PPI::Transform::UpdateTimestamp;

use strict;
use warnings;

use PPI;
use PPI::Dumper;
use DateTime;
use Carp qw/carp/;

use base 'PPI::Transform';

our	$VERSION = '3.14';

use feature qw/say/;

sub new {
    my ($class, @args) = @_;
	my $self = $class->SUPER::new(@args);

	# Must provide an updated timestamp.
	unless ( exists ($self->{updated}) ) {
		#PPI::Exception->throw("Did not provide a valid updated timestamp.");
        my $now = DateTime->now();
        carp("No updated value provided, using $now");
        $self->set_updated($now);
	}

    return $self;
}

sub updated {
    $_[0]->{updated};
}
sub quiet {
    $_[0]->{quiet}
}

sub set_updated {
    my ($self, $val) = shift;
    $self->{updatd} = $val;
}

sub document {
    my ($self, $doc) = @_;
    die "Transform requires PPI::Document" unless ref($doc) eq 'PPI::Document';

    my $vars = $doc->find('PPI::Statement::Variable');
    my $ret = 0;
    foreach my $var (@$vars) {
        foreach my $vc ($var->children) {
            if ($vc->class eq 'PPI::Token::Symbol' and
                $vc->canonical eq '%IRSSI') {
                say "Found IRSSI Hash, processing it" unless $self->quiet;
                $ret = $self->examine_struct($vc->statement);
            }
        }
    }
    return $ret;
}

sub examine_struct {
    my ($self, $stmt) = @_;
    my $ret = 0;

    unless ($self->quiet) {
        my $dumper = PPI::Dumper->new($stmt);
        $dumper->print();
        say "-" x 60;
    }

    foreach my $node ($stmt->schildren) {

        if ($node->class eq 'PPI::Structure::List') {

            foreach my $t ($node->tokens) {
                next unless $t->significant;
                if ($t->class eq 'PPI::Token::Word' and
                    $t->content =~ m/updated/) {

                    my $val = $t->snext_sibling->snext_sibling;
                    $val->set_content($self->updated);

                    if ($val->content eq $self->updated) {
                        $ret = 1;
                    }

                    say "Thingie: " . $t->content unless $self->quiet;
                    say "value set to: " . $val->content unless $self->quiet;
                }
            }
        }
    }
    return $ret;
}

1;

