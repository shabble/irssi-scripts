use strict;
use Irssi;
use Irssi::TextUI; # for sbar_items_redraw

use vars qw($VERSION %IRSSI);
$VERSION = "1.0.1";
%IRSSI = (
	authors         => "shabble",
	contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
	name            => "",
	description     => "",
	license         => "Public Domain",
	changed         => ""
);


Irssi::signal_add_last 'gui key pressed' => \&got_key;

my $buf = '';

sub got_key {
    my ($key) = @_;
    $buf .= " $key";
    my $res = decode_keypress($key);
    if (defined $res) {
        print "codes: $buf";
        print "Keypress: $res";
        $buf = '';
    }
}

# 1 means we've seen an esc, 2 means we've
# seen an esc,[. 0 is normal.

my $decoder_state = 0;

sub decode_keypress {
    my ($code) = @_;

    if ($decoder_state == 1) {

        # seen esc/meta.
        if ($code == ord('[')) {
            $decoder_state = 2;
            return undef;
        } else {
            $decoder_state = 0;
            return 'meta-' . chr($code);
        }

    } elsif ($decoder_state == 2) {

        if ($code == ord('A')) {
            $decoder_state = 0;
            return 'up-arrow';
        } elsif ($code == ord('B')) {
            $decoder_state = 0;
            return 'dn-arrow'
        } elsif ($code == ord('C')) {
            $decoder_state = 0;
            return 'right-arrow'
        } elsif ($code == ord('D')) {
            $decoder_state = 0;
            return 'left-arrow'
        }

        $decoder_state = 0;
        return undef;

    } else {

        if ($code < 27) {

            if ($code == 9) {
                return 'tab';
            }

            return 'ctrl-' . chr($code + ord('a') -1);
        }

        if ($code > 32 && $code < 127) {
            return chr($code);
        }

        if ($code == 32) {
            return 'space';
        }

        if ($code == 127) {
            return 'backspace';
        }

        if ($code == 27) {
            $decoder_state = 1;
            return undef;
        }

        return 'unknown ' . $code;
    }
}


# # TODO: needs some fixing up?
# sub _key {
#     my ($key_str, $flags) = @_;
#     my $key_num;

#     if ($key_str eq 'DEL' or $key_str eq 'BS') {
#         $key_num = 127;
#     } else {
#         die "Key must be single char" unless length($key_str) == 1;
#         $key_num = ord($key_str);
#         if ($flags & CTRL_KEY) {
#             $key_num = 0 if ($key_num == 32);
            
#         }
#     }
#     return $key_num;
# }
