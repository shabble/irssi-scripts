=pod

=head1 NAME

iterm_growl_activity.pl

=head1 DESCRIPTION

A script that combines Irssi activity notifications with the Growl notification
system.

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
              name        => 'iterm_growl_activity',
              description => 'generate growl notifications via iterm2 magical '
                           . 'escape sequences if the window is not active',
              license     => 'MIT',
              updated     => '$DATE'
             );

sub init {
    Irssi::theme_register
        ([
          verbatim      => '[$*]',
          script_loaded => 'Loaded script {hilight $0} v$1',
         ]);
    Irssi::printformat(Irssi::MSGLEVEL_CLIENTCRAP,
                       'script_loaded', $IRSSI{name}, $VERSION);


}

sub iterm_toggle_term_focus {
    # ensure we handle the commands.

    Irssi::command('bind meta-O nothing inactive');
    Irssi::command('bind meta-I nothing inactive');

    my ($enable) = @_;
    print STDERR "\e[?1004" . ($enable ? 'h' : 'l');
}


init();
