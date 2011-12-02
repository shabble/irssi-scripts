=pod

=head1 NAME

template.pl

=head1 DESCRIPTION

A minimalist template useful for basing actual scripts on.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.

=head1 USAGE

None, since it doesn't actually do anything.

=head1 AUTHORS

Copyright E<copy> 2011 Tom Feist C<E<lt>shabble+irssi@metavore.orgE<gt>>

=head1 LICENCE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 BUGS

=head1 TODO

Use this template to make an actual script.

=cut

use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'history-restore',
              description => '',
              license     => 'MIT',
              updated     => '$DATE'
             );

my @fake_history;
#  = ( "test", "test2", "test3" );

push @fake_history, "Test Entry $_" for (1..100);

my $buf;
my @hist_queue = ();

sub init {
    Irssi::theme_register
        ([
          verbatim      => '[$*]',
          script_loaded => 'Loaded script {hilight $0} v$1',
         ]);

    # definitely not an int for last param.
    #Irssi::signal_register({'key down' => [qw/string string int/] });
    Irssi::command_bind('dohist',   \&cmd_dohist);
    Irssi::command_bind('showhist', \&cmd_showhist);


    Irssi::printformat(Irssi::MSGLEVEL_CLIENTCRAP, 'script_loaded',
                       $IRSSI{name}, $VERSION);


}

sub win {
    return $_[0] || Irssi::active_win();
}


sub do_next {
    if (length $buf) {
        my $char = substr($buf, 0, 1, '');
        _key($char);
        do_next();

        #Irssi::timeout_add_once(10,
        #                        sub {
        #                        }, '');
    } else {
        $buf = shift @hist_queue;
        _down();
        if ($buf) {
            do_next();
        } else {
            print "Queue empty";
            Irssi::timeout_add_once(100,
                                    sub {
                                        print "Done";
                                        Irssi::command("/showhist");
                                    }, '');

        }
    }
}

sub cmd_dohist {
    my ($args, $server, $witem) = @_;

    print "Inserting fake history...";
    @hist_queue = @fake_history;
    do_next();


}

sub _key {
    Irssi::signal_emit('gui key pressed', ord($_[0]));
}
sub _down {
    _key($_) for ("\e", "[", "B");
}

sub cmd_showhist {
    my ($args, $server, $witem) = @_;
    #print "Args: " . Dumper(\@_);
    dump_history(win($witem));
}

sub dump_history {
    my ($win) = @_;
    my @history = $win->get_history_lines();
    my $i = 0;

    print "---------HISTORY-----------";

    for (@history) {
        $i++;
        printf("%02d: %s", $i, $_);
    }
    print "---------------------------";
}

init();


    # my $m = 0;
    # for my $entry (@fake_history) {
    #     my $n = 0;
    #     $m++;
    #     for my $char (split '', $entry) {
    #         $n++;
    #         Irssi::timeout_add_once(100 * $n * $m,
    #                                 sub { print "$char of $entry scheduled at "
    #                                         . (100 * $n * $m);
    #                                       _key($char)
    #                                   }, '');
    #     }
    #     Irssi::timeout_add_once(100 * $n * $m,
    #                             sub { print "Down scheduled at "
    #                                     . (100 * $n * $m);
    #                                   _down();
    #                               }, '');
    # }
