
use strict;
use warnings;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw
use Data::Dumper;


# TODO: maybe eval { use Term::Size } and use tthat if poss.
our $VERSION = "0.2";
our %IRSSI =
  (
   authors         => "shabble",
   contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
   name            => "overlays",
   description     => "Library script for drawing overlays on irssi UI",
   license         => "MIT",
   changed         => "24/7/2010"
  );

# overlay  := { $num1 => line1, $num2 => line2 }
# line     := [ region, region, region ]
# region   := { start => x, end => y, ...? }

my $overlays;
my ($term_w, $term_h) = (0, 0);

sub DEBUG () { 1 }

sub update_terminal_size {

    my @stty_data = qx/stty -a/;
    my $line = $stty_data[0];

    # linux
    # speed 38400 baud; rows 36; columns 126; line = 0;
    if ($line =~ m/rows (\d+); columns (\d+);/) {
        $term_h = $1;
        $term_w = $2;
        # osx
        # speed 9600 baud; 40 rows; 235 columns;
    } elsif ($line =~ m/(\d+) rows; (\d+) columns;/) {
        $term_h = $1;
        $term_w = $2;
    } else {
        # guess?
        $term_h = 24;
        $term_w = 80;
    }

    print "Terminal detected as $term_w cols by $term_h rows" if DEBUG;
}
