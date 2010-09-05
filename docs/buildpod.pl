#!/usr/bin/env perl

use strict;
use warnings;

package Pod::Simple::HTMLBatch::Custom;

use base qw/Pod::Simple::HTMLBatch/;

use vars qw/$VERSION/;

$VERSION = '0.01';
sub esc {
    return Pod::Simple::HTMLBatch::esc(@_);
}

sub new {
    print "Hello!\n";
    my $self = shift;
    my $obj = $self->SUPER::new(@_);

    $obj->css_flurry(0);
    $obj->javascript_flurry(0);


    my @index_header = ("<html>\n",
                        "<head>\n",
                        "<title>Irssi Scripting Documentation</title>\n",
                        "</head><body class='contentspage'>\n",
                        "<h1>Irssi Scripting Documentation</h1>\n",
                        q(<p><b>This is a work in progress. If you ),
                        q(find something obviously wrong, or have requests ),
                        q(for further documentation on topics not yet ),
                        q(filled out, please ),
                        q(<a href="http://github.com/shabble/shab-irssi-scripts/issues#">create an issue</a>),
                        " on my Github page, and I'll see what I can do.</b></p>",
                       );

    $obj->contents_page_start(join("", @index_header));


    my $index_footer =  sprintf("\n\n<p class='contentsfooty'>Generated "
                                . "by %s v%s under Perl v%s\n<br >At %s GMT"
                                . ", which is %s local time.</p>\n\n</body></html>\n",
                                esc(ref($obj), $VERSION,
                                    $], scalar(gmtime), scalar(localtime)));


    my @copyright = (
                     "<p><small>Much of the content on these pages is taken",
                     " from original Irssi documentation, and is Copyright",
                     " &copy; 2000-2010 The Irssi project.<br/>",
                     " Formatting and additional documentation by Tom Feist",
                     " <code>shabble+irssi\@metavore.org</code>",
                     "</small></p>");

    $obj->contents_page_end($index_footer . join("", @copyright));

    return $obj;
}



sub _write_contents_middle {
  my($self, $Contents, $outfile, $toplevel2submodules, $toplevel_form_freq) = @_;

  foreach my $t (sort keys %$toplevel2submodules) {
    my @downlines = sort {$a->[-1] cmp $b->[-1]}
                          @{ $toplevel2submodules->{$t} };

    printf $Contents qq[<dt><a name="%s">%s</a></dt>\n<dd>\n],
      esc( $t, $toplevel_form_freq->{$t} ) ;

    my($path, $name);
    foreach my $e (@downlines) {
      $name = $e->[0];
      $path = join( "/", '.', esc( @{$e->[3]} ) )
        . ($POD::Simple::HTMLBatch::HTML_EXTENSION
           || $Pod::Simple::HTML::HTML_EXTENSION);
      print $Contents qq{  <a href="$path">}, esc($name), "</a><br/>\n";
    }
    print $Contents "</dd>\n\n";
  }
  return 1;
}

1;

package main;

use File::Copy;

my $output_dir = "../../tmp/shab-irssi-scripts/docs/";
my $batchconv = Pod::Simple::HTMLBatch::Custom->new;
my $css = 'podstyle.css';

$batchconv->add_css('podstyle.css', 1);

$batchconv->batch_convert([qw/./], $output_dir);
print "Copying CSS...\n";
copy($css, $output_dir . $css);
print "Done\n";
