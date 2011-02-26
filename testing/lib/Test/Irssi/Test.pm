use strictures 1;
use MooseX::Declare;

class Test::Irssi::Test {

    use Test::Irssi;
    use Test::Irssi::Driver;
    use feature qw/say/;

    has 'parent'
      => (
          is       => 'ro',
          isa      => 'Test::Irssi',
          required => 1,
         );
    has 'name'
      => (
          is       => 'ro',
          isa      => 'Str',
          required => 1,
         );

    has 'description'
      => (
          is      => 'rw',
          isa     => 'Str',
          default => '',
         );

    has 'states'
      => (
          is => 'ro',
          isa => 'ArrayRef',
          traits => [qw/Array/],
          default => sub { [] },
          lazy => 1,
          handles => {
                      add_state => 'push',
                      state_count => 'count',
                      get_state => 'get',
                     },
         );

    has 'results'
      => (
          is => 'ro',
          isa => 'ArrayRef',
          default => sub { [] },
         );

    has '_next_state'
      => (
          is => 'rw',
          isa => 'Int',
          default => 0,
          traits => [qw/Counter/],
          handles => {
                      _increment_state_counter => 'inc',
                      _clear_state             => 'reset',
                     },
         );


    method add_input_sequence(Str $input) {
        $self->add_state({input => $input });
        $self->log("Adding $input as input");
    }

    method add_delay (Num $delay) {
        $self->add_state({delay => $delay });
        $self->log("Adding $delay as delay");

    }

    sub add_pattern_match {
        my ($self, $pattern, $constraints) = @_;
        $self->add_state({output => 1,
                          pattern => $expected,
                          constraints => $constraints});

        $self->log("Adding $expected as output match ");
    }

    sub add_evaluation_function {
        my ($self, $coderef) = @_;
        $self->add_state({code => $coderef});
    }

    method process_next_state {
        my $state_num = $self->_next_state;
        $self->log("PNS: $state_num");
        my $state = $self->states->[$state_num];

        my $return = 0;


        $self->_next_state($state_num+1);
        if ($self->has_next_state) {
            $self->log("Has another state");
        } else {
            $self->log("Has no more state");

            return 2;
        }

        return $return;
    }

    sub check_output {
        my ($self, $pattern) = @_;
        say "All Goodn\n\n";
    }

    sub get_next_state {
        my ($self) = @_;
        my $item = $self->get_state($self->_next_state);
        $self->_increment_state_counter;

        return $item;
    }

    sub execute {
        my ($self) = @_;
        # set this as hte currently active test.
        $self->parent->active_test($self);
        $self->evaluate_test;
    }

    sub evaluate_test {

        my ($self) = @_;
        $self->log("Eval Test:");
        while (my $state = $self->get_next_state) {
            if ( exists($state->{delay})) {
                $self->parent->apply_delay($state->{delay});
                return;
            } else {

                if (exists $state->{input}) {
                    $self->parent->inject_text($state->{input});
                    $self->log("input: ". $state->{input});
                }

                if (exists $state->{code}) {
                    my @args = ($self, $self->parent, $self->parent->vt);
                    my $ret = $state->{code}->(@args);

                if (exists $state->{output}) {
                    my $pattern = $state->{pattern};
                    $self->check_output($pattern);
                }

            }
        }
        $self->log("Execution Finished");
    }

    sub resume_from_timer {
        my ($self) = @_;
        $self->log("Resuming after timeout");
        $self->evaluate_test;
    }
    sub log {
        my ($self, $msg) = @_;
        $self->parent->_logfile_fh->say($msg);
    }

}



  __END__
