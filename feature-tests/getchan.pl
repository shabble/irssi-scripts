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
              name        => '',
              description => '',
              license     => 'MIT',
              updated     => '$DATE'
             );

sub get_format_string {
    my ($module, $tag, $theme) = @_;

    $theme ||= Irssi::current_theme();
    my $format_str;
    {
        # deeeeeeep black magic.
        #print "Trying to get format for $module, $tag";
        local *CORE::GLOBAL::caller = sub { $module };
        $format_str = $theme->get_format($module, $tag);
    }
    return $format_str;
}

my $fmt = get_format_string('fe-common/core', 'chansetup_line');

if ($fmt) {
    Irssi::command("^FORMAT chansetup_line Meep meep $fmt");
    Irssi::command("CHANNEL LIST");
    Irssi::command("^FORMAT chansetup_line $fmt");
} else {
    print "Failed to get format :(";
}

# Irssi::UI::Theme::get_format(Irssi::UI::Theme $theme, string $module, string $tag)

# in fe-common/core
#
#  chansetup_not_found = "Channel {channel $0} not found";
#  chansetup_added = "Channel {channel $0} saved";
#  chansetup_removed = "Channel {channel $0} removed";
#  chansetup_header = "%#Channel         Network    Password   Settings";
#  chansetup_line = "%#{channel $[15]0} %|$[10]1 $[10]2 $3";
#  chansetup_footer = "";
# Irssi::active_win->actually_printformat(Irssi::MSGLEVEL_CRAP, 'fe-common/core',
#                                         'window_name_not_unique')
