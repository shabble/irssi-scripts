=pod

=head1 NAME

longify-urls.pl

=head1 DESCRIPTION

Checks channel messages for 'shortened' links, and expands them to their
final target address.

=head1 INSTALLATION

=over

=item * Download the modules from L<http://mauke.dyndns.org/stuff/irssi/lib/IrssiX/>
and place them in a directory known to Perl (One of the default system locations
for perl modules, or somewhere that is listed in the C<$PERL5LIB> environment variable).
They should be placed in a subdirectory named C<IrssiX/> in whichever module directory
you choose.

=item * Copy the F<longify-urls.list> file into your F<~/.irssi/> directory.

=item * Copy this script into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.

=back

=head1 USAGE

Load it.

B<Note:> The lookup to check if a link is shortened runs in the background, so it
won't affect the running of Irssi, but the message containing the link is queued
until either a response comes back, or the timeout (~2 seconds) is hit.

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

=over

=item * Not tested with simultaneous lookups

=item * User-configurable timeout

=item * deal with utf-8 (that stupid arrow site).

=back

=cut

use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

use IrssiX::Async qw(fork_off);
use LWP::UserAgent;
use URI;
use File::Spec;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'longify-urls',
              description => 'checks to see if links mentioned in public'
                     . 'channels are shortened, and, if so, expands them',
              license     => 'MIT',
              updated     => '8/7/2011'
             );

my $pending_msg_params = {};
my $lookup_in_progress;
my $flushing_message;
my $domains;


sub sig_public_message {
    _handle_messages(@_);
}

sub sig_private_message {
    _handle_messages(@_);
}

sub _handle_messages {

    my $msg = $_[1];

    if ($flushing_message) { # don't interrupt it a second time.
        delete $pending_msg_params->{$flushing_message};
        $flushing_message = '';
        return;
    }

    my $url = match_uri($msg);

    return unless $url;

    my $uri_obj = URI->new($url);

    # check we've got a valid url
    return unless ref($uri_obj);
    return unless $uri_obj->can('host');

    # match against the whitelist.
    return unless exists $domains->{$uri_obj->host};

    $pending_msg_params->{$url} = [@_];
    $lookup_in_progress = 1;
    expand_url($url);

    Irssi::signal_stop;
}

sub expand_url {
    my ($url) = @_;
    fork_off $url, \&expand_url_request, \&expand_url_callback;
}

sub expand_url_request {
    my $url = <STDIN>;
    chomp $url;

    my $user_agent = LWP::UserAgent->new;
    $user_agent->agent("irssi-longify-urls/0.1 ");
    $user_agent->timeout(2); # TODO: make this a setting.
    $user_agent->max_size(0);
    my $request = HTTP::Request->new(GET => $url);
    my $result = $user_agent->request($request);

    print "$url\n";

    if ($result->is_error) {
        print "ERROR: " . $result->as_string . "\n";
        return;
    }

    my @redirects = $result->redirects;
    if (@redirects) {
        print $redirects[-1]->header('Location') . "\n";
    }
}

sub expand_url_callback {
    my ($result) = @_;

    chomp $result;
    my ($orig_url, $long_url) = split /\n/, $result;
    $long_url = '' unless $long_url;
    $long_url =~ s/\s*(\S*)\s*/$1/;


    my $pending_message_data = $pending_msg_params->{$orig_url};
    my @new_signal = @$pending_message_data;

    #Irssi::print("Result: orignal: $orig_url, new: $long_url");

    if ($long_url && $long_url !~ /^ERROR/ && $long_url ne $orig_url) {
        $new_signal[1] =~ s/\Q$orig_url\E/$long_url [was: $orig_url]/;
        #print "Printing with: " . Dumper(@new_signal[1..$#new_signal]);
    } elsif ($long_url && $long_url =~ /^ERROR/) {
        $new_signal[1] =~ s/\Q$orig_url\E/$long_url while expanding "$orig_url"/;
    }

    $flushing_message = $orig_url;
    Irssi::signal_emit 'message public', @new_signal;

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
        $uri = 'http://' . $uri if $uri !~ m(http://);
        return $uri;
    } else {
        # no match
        return undef;
    }
}

sub cmd_reload {
    my $filename = shift 
      || File::Spec->catfile(Irssi::get_irssi_dir, 'longify-urls.list');
    $domains = {};
    open my $fh, '<', $filename
      or die "Couldn't open file containing shorteners list $filename: $!";
    while (<$fh>) {
        chomp;
        $domains->{$_} = 1;
    }
    close $fh;
    Irssi::active_win->print('%_Longify:%_ List of domains has been reloaded.');
}

sub init {
    Irssi::signal_add_first 'message public',  \&sig_public_message;
    Irssi::signal_add_first 'message private', \&sig_private_message;
    Irssi::signal_add       'setup changed',   \&sig_setup_changed;
    Irssi::command_bind     'longify-reload',  \&cmd_reload;

    cmd_reload();
}

sub sig_setup_changed {
    # TODO: settings updating stuff goes here.
}

init();
