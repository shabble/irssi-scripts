use strict;
use warnings;
use Irssi;

our %IRSSI = (
             "author"      => 'shabble',
             "contact"     => 'shabble+irssi@metavore.org, shabble@Freenode/#irssi',
             "name"        => 'URL Highlighter',
             "description" => ' '
             "license"     => 'WTFPL: http://sam.zoy.org/wtfpl/'
             "version"     => '0.1'
            );

# regex taken from http://daringfireball.net/2010/07/improved_regex_for_matching_urls
my $url_regex = qr((?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’])));

sub handle_gui_print_text {
    my ($win, $fg, $bg, $flags, $text, $text_dest) = @_;
    if ($text =~ $url_regex) {
        print "matched!";
    }
}


Irssi::signal_add('gui print text', \&handle_gui_print_text);

