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
use File::Basename;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'MIT',
              updated     => '$DATE'
             );

my $NAME  = $IRSSI{name};
my $DEBUG = 0;

sub DEBUG () { $DEBUG }

sub _debug_print {
    my ($msg) = @_;
    Irssi::active_window()->print($msg);
}

sub sig_setup_changed {
    $DEBUG = Irssi::settings_get_bool($NAME . '_debug');
    _debug_print($NAME . ': debug enabled') if $DEBUG;
}

sub init {
    Irssi::theme_register
        ([
          verbatim      => '[$*]',
          script_loaded => 'Loaded script {hilight $0} v$1',
         ]);
    Irssi::settings_add_bool($NAME, $NAME . '_debug', 0);
    Irssi::signal_add('setup changed', \&sig_setup_changed);

    sig_setup_changed();

    Irssi::printformat(Irssi::MSGLEVEL_CLIENTCRAP,
                       'script_loaded', $NAME, $VERSION);
}

init();




Irssi::print("Package name:" . __PACKAGE__ . " file: " . __FILE__);
Irssi::command_bind('bacon', sub { die "DIED!" });

sub package_to_irssi_name {
    my ($package) = @_;
    $package = __PACKAGE__ if not defined $package;
    $package =~ s/Irssi::Script:://o; # compiled since it's static.

    return $package;
}

sub file_to_irssi_name {
    my ($filename) = @_;
    $filename = _get_script_filename() if not defined $filename;
    $filename =~ s/\.[^\.]+?$//;     # remove file extension.
    $filename =~ s/[^[:alnum:]]/_/g; # replace non-alpha-numerics with underscore.

    return $filename; # NB: Doesn't include directory.
}

sub file_to_package_name {
    return irssi_to_package_name(file_to_irssi_name(@_));
}

sub irssi_to_package_name {
    return 'Irssi::Script::' . $_[0];
}

sub irssi_to_file_name {
    # requires extracting output of /script list.
    # remember to save/restore the format script_list_line to avoid truncation
    # in some themes
    my $saved_list_format =
      Irssi::current_theme()->get_format('fe-common/perl', 'script_list_line');
}

sub _get_script_filename {
    my $full_path = __FILE__;
    my ($name, $path, $suffix) = fileparse($full_path);

    return $name;
}


sub test {
    my $filename = _get_script_filename();
    print "Filename: $filename";
    my $irssiname = file_to_irssi_name($filename);
    print "Irssi Name: $irssiname";

    my $packagename = irssi_to_package_name($irssiname);
    print "Package Name: $packagename";

    my $irssi2 = package_to_irssi_name($packagename);
    print "Back to Irssi Name: $irssi2";

}

test();
