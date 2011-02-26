use strictures 1;
use MooseX::Declare;

our $VERSION = 0.01;

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

    has '_driver'
      => (
          is       => 'ro',
          isa      => 'Test::Irssi::Driver',
          required => 1,
          lazy     => 1,
          builder  => '_build_driver_obj',
         );

    has '_callbacks'
      => (
          is       => 'ro',
          isa      => 'Test::Irssi::Callbacks',
          required => 1,
          lazy     => 1,
          builder  => '_build_callback_obj',
         );

    has 'tests'
      => (
          is => 'ro',
          isa => "HashRef",
          required => 1,
          default => sub { {} },
          traits => [qw/Hash/],
          handles => {
                      all_tests => 'values'
                     },
         );

    has 'active_test'
      => (
          is  => 'rw',
          isa => 'Test::Irssi::Test',
         );

    sub new_test {
        my ($self, $name, @params) = @_;
        my $new = Test::Irssi::Test->new(name => $name, parent => $self);
        $self->tests->{$name} = $new;
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

        $self->_callbacks->register_callbacks;;

    }

    sub log {
        my ($self, $msg) = @_;
        $self->_logfile_fh->say($msg);
    }

    method run_tests {
        foreach my $test ($self->all_tests) {
            $test->execute();
        }
    }

    method run {
        $self->_driver->setup;
        $self->_vt_setup;
        $self->log("Driver setup complete");
        ### Start a session to encapsulate the previous features.
        $poe_kernel->run();
    }

    sub apply_delay {
        my ($self, $delay, $next_index) = @_;
        $poe_kernel->post(IrssiTestDriver
                          => create_delay
                          => $delay, $next_index);
    }

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

    method get_prompt_line {
        return $self->vt->row_plaintext($self->terminal_height)
    }

    method get_window_statusbar_line {
        return $self->vt->row_plaintext($self->terminal_height() - 1)
    }
}

__END__

=head1 NAME

Test::Irssi - A cunning testing system for Irssi scripts

=head1 SYNOPSIS

blah blah blah
