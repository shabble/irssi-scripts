use strictures 1;
use MooseX::Declare;

class Test::Irssi::Test {

    use POE;
    use Test::Irssi;
    use Test::Irssi::Driver;
    use feature qw/say/;
    use Data::Dump qw/dump/;

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
          is      => 'ro',
          isa     => 'ArrayRef',
          traits  => [qw/Array/],
          default => sub { [] },
          lazy    => 1,
          handles => {
                      add_state   => 'push',
                      state_count => 'count',
                      get_state   => 'get',
                     },
         );

    has 'results'
      => (
          is      => 'ro',
          isa     => 'ArrayRef',
          default => sub { [] },
         );

    has 'complete'
      => (
          is      => 'rw',
          isa     => 'Bool',
          default => 0,
         );


    has '_next_state'
      => (
          is      => 'rw',
          isa     => 'Int',
          default => 0,
          traits  => [qw/Counter/],
          handles => {
                      _increment_state_counter => 'inc',
                      _clear_state             => 'reset',
                     },
         );

    # TODO: should only be valid when complete is set.
    sub passed {
        my $self = shift;
        return grep { 1 || undef } @{ $self->results };
    }

    sub failed {
        my $self = shift;
        return not $self->passed();
    }


    ############# API FUNCTIONS ##########################################


    method add_input_sequence(Str $input) {
        $self->add_state({input => $input });
        $self->log("Adding $input as input");
    }

    method add_delay (Num $delay) {
        $self->add_state({delay => $delay });
        $self->log("Adding $delay as delay");

    }
    method add_keycode(Str $code) {
        my $input = $self->translate_keycode($code);
        $self->add_state({input => $input });
        $self->log("Adding $input ($code) as input");

    }

    sub add_pattern_match {
        my ($self, $pattern, $constraints, $desc) = @_;
        $self->add_state({output => 1,
                          pattern => $pattern,
                          constraints => $constraints,
                          desc => $desc});

        $self->log("Adding $pattern as output match ");
    }

    sub add_cursor_position_test {
        my ($self, $x, $y, $desc) = @_;
        $self->add_state({output => 1,
                          x => $x,
                          y => $y,
                          desc => $desc });
        $self->log("Adding cursor [$x, $y] test ");

    }
    sub add_evaluation_function {
        my ($self, $coderef, $desc) = @_;
        $self->add_state({code => $coderef, desc => $desc});
    }

    ############# END OF API FUNCTIONS ####################################



    method translate_keycode(Str $code) {
        my $seq = '';
        if ($code =~ m/M-([a-z])/i) {
            $seq = "\x1b" . $1;
        } elsif ($code =~ m/C-([a-z])/i) {
            $seq = chr ( ord(lc $1) - 64 );
        }
        return $seq;
    }

    method this_state {
        return $self->_next_state - 1;
    }

    sub check_output {
        my ($self, $data) = @_;

        my ($pattern, $constraints) = ($data->{pattern}, $data->{constraints});

        my $ok = 0;
        my $line = '';
        if ($constraints eq 'prompt') {
            $line = $self->parent->get_prompt_line;
        } elsif ($constraints eq 'window_sbar') {
            $line = $self->parent->get_window_statusbar_line;
        } elsif ($constraints eq 'window') {
            # NOTE: not actually a line.
            $line = $self->parent->get_window_contents;
        } elsif ($constraints eq 'topic') {
            $line = $self->parent->get_topic_line;
        }

        if ($line =~ m/$pattern/) {
            $self->results->[$self->this_state] = 1;
        } else {
            $self->results->[$self->this_state] = 0;;
        }
    }

    sub get_next_state {
        my ($self) = @_;
        my $item = $self->get_state($self->_next_state);
        $self->_increment_state_counter;

        return $item;
    }

    sub evaluate_test {

        my ($self) = @_;
        while (my $state = $self->get_next_state) {
            $self->log("Evaluating Test: " . dump($state));

            # stimuli
            if ( exists($state->{delay})) {
                $self->log("inserting delay");
                $self->parent->apply_delay($state->{delay});
                return;
            }

            if (exists $state->{input}) {
                $self->parent->inject_text($state->{input});
                $self->log("input: ". $state->{input});
            }

            # tests
            if (exists $state->{code}) {
                # code evaluation
                my @args = ($self, $self->parent, $self->parent->vt);
                my $ret = $state->{code}->(@args);
                $ret //= 0; # ensure that undef failures are
                # marked as such.
                $self->results->[$self->this_state] = $ret;
            }

            if (exists $state->{output}) {
                # pattern match evaluation
                my $pattern = $state->{pattern};
                $self->check_output($state);
            }

        }

        $poe_kernel->post(IrssiTestDriver => 'test_complete');

        $self->complete(1);

        $self->log("Test Execution Finished");
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
