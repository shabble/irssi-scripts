=pod

=head1 NAME

molly_guard.pl - confirm that you really mean to do things that could have
potentially dangerous (or embarassing) effects.

=head1 DESCRIPTION

Named after the plastic cover installed over some Big Red Switches With
Major Consequences. See L<http://catb.org/jargon/html/M/molly-guard.html>.
Attempts to stop you shooting yourself in the foot, face, or other body-part
during normal day-to-day use of Irssi.

By default, it protects you from the following potential mishaps:

=over 4

=item * C</foreach <channel|query|window|server> [not a command]>

C</foreach THING ARGS> will pass I<ARGS> to every I<THING> specified. Usually,
this is used to, for example, run a command in every window. A common mistake is
not including a command char such as C</> in your I<ARGS>, in which case I<ARGS>
is sent as text to every window or channel it can be. This is almost always bad.

=item * I<Nothing else, yet>

=back

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

=item * Commands to protect:

=over 4

=item * C</foreach [noncommand]>

=item * C</server> (in cases where C</connect> is probably meant)

=item * C</upgrade> (way too easy to tab-complete instead of /UPTIME)

=item * C</exit>, C</quit> (obvious)

=item * ...

=back

=back

=cut

use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.2';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'molly_guard',
              description => 'A script to protect users from accidentally invoking'
              . ' commands which may perform undesired actions. See '
              . 'http://catb.org/jargon/html/M/molly-guard.html',
              license     => 'MIT',
              updated     => '$DATE'
             );

my $CMD = '_foreach_safe';
my $DEBUG = 0;
my $cmdchars;
my $match_cmdchars;
my $cmd_confirm_list;
my $txt_confirm_list;

sub init {
    Irssi::settings_add_bool('molly_guard',
                             'molly_guard_debug',
                             0);
    Irssi::settings_add_str ('molly_guard',
                             'molly_guard_confirm_commands',
                             '');
    Irssi::settings_add_str ('molly_guard',
                             'molly_guard_confirm_text',
                             '');

    Irssi::theme_register([
                           'script_loaded',
                           '%R>>%n %_Scriptinfo:%_ Loaded {hilight $0} v$1 by $2.'
                          ]);
    Irssi::signal_add      ('setup changed', \&sig_setup_changed);
    Irssi::signal_add_first('complete word', \&sig_complete_word);

    # override the default foreach with an alias pointing to our command.
    Irssi::command("^alias foreach $CMD");

    sig_setup_changed();

    Irssi::command_bind($CMD, \&cmd_foreach_safe_dispatch);
    for my $target (qw/channel query server window/) {
        my $coderef = __PACKAGE__->can("cmd${CMD}_$target");
        die "Cannot aquire coderef for $target" unless ref($coderef) eq 'CODE';
        Irssi::command_bind("$CMD $target", $coderef);
    }
    Irssi::printformat(MSGLEVEL_CLIENTCRAP, 
                       'script_loaded', $IRSSI{name}, $VERSION, $IRSSI{authors});
}

sub sig_setup_changed {
    $DEBUG = Irssi::settings_get_bool('molly_guard_debug');
    _debug("settings changed");
    $cmdchars = Irssi::settings_get_str('cmdchars');
    my $tmp = join('|', map { quotemeta } split('', $cmdchars));
    _debug("tmp: $tmp");
    $match_cmdchars = qr/^($tmp)(\S*)/;
    _debug("Match cmdchars set to: %s", $match_cmdchars);

    $cmd_confirm_check = { map { $_ => 1 } split /\s+/,
      Irssi::settings_get_str('molly_guard_confirm_commands') };

    $txt_confirm_check = { map { $_ => 1 } split /\s+/,
      Irssi::settings_get_str('molly_guard_confirm_text') };

}

sub sig_complete_word {
    my ($strings, $window, $word, $line_start, $want_space) = @_;
    _debug("Tab complete called with: " . join(", ", @_));
    return unless
      $line_start =~ m/foreach (channel|query|server|window)/;

    my $target = $1;
    _debug("target: $1, word: $word");

    if ($word =~ qr/$match_cmdchars/i) {
        my ($cmdchar, $cmd_prefix) = ($1, $2);
        _debug("completion char: $cmdchar,  Prefix: $cmd_prefix");

        my @commands
          = grep { m/^\Q${cmdchar}${cmd_prefix}/ }
            map  { $cmdchar . $_->{cmd}          } Irssi::commands;

        _debug("Matching Commands: " . join(", ", @commands));
        @$strings = @commands;
        $$want_space = 1;

        Irssi::signal_stop();
    } else {
        return;
    }
}

sub cmd_foreach_safe_dispatch {
    my ($input, $server, $witem) = @_;

    if ($witem) {
        $witem->print("W: foreach_safe called with $input");
    } else {
        print("foreach_safe called with $input");
    }
    #$data =~ s/\s+$//g; # strip trailing whitespace.
    Irssi::command_runsub($CMD, $input, $server, $witem);
}

sub require_confirmation {
    my ($target, $input) = @_;
    if (_is_command($input)) {
        return exists $cmd_confirm_check->{$target};
    } else {
        return exists $txt_confirm_check->{$target};
    }
}


sub cmd_foreach_safe_channel {
    my ($args, $server, $witem) = @_;

}

sub cmd_foreach_safe_query   {
    my ($args, $server, $witem) = @_;

}
sub cmd_foreach_safe_server  {
    my ($args, $server, $witem) = @_;

}
sub cmd_foreach_safe_window  {
    my ($args, $server, $witem) = @_;

}

sub _is_command {
    my ($string) = @_;
    return m/$match_cmdchars/;
}

sub _debug {
    return unless $DEBUG;
    my ($msg, @args) = @_;

    my $str = sprintf("DBG: $msg", @args);
    print($str);
}

init();
