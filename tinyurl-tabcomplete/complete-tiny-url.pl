=pod

=head1 NAME

complete-tiny-url.pl

=head1 DESCRIPTION

Shortens web links from your Irssi input field by pressing tab directly after
them.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD complete-tiny-url.pl>. You may wish to have it autoload in one of the
L<usual ways|https://github.com/shabble/irssi-docs/wiki/Guide#Autorunning_Scripts>.

=head1 USAGE

Type or paste a URL into your input field, then immediately following the last
character of it, press the C<E<lt>TABE<gt>> key.  After a few seconds, the
URL will be replaced with an appropriate L<http://tinyurl.com/> address.

=head1 AUTHORS

Copyright E<copy> 2010-2011 Tom Feist C<E<lt>shabble+irssi@metavore.orgE<gt>> and

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

None Known. Please report any at
L<https://github.com/shabble/irssi-scripts/issues/new>

=cut


use strict;
use warnings;

use Irssi;
use WWW::Shorten::TinyURL;

our $VERSION = '1.0';
our %IRSSI = (
    authors     => 'Shabble',
    contact     => 'shabble+irssi /at/ metavore /dot/ org',
    name        => 'Shorten URLs using Tab',
    description => 'Hitting Tab after typing/pasting a long URL will replace it with'
                 . ' its tinyURL.com equivalent',
    license     => 'MIT',
);

sub do_complete {
	my ($strings, $window, $word, $linestart, $want_space) = @_;
    # needs some context.
	return if $word eq '';
    my $found_uri = match_uri($word);

    # don't re-reduce already tiny urls.
    if (defined $found_uri && $found_uri !~ m/tinyurl\./i) {

        #print "Going to reduce: $found_uri";
        my $uri = makeashorterlink($found_uri);

        push @$strings, $uri if $uri;
        $$want_space = 1;
        Irssi::signal_stop();
    }
}

sub match_uri {
    my $text = shift;
    # url matching regex taken
    # from http://daringfireball.net/2010/07/improved_regex_for_matching_urls
    my $regex = qr((?xi)
\b
(                           # Capture 1: entire matched URL
  (?:
    [a-z][\w-]+:                # URL protocol and colon
    (?:
      /{1,3}                        # 1-3 slashes
      |                             #   or
      [a-z0-9%]                     # Single letter or digit or '%'
                                    # (Trying not to match e.g. "URI::Escape")
    )
    |                           #   or
    www\d{0,3}[.]               # "www.", "www1.", "www2." … "www999."
    |                           #   or
    [a-z0-9.\-]+[.][a-z]{2,4}/  # looks like domain name followed by a slash
  )
  (?:                           # One or more:
    [^\s()<>]+                      # Run of non-space, non-()<>
    |                               #   or
    \(([^\s()<>]+|(\([^\s()<>]+\)))*\)  # balanced parens, up to 2 levels
  )+
  (?:                           # End with:
    \(([^\s()<>]+|(\([^\s()<>]+\)))*\)  # balanced parens, up to 2 levels
    |                                   #   or
    [^\s`!()\[\]{};:'".,<>?«»“”‘’]        # not a space or one of these punct chars
  )
));


    if ($text =~ $regex) {
        my $uri = $1;
        # shorten needs the http prefix or it'll treat it as a relative link.
        $uri = 'http://' . $uri if $uri !~ m([a-z][\w-]+:(?:/{1,3}|[a-z0-9%]));
        return $uri;
    } else {
        # no match
        return undef;
    }
}

Irssi::signal_add_first( 'complete word',  \&do_complete);
