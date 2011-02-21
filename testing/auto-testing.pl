

#package Test::Irssi;

use warnings;
use strict;

# for fixed version of P:W:R
use lib $ENV{HOME} . "/projects/poe/lib";

sub PROGRAM () { "/opt/stow/repo/irssi-debug/bin/irssi" }
sub IRSSI_HOME () { $ENV{HOME} . "/projects/tmp/test/irssi-debug" }

sub ROWS () { 24 }
sub COLS () { 80 }

use Term::VT102;
use Term::TermInfo;
use feature qw/say switch/;
use Data::Dumper;
use IO::File;

my $logfile = "irssi.log";
my $logfh = IO::File->new($logfile, 'w');
 die "Couldn't open $logfile for writing: $!" unless defined $logfh;

$logfh->autoflush(1);


my $ti = Term::Terminfo->new();
my $vt = Term::VT102->new(rows => ROWS, cols => COLS);

vt_configure_callbacks($vt);

sub vt_output {
    my ($vt, $cb_name, $cb_data, $priv_data) = @_;
    say $logfh "OUTPUT: " . Dumper([@_[1..$#_]]);
}


sub vt_rowchange {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    #say $logfh "ROWCHANGE: " . Dumper(\@_);
    #say $logfh "Row $arg1 changed: ";
    #say $logfh $vt->row_plaintext($arg1);
    my $bottom_line = $vt->rows();
    say $logfh "-" x 100;
    say $logfh "Window Line";
    say $logfh  $vt->row_plaintext($bottom_line - 1);
    say $logfh "-" x 100;
    say $logfh "Prompt line";
    say $logfh  $vt->row_plaintext($bottom_line);
    say $logfh "-" x 100;


    # print $ti->getstr("clear");
    # print vt_dump();
}

sub vt_clear {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "VT Cleared";
}
sub vt_scr_dn {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "Scroll Down";
}
sub vt_scr_up {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "Scroll Up";
}
sub vt_goto {
    my ($vt, $cb_name, $arg1, $arg2, $priv_data) = @_;
    say $logfh "Goto: $arg1, $arg2";
}

sub vt_dump {
    my $str = '';
    for my $y (1..ROWS) {
        $str .= $vt->row_sgrtext($y) . "\n";
    }
    return $str;
}






sub vt_configure_callbacks {
    my ($vt) = @_;
}

### Start POE's main loop, which runs the session until it's done.
exit 0;
