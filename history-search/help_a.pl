use strict;
use warnings;

use Irssi;

our $help = "this is help for a";

Irssi::command_bind('help', sub {
        if ($_[0] eq 'test_a') {
            Irssi::print($help, MSGLEVEL_CLIENTCRAP);
            Irssi::signal_stop();
            return;
        }
  }
);
