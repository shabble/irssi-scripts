use strict;
use warnings;


use Irssi;

my @colors = (0..255);
my @names  = qw/black red green yellow blue magenta cyan white/;
#my @bnames = map { "bold_$_" } @names;

#@names = (@names, @bnames);

foreach my $c (@colors) { 
    my $n = $names[$c] // $c;
    Irssi::print("\%$c This is bg color $n\%n");
}
