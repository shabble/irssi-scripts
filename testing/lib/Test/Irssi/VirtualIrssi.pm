use strictures 1;
use MooseX::Declare;

class Test::Irssi::VirtualIrssi {

# class that pretends to be irssi which you can pull out various data from.


has cursor
 => (
     is      => 'ro',
     writer  => '_set_cursor',
     isa     => 'ArrayRef[Int]',
     default => sub { [0, 0] },
    );

has topic_row
 => (
    );

has window_row
 => (
    );

has prompt_row
 => (
    );

has window
 => (
    );
}
