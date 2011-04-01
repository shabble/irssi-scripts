###
#
# Parts of the script pertaining to uberprompt borrowed from
# shabble (shabble!#irssi/@Freenode), thanks for letting me steal from you :P
#
###

use strict;
use warnings;

our $VERSION = "0.2";
our %IRSSI = (
              authors     => "Jari Matilainen",
              contact     => 'vague!#irssi@freenode',
              name        => "notifyquit",
              description => "Notify if user has left the channel",
              license     => "Public Domain",
              url         => "http://vague.se"
             );

my $active = 0;
my $permit_pending = 0;
my $pending_input = {};


sub script_is_loaded {
    return exists($Irssi::Script::{$_[0] . '::'});
}

if (script_is_loaded('uberprompt')) {
    app_init();
} else {
    print "This script requires 'uberprompt.pl' in order to work. "
      . "Attempting to load it now...";

    Irssi::signal_add('script error', 'load_uberprompt_failed');
    Irssi::command("script load uberprompt.pl");

    unless(script_is_loaded('uberprompt')) {
        load_uberprompt_failed("File does not exist");
    }
    app_init();
}

sub load_uberprompt_failed {
    Irssi::signal_remove('script error', 'load_prompt_failed');

    print "Script could not be loaded. Script cannot continue. "
        . "Check you have uberprompt.pl installed in your scripts directory and "
        .  "try again.  Otherwise, it can be fetched from: ";
    print "https://github.com/shabble/irssi-scripts/raw/master/"
        . "prompt_info/uberprompt.pl";

    die "Script Load Failed: " . join(" ", @_);
}

sub extract_nick {
    my ($str) = @_;

    my $completion_char
      = quotemeta(Irssi::settings_get_str("completion_char"));

    # from BNF grammar at http://www.irchelp.org/irchelp/rfc/chapter2.html
    # special := '-' | '[' | ']' | '\' | '`' | '^' | '{' | '}'

    my $pattern = qr/^( [[:alpha:]]         # starts with a letter
                         (?: [[:alpha:]]         # then letter
                         | \d                # or number
                         | [\[\]\\`^\{\}-])  # or special char
                         *? )                # any number of times
                     $completion_char/x;     # followed by completion char.

    if ($str =~ m/$pattern/) {
        return $1;
    } else {
        return undef;
    }

}

sub sig_send_text {
    my ($data, $server, $witem) = @_;

    return unless($witem);

    return unless $witem->{type} eq 'CHANNEL';

    # shouldn't need escaping, but it doesn't hurt to be paranoid.
    my $target_nick = extract_nick($data);

    if ($target_nick) {
        if (not $witem->nick_find($target_nick)) {

            return if $target_nick =~ m/^https?/i;

              if ($permit_pending) {

                  $pending_input = {};
                  $permit_pending = 0;
                  Irssi::signal_continue(@_);

              } else {
                  my $text
                    = "$target_nick isn't in this channel, send anyway? [Y/n]";
                  $pending_input
                    = {
                       text     => $data,
                       server   => $server,
                       win_item => $witem,
                      };

                  Irssi::signal_stop;
                  require_confirmation($text)
              }
        }
    }
}

sub sig_gui_keypress {
    my ($key) = @_;

    return if not $active;

    my $char = chr($key);

    # Enter, y, or Y.
    if ($char =~ m/^y?$/i) {
        $permit_pending = 1;
        Irssi::signal_stop;
        Irssi::signal_emit('send text',
                           $pending_input->{text},
                           $pending_input->{server},
                           $pending_input->{win_item});
        $active = 0;
        set_prompt('');

    } elsif ($char =~ m/^n?$/i or $key == 3 or $key == 7) {
        # we support n, N, Ctrl-C, and Ctrl-G for no.

        Irssi::signal_stop;
        set_prompt('');

        $permit_pending = 0;
        $active         = 0;
        $pending_input  = {};

    } else {
        Irssi::signal_stop;
        return;
    }
}

sub app_init {
    Irssi::signal_add_first("send text"       => \&sig_send_text);
    Irssi::signal_add_first('gui key pressed' => \&sig_gui_keypress);
}

sub require_confirmation {
    $active = 1;
    set_prompt(shift);
}

sub set_prompt {
    my ($msg) = @_;
    $msg = ': ' . $msg if length $msg;
    Irssi::signal_emit('change prompt', $msg, 'UP_INNER');
}
