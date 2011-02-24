use strictures 1;
use MooseX::Declare;

class Test::Irssi::API {

    use POE;
    use Data::Dumper;

    has 'parent'
      => (
          is       => 'ro',
          isa      => 'Test::Irssi',
          required => 1,
         );


    has 'tests'
      => (
          traits => [qw/Hash/],
          is => 'rw',
          isa => 'HashRef',
          default => sub { {} },
          handles => {
                      test_names => 'keys',
                     },
         );


    sub create_test {
        my ($self, $name, $desc) = @_;
        $self->tests->{$name} = {desc => $desc, input => [], output => []};
    }

    sub simulate_input {
        my ($self, $name, $input) = @_;
        push @{ $self->tests->{$name}->{input} }, { input => $input };
    }

    sub simulate_delay {
        my ($self, $name, $delay) = @_;
        push @{ $self->tests->{$name}->{input} }, { delay => $delay };

    }

    sub expect_output {
        my ($self, $name, $regex, $line) = @_; # line is optional?
        push @{ $self->tests->{$name}->{output} }, { regex => $regex, line => $line };
    }

    sub run_test {
        my ($self, $test_name) = @_;
        my $data = $self->tests->{$test_name};
        foreach my $entry (@{ $data->{input} }) {
            if (exists $entry->{input}) {
                my $text = $entry->{input};
                $self->parent->inject_text($text);
            } elsif (exists $entry->{delay}) {
                my $delay = $entry->{delay};
                _do_delay($delay);
            } else {
                die "What: " . Dumper($entry);
            }
        }
    }

    sub run_tests {
        my ($self) = @_;
        foreach my $test_name ($self->test_names) {
            my $test = $self->tests->{$test_name};
            print "Going to prcess: $test_name";
            print Dumper($test);

        }
    }


    sub _do_delay {
        $poe_kernel->post('IrssiTestDriver' => create_delay => 5);
    }
}
