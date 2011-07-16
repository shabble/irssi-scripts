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


my $line_format;
my $head_format;
my $foot_format;

my $channels = {};
my @errors;
my $state;

sub get_format_string {
    my ($module, $tag, $theme) = @_;

    $theme ||= Irssi::current_theme;
    return $theme->get_format($module, $tag);
}


sub get_channels {
    # see here: https://github.com/shabble/irssi-docs/wiki/complete_themes
    $line_format = get_format_string('fe-common/core', 'chansetup_line');
    $head_format = get_format_string('fe-common/core', 'chansetup_header');
    $foot_format = get_format_string('fe-common/core', 'chansetup_footer');

    my $parse_line_format = "channel:\$0\tnet:\$1\tpass:\$2\tsettings:\$3";
    Irssi::command("^FORMAT chansetup_line $parse_line_format");
    Irssi::command("^FORMAT chansetup_header START");
    Irssi::command("^FORMAT chansetup_footer END");

    $state = 0;
    Irssi::signal_add_first('print text', 'sig_print_text');
    Irssi::command("CHANNEL LIST");
    Irssi::signal_remove('print text', 'sig_print_text');

}

sub restore_formats {
    Irssi::command("^FORMAT chansetup_line $line_format");
    Irssi::command("^FORMAT chansetup_header $head_format");
    if ($foot_format =~ m/^\s*$/) {
        Irssi::command("^FORMAT -reset chansetup_footer");
    } else {
        Irssi::command("^FORMAT  chansetup_footer $foot_format");
    }
}

sub sig_print_text {
    my ($dest, $text, $stripped) = @_;

    my $entry = {};

    if ($state == 0 && $text =~ m/START/) {
        $state = 1;
    } elsif ($state == 1) {
        # TODO: might we get multiple lines at once?
        if ($text =~ m/channel:([^\t]+)\tnet:([^\t]+)\tpass:([^\t]*)\tsettings:(.*)$/) {
            $entry->{channel}  = $1;
            $entry->{network}  = $2;
            $entry->{password} = $3;
            $entry->{settings} = $4;

            my $tag = "$2/$1";
            $channels->{$tag} = $entry;

        } elsif ($text =~ m/END/) {
            $state = 0;
        } else {
            push @errors, "Failed to parse: '$text'";
        }
    }
    Irssi::signal_stop();
}

sub go {
    eval {
        get_channels();
    };
    if ($@) {
        print "Error: $@. Reloading theme to restore format";
        Irssi::themes_reload();
    } else {
        restore_formats();
    }
    if (@errors) {
        @errors = map { s/\t/    /g } @errors;
        print Dumper(\@errors);
    }
    print Dumper($channels);
}

Irssi::command_bind('getchan', \&go);
# in fe-common/core
#
#  chansetup_not_found = "Channel {channel $0} not found";
#  chansetup_added = "Channel {channel $0} saved";
#  chansetup_removed = "Channel {channel $0} removed";
#  chansetup_header = "%#Channel         Network    Password   Settings";
#  chansetup_line = "%#{channel $[15]0} %|$[10]1 $[10]2 $3";
#  chansetup_footer = "";
