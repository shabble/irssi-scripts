use strict;
use warnings;


use Irssi;


our $VERSION = '0.1';
our %IRSSI = (
              authors     => '',
              contact     => '',
              name        => '',
              description => '',
              license     => 'Public Domain',
             );

sub actually_printformat {
    my ($win, $level, $module, $format, @args) = @_;
    {
        # deeeeeeep black magic.
        local *CORE::GLOBAL::caller = sub { $module };
        $win->printformat($level, $format, @args);
    }

}

init();

sub init {
    my $win = Irssi::active_win();
    actually_printformat($win, Irssi::MSGLEVEL_CLIENTCRAP, 'fe-common/irc',
                               "kill_server", "foo", "bar", "horse", "cake");

}
