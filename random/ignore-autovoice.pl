
=pod

=head1 NAME

ignore-autovoice.pl

=head1 DESCRIPTION

Ignores C<+m> mode changes in all (or a custom subset) of your channels, to avoid
mode-spam without ignoring all modes.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.

=head1 USAGE

TODO

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

# Question: how to mark a signal in one event and apply actions to it later on?
# TODO: make this a generic 'some modes only' thing.
our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'ignore-autovoice',
              description => 'ignores autovoice +m mode changes',
              license     => 'MIT',
              updated     => '$DATE'
             );


sub init {
    
    Irssi::settings_add_string('ignore-autovoice', '
    Irssi::signal_add('setup changed', \&sig_setup_changed);
    Irssi::signal_add('');
}

sub sig_setup_changed {

}

sub sig_mode_changed {

}
