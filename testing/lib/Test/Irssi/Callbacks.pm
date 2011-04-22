use strictures 1;

package Test::Irssi::Callbacks;

use Moose;
use Data::Dump qw/dump/;
use Data::Dumper;

has 'parent'
  => (
      is       => 'ro',
      isa      => 'Test::Irssi',
      required => 1,
     );

sub register_callbacks {
    my ($self) = @_;

    my $vt = $self->parent->vt;
    $self->log("Callbacks registered");

    $vt->callback_set(OUTPUT      => sub { $self->vt_output(@_)    }, undef);
    $vt->callback_set(ROWCHANGE   => sub { $self->vt_rowchange(@_) }, undef);
    $vt->callback_set(CLEAR       => sub { $self->vt_clear(@_)     }, undef);
    $vt->callback_set(SCROLL_DOWN => sub { $self->vt_scr_up(@_)    }, undef);
    $vt->callback_set(SCROLL_UP   => sub { $self->vt_scr_dn(@_)    }, undef);
    $vt->callback_set(GOTO        => sub { $self->vt_goto(@_)      }, undef);

}

sub vt_output {
    my ($self, $vt, $cb_name, $cb_data) = @_;
    $self->log( "OUTPUT: " . dump([@_[1..$#_]]));
}

sub vt_rowchange {
    my $self = shift;
    my ($vt, $cb_name, $arg1, $arg2) = @_;

    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "-" x 100);
    $self->log( "Row $arg1 changed: ");

    my $bottom_line = $vt->rows();

    $self->log( "-" x 100);
    $self->log( "Window Line");
    $self->log( "-" x 100);
    $self->log(  $vt->row_plaintext($bottom_line - 1));
    $self->log( "-" x 100);
    $self->log( "Prompt line");
    $self->log( "-" x 100);
    $self->log(  $vt->row_plaintext($bottom_line));

}

sub vt_clear {
    my $self = shift;
    my ($vt, $cb_name, $arg1, $arg2) = @_;
    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "VT Cleared");
}

sub vt_scr_dn {
    my $self = shift;
    my ($vt, $cb_name, $arg1, $arg2) = @_;
    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "Scroll Down");
}

sub vt_scr_up {
    my $self = shift;
    my ($vt, $cb_name, $arg1, $arg2) = @_;
    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "Scroll Up");
}


sub vt_goto {
    my $self = shift;
    my ($vt, $cb_name, $arg1, $arg2) = @_;
    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "Goto: $arg1, $arg2");
}

sub vt_dump {
    my ($self) = @_;
    my $vt = $self->parent->vt;
    my $rows = $self->parent->terminal_height;
    my $str = '';
    for my $y (1..$rows) {
        $str .= $vt->row_sgrtext($y) . "\n";
    }

    return $str;
}

sub log {
    my ($self, $msg) = @_;
    #$self->parent->_logfile_fh->say($msg);
}

__PACKAGE__->meta->make_immutable;

no Moose;



# # delegate to Callbacks.
# sub vt_dump {
#     my ($self) = @_;
#     my $cb = $self->parent->_callbacks->vt_dump();
# }
