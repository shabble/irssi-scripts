=pod

=head1 NAME

growl_notify.pl

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

=over 4

=item *

Stuff.

=back

=cut

# Plan
#  Notes
#  * Main target is remote screen+irssi, accessed via ssh on local OSX/iTerm2
#    (Because that's what I use :p)
#  * Might work on windows (growl has windows port afaik)
#  * iterm active feature: "[iterm2-discuss] iTerm2 1.0.0.20111020 canary released"
#     "Add support for reporting focus lost/gained. esc[?1004h turns it on;
#     then the terminal sends esc[I when focusing, esc[O when de-focusing.
#     Send esc[?1004l to disable."

# Main features are:
# * detect activity from irssi similarly to existing activity (crap, text, hilight)
# * configurable white/blacklists for nicks, masks, activities?
# * use the Growl remote protocol (GNTP) via optional ssh backchannel?
# * easy to configure other parts (ssh tunnel, etc?)


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
              name        => '',
              description => '',
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


init();
