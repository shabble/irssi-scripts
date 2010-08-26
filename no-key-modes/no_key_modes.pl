
use strict;
use warnings;

use Irssi;
use Irssi::TextUI;
use Irssi::Irc;

Irssi::expando_create('M_nopass', \&expando_nopass_modes, {});

sub expando_nopass_modes {
    my ($server, $witem, $arg) = @_;
    return '' unless ref($witem) eq 'Irssi::Irc::Channel';
    my $modes_str = $witem->{mode};
    my $key_str = $witem->{key};

    if ($key_str) {
        $modes_str =~ s/\Q$key_str\E//; # remove the key
        $modes_str =~ s/\s*$//; # strip trailing space if we removed the key.

    }

    return $modes_str;
}
