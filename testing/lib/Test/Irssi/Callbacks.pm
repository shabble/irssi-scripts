use strictures 1;

package Test::Irssi::Callbacks;

use Moose;
use Data::Dump qw/dump/;

has 'parent'
  => (
      is       => 'ro',
      isa      => 'Test::Irssi',
      required => 1,
     );

sub register_vt_callbacks {
    my ($self) = @_;

    $self->log("Callbacks registered");
    my $vt = $self->parent->vt;
    # callbacks
    $self->log("VT is " . ref($vt));

    $vt->callback_set(OUTPUT      => sub { \&vt_output    }, $self);
    $vt->callback_set(ROWCHANGE   => sub { \&vt_rowchange }, $self);
    $vt->callback_set(CLEAR       => sub { \&vt_clear     }, $self);
    $vt->callback_set(SCROLL_DOWN => sub { \&vt_scr_dn    }, $self);
    $vt->callback_set(SCROLL_UP   => sub { \&vt_scr_up    }, $self);
    $vt->callback_set(GOTO        => sub { \&vt_goto      }, $self);
}

sub vt_output {
    my ($vt, $cb_name, $cb_data, $self) = @_;
    $self->log( "OUTPUT: " . dump([@_[1..$#_]]));
}

sub vt_rowchange {
    my ($vt, $cb_name, $arg1, $arg2, $self) = @_;

    $self->log("Type of param is: " . ref($_)) for (@_);

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
    my ($vt, $cb_name, $arg1, $arg2, $self) = @_;
    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "VT Cleared");
}

sub vt_scr_dn {
    my ($vt, $cb_name, $arg1, $arg2, $self) = @_;
    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "Scroll Down");
}

sub vt_scr_up {
    my ($vt, $cb_name, $arg1, $arg2, $self) = @_;
    $arg1 //= '?';
    $arg2 //= '?';

    $self->log( "Scroll Up");
}


sub vt_goto {
    my ($vt, $cb_name, $arg1, $arg2, $self) = @_;
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
    $self->parent->_logfile_fh->say($msg);
}

__PACKAGE__->meta->make_immutable;

no Moose;

