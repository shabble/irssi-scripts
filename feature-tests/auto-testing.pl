#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/say/;

package Manager;
use Moose;
with qw(MooseX::Workers);

use POE qw(Filter::Reference Filter::Stream);

use Term::VT102;

has 'vt'
  => (
      is => 'ro',
      isa => 'Term::VT102',
      required => 1,
      lazy => 1,
      builder => '_build_vt'
     );

sub _build_vt {
    my $vt = Term::VT102->new(cols => 80, rows => 24);
    $vt->callback_set('OUTPUT', \&vt_output, undef);

    return $vt;
}

sub vt_output { 
    my ($vt, $cb_name, $data, $priv) = @_;
    say "Data is: $data"
}
sub run {
    my $self = shift;
    my $job = MooseX::Workers::Job->new
      (
       name => "Irssi",
       command => "/opt/stow/repo/irssi-debug/bin/irssi",
       args => [ "--home=/tmp" ],
      );

    $self->spawn($job);

    POE::Kernel->run();
}

# Implement our Interface
#    These two are both optional; if defined (as here), they
#    should return a subclass of POE::Filter.
sub stdout_filter  { new POE::Filter::Stream }
sub stderr_filter  { new POE::Filter::Line }

sub worker_stdout  {
    my ( $self, $data ) = @_;

    $self->vt->process($data);
}

sub worker_manager_start { warn 'started worker manager' }
sub worker_manager_stop  { warn 'stopped worker manager' }

sub max_workers_reached  { warn 'maximum worker count reached' }
sub worker_error   { shift; warn join ' ', @_;  }
sub worker_done    { shift; warn join ' ', @_;  }
sub worker_started { shift; warn join ' ', @_;  }
sub sig_child      { shift; warn join ' ', @_;  }
sub sig_TERM       { shift; warn 'Handled TERM' }

no Moose;

Manager->new->run();

