use strictures 1;
use MooseX::Declare

our $VERSION = 0.01;

class Test::Irssi {

    use Term::VT102;
    use Term::Terminfo;
    use feature qw/say switch/;
    use Data::Dump;
    use IO::File;

    has 'irssi_binary'
      => (
          is => 'ro',
          isa => 'Str',
          required => 1,
         );

    has 'irssi_homedir'
      => (
          is => 'ro',
          isa => 'Str',
          required => 1,
         );

    has 'terminal_width'
      => (
          is => 'ro',
          isa => 'Int',
          required => 1,
          default => 80,
         );

    has 'terminal_height'
      => (
          is => 'ro',
          isa => 'Int',
          required => 1,
          default => 24,
         );

    has 'logfile'
      => (
          is => 'ro',
          isa => 'Str',
          required => 1,
          default => 'irssi-test.log',
         );

    has '_logfile_fh'
      => (
          is => 'ro',
          isa => 'IO::File',
          required => 1,
          lazy => 1,
          builder => '_build_logfile_fh',
         );


    method _build_logfile_fh {
        my $fh = IO::File->new($self->logfile, 'w');
        die "Couldn't open $logfile for writing: $!" unless defined $fh;
        $fh->autoflush(1);

        return $fh;
    }





    method log (Str $msg) {
        say $self->_logfile_fh $msg;
    }
}
__END__

=head1 NAME

Test::Irssi

=head1 ABSTRACT

Abstract goes here

=head1 SYNOPSIS

blah blah blah
