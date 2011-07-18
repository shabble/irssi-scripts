use strict;
use warnings;


use Irssi;
use Data::Dumper;

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
    my $ret = '';
    {
        # deeeeeeep black magic.
        local *CORE::GLOBAL::caller = sub { $module };
        $win->printformat($level, $format, @args);

        $ret = Irssi::current_theme()->get_format($module, $format);
    }
    return $ret;
}

init();

sub init {
    my $win = Irssi::active_win();
    my $moo = actually_printformat($win, Irssi::MSGLEVEL_CLIENTCRAP, 'fe-common/irc',
                                   "kill_server", "foo", "bar", "horse", "cake");

    print Dumper($moo);

}
