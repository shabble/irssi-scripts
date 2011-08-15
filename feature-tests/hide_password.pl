=pod

=head1 NAME

hide_password.pl

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
              name        => '',
              description => '',
              license     => 'MIT',
              updated     => '$DATE'
             );


my $password_active;
my $password_buffer;

sub PASSWORD_CHAR () { ord('#') }

sub init {
    Irssi::command_bind('password', \&cmd_password);
    $password_active = 0;
    $password_buffer = '';

}

sub cmd_password {

    # not sure why this delay is needed, but otherwise
    # setting the input (" Password: ") doesn't work.
    Irssi::timeout_add_once(10, sub {
                                Irssi::gui_input_set('Password: ');
                                begin_entry_redirect();
                            }, 0);
}

sub begin_entry_redirect {
    $password_active = 1;
    $password_buffer = '';

    Irssi::signal_add_first('gui key pressed', 'sig_key_pressed');

}

sub end_entry_redirect {
    Irssi::signal_remove('gui key pressed', 'sig_key_pressed');
    $password_active = 0;
}

sub password_complete {
    Irssi::active_win->command("/echo Your password is: $password_buffer");
    Irssi::gui_input_set('');
}

sub sig_key_pressed {
    my ($key) = @_;

    return unless $password_active;

    my $char = chr $key;
    if ($char =~ m/\r|\n/) {
        end_entry_redirect();
        password_complete();
        Irssi::signal_stop;
    } else {
        # TODO: Test if the char is printable, and abort otherwise?
        $password_buffer .= $char;
        Irssi::signal_continue(PASSWORD_CHAR);
    }
}

init();
