use strictures 1;
use MooseX::Declare;

our $VERSION = 0.02;

class Test::Irssi {

    # requires the latest pre-release POE from
    # https://github.com/rcaputo/poe until a new release is...released.
    use lib $ENV{HOME} . "/projects/poe/lib";
    use POE;

    use Term::VT102;
    use Term::Terminfo;
    use feature qw/say switch/;
    use Data::Dump;
    use IO::File;

    use Test::Irssi::Driver;
    use Test::Irssi::Callbacks;
    use Test::Irssi::Test;

    has 'generate_tap'
      => (
          is       => 'rw',
          isa      => 'Bool',
          required => 1,
          default  => 1,
         );

    has 'irssi_binary'
      => (
          is       => 'ro',
          isa      => 'Str',
          required => 1,
         );

    has 'irssi_homedir'
      => (
          is       => 'ro',
          isa      => 'Str',
          required => 1,
         );

    has 'terminal_width'
      => (
          is       => 'ro',
          isa      => 'Int',
          required => 1,
          default  => 80,
         );

    has 'terminal_height'
      => (
          is       => 'ro',
          isa      => 'Int',
          required => 1,
          default  => 24,
         );

    has 'vt'
      => (
          is       => 'ro',
          isa      => 'Term::VT102',
          required => 1,
          lazy     => 1,
          builder  => '_build_vt_obj',
         );

    has 'logfile'
      => (
          is       => 'ro',
          isa      => 'Str',
          required => 1,
          default  => 'irssi-test.log',
         );

    has '_logfile_fh'
      => (
          is       => 'ro',
          isa      => 'IO::File',
          required => 1,
          lazy     => 1,
          builder  => '_build_logfile_fh',
         );

    has 'driver'
      => (
          is       => 'ro',
          isa      => 'Test::Irssi::Driver',
          required => 1,
          lazy     => 1,
          builder  => '_build_driver_obj',
          handles  => {
                       run_headless => 'headless',
                      }
         );

    has '_callbacks'
      => (
          is       => 'ro',
          isa      => 'Test::Irssi::Callbacks',
          required => 1,
          lazy     => 1,
          builder  => '_build_callback_obj',
         );

    has 'pending_tests'
      => (
          is       => 'ro',
          isa      => "ArrayRef",
          required => 1,
          default  => sub { [] },
          traits   => [qw/Array/],
          handles  => {
                       add_pending_test  => 'push',
                       next_pending_test => 'shift',
                       tests_remaining   => 'count',
                      }
         );

    has 'completed_tests'
      => (
          is       => 'ro',
          isa      => "ArrayRef",
          required => 1,
          default  => sub { [] },
          traits   => [qw/Array/],
          handles  => {
                       add_completed_test => 'push',
                       tests_completed => 'count',
                      },
         );

    has 'active_test'
      => (
          is  => 'rw',
          isa => 'Test::Irssi::Test',
         );

    sub new_test {
        my ($self, $name, @params) = @_;
        my $new = Test::Irssi::Test->new(name => $name, 
                                         parent => $self,
                                         @params);
        $self->add_pending_test($new);
        return $new;
    }

    method _build_callback_obj {
        Test::Irssi::Callbacks->new(parent => $self);
    }

    method _build_driver_obj {
        Test::Irssi::Driver->new(parent => $self);
    }

    method _build_vt_obj {
        my $rows = $self->terminal_height;
        my $cols = $self->terminal_width;

        Term::VT102->new($cols, $rows);
    }

    method _build_logfile_fh {

        my $logfile = $self->logfile;

        my $fh = IO::File->new($logfile, 'w');
        die "Couldn't open $logfile for writing: $!" unless defined $fh;
        $fh->autoflush(1);

        return $fh;
    }

    method _vt_setup {
        # options
        my $vt = $self->vt;

        $vt->option_set(LINEWRAP => 1);
        $vt->option_set(LFTOCRLF => 1);

        $self->_callbacks->register_callbacks;

    }
    method screenshot {
        my $data = '';
        my $vt = $self->vt;
        foreach my $row (1 .. $vt->rows) {
            $data .= $vt->row_plaintext($row) . "\n";
        }
        return $data;
    }

    method complete_test {
        # put the completed one onto the completed pile
        my $old_test = $self->active_test;
        $self->add_completed_test($old_test);

        # TAP: print status.
        if ($self->generate_tap) {
            my $pass = $old_test->passed;
            my $tap = sprintf("%s %d - %s", $pass?'ok':'not ok',
                              $self->tests_completed,
                              $old_test->description);
            say STDOUT $tap;
            if (not $pass) {
                $old_test->details;
                $self->log("-------------------");
                $self->log($self->screenshot);
                $self->log("-------------------");

            }
        }
    }

    method run_test {
        # and make the next pending one active.
        my $test = $self->next_pending_test;
        $self->active_test($test);

        # signal to the driver to start executing it.
        $poe_kernel->post(IrssiTestDriver => execute_test => $test);
    }

    method run {

        $self->driver->setup;
        $self->_vt_setup;
        $self->log("Driver setup complete");
        ### Start a session to encapsulate the previous features.

        # TAP: print number of tests.
        if ($self->generate_tap) {
            print STDOUT "1.." . $self->tests_remaining . "\n";
        }

        $poe_kernel->run();
    }

    sub apply_delay {
        my ($self, $delay, $next_index) = @_;
        $poe_kernel->post(IrssiTestDriver
                          => create_delay
                          => $delay, $next_index);
    }

    # TODO: pick one.
    sub inject_text {
        my ($self, $text) = @_;
        $poe_kernel->post(IrssiTestDriver => got_terminal_stdin
                          => $text);
    }

    sub simulate_keystroke {
        my ($self, $text) = @_;
        $poe_kernel->post(IrssiTestDriver => got_terminal_stdin
                          => $text);

    }

    method get_topic_line {
        return $self->vt->row_plaintext(1);
    }

    method get_prompt_line {
        return $self->vt->row_plaintext($self->terminal_height);
    }

    method get_window_statusbar_line {
        return $self->vt->row_plaintext($self->terminal_height() - 1);
    }

    method get_window_contents {
        my $buf = '';
        for (2..$self->terminal_height() - 2) {
            $buf .=  $self->vt->row_plaintext($_);
        }
        return $buf;
    }

    method get_cursor_position {
        return ($self->vt->x(), $self->vt->y());
    }

    method load_script {
        my ($script_name) = @_;

    }

    method summarise_test_results {
        foreach my $test (@{$self->completed_tests}) {
            my $name = $test->name;
            printf("Test %s\t\t-\t%s\n", $name, $test->passed?"pass":"fail");
            $test->details();
        }
    }

    sub log {
        my ($self, $msg) = @_;
        $self->_logfile_fh->say($msg);
    }

}

  __END__

=head1 NAME

Test::Irssi - A cunning testing system for Irssi scripts

=head1 SYNOPSIS

blah blah blah
