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
              name        => 'linehax',
              description => 'Doing various things with the '
              . 'contents of window buffers',
              license     => 'MIT',
              updated     => '$DATE'
             );

sub find_line {
    my ($win, $pattern) = @_;

    my @lines = _get_all_lines($win);

    return unless @lines;

    foreach my $line (@lines) {
        next unless $line;
#        $win->print("Line is: " . ref($line));

        my ($lobj, $ltext, $lnum) = @$line;
        #$win->print("Trying line: >>$ltext<<");
        if ($ltext =~ m/\Q$pattern\E/) {
            #$win->print("Matched [$lnum] $lobj ($ltext)");
            return $lobj;
        }
    }
    $win->print("No match");
    return;
}

sub _get_all_lines {
    my ($win) = @_;
    my $view = $win->view;

    my $view_buffer = $view->{buffer};
    my $lines_count = $view_buffer->{lines_count};

    my @lines;
    my $line = $view_buffer->{first_line};

    for (0..$lines_count - 1) {
        push @lines, [ $line, $line->get_text(0), $_ ];
        $line = $line->next();
    }
    return @lines;
}

sub cmd_subs {
    my ($str, $server, $witem) = @_;

    my $level = Irssi::MSGLEVEL_CLIENTCRAP;

    my $win;
    if (defined $witem) {
        $win = $witem->window();
    }

    # fallback.
    $win = Irssi::active_win() unless defined $win;


    my ($match, $replace);

    if ($str =~ m|^\s*s/(.+?)/(.*?)/\s*$|) {
        #$win->print("Matched: $1, $2");
        $match = $1;
        $replace = $2;
    } else {
        $win->print("Invalid arguments to subs: '$str'");
        return;
    }


    my @lines = _get_all_lines($win);
    #$win->print(Dumper([ map { $_->get_text(0) } @lines]));
    #$win->print(Dumper(\@lines));

    my $matching_line = find_line($win, $match);
    if ($matching_line) {
        my $line_text = $matching_line->get_text(0);

        my $new_text = $line_text;
        $new_text =~ s/\Q$match\E/$replace/g;

        if ($new_text ne $line_text) {
            $win->print_after($matching_line, $level, $new_text);
            $win->view()->remove_line($matching_line);
            $win->view()->redraw();
        }
    } else {
        $win->print("No matches found for '$match'");
    }
}

Irssi::command_bind 'subs', \&cmd_subs;
