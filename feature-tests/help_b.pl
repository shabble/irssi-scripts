use strict;
use warnings;

use Irssi;

our $help = "this is help for b";

Irssi::command_bind('help', sub {
        if ($_[0] eq 'test_b') {
            Irssi::print($help, MSGLEVEL_CLIENTCRAP);
            Irssi::signal_stop();
            return;
        }
  }
);
