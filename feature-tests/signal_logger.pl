use strict;
use warnings;


use Irssi;
use Irssi::Irc;
use Irssi::TextUI;
use Time::HiRes qw/time/;

use Data::Dumper;


our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'Public Domain',
             );

my $enabled = 0;
my $depth = 0;
my $handlers = { };
my @log = ();
my @signals =
(
'send text',
'send command',
#'print text',
#'gui print text',
'beep',
#'complete word',
#'gui key pressed',
'window changed',
 "server add fill",
 "server connect copy",
 "server connect failed",
 "server connected",
 "server connecting",
 "server disconnected",
 "server event",
 "server incoming",
 "server lag disconnect",
 "server lag",
 "server looking",
 "server nick changed",
 "server quit",
 "server reconnect not found",
 "server reconnect remove",
 "server reconnect save status",
 "server sendmsg",
 "server setup fill chatnet",
 "server setup fill connect",
 "server setup fill reconn",
 "server setup read",
 "server setup saved",
 "default event",
#'gui print text finished',

);

init();

sub init {

    @log = ();
    $handlers = {};

    Irssi::command_bind('siglog_on',    \&cmd_register_all_signals);
    Irssi::command_bind('siglog_off',   \&cmd_unregister_all_signals);
    Irssi::command_bind('siglog_dump',  \&cmd_log_dump);
    Irssi::command_bind('siglog_stats', \&cmd_log_stats);
}

sub cmd_register_all_signals {


    Irssi::active_win->print("Starting to log all signals");
    $enabled = 1;

    foreach my $sig_name (@signals) {

        my $first_func = build_init_func($sig_name);
        my $last_func  = build_end_func($sig_name);

        $handlers->{$sig_name} = [ $first_func, $last_func ];

        Irssi::signal_add_first($sig_name, $first_func);
        Irssi::signal_add_last($sig_name,  $last_func);
    }
}

sub cmd_unregister_all_signals {

    foreach my $sig_name (@signals) {

        my ($first_func, $last_func) = @{ $handlers->{$sig_name} };

        Irssi::signal_remove($sig_name, $first_func);
        Irssi::signal_remove($sig_name,  $last_func);
    }
    $enabled = 0;
    Irssi::active_win->print("Signal logging disabled");

}

sub cmd_log_dump {

    my $win = Irssi::active_win();
    if ($enabled) {
        cmd_unregister_all_signals();
        $win->print("Disabled logging");
    }
    foreach my $lref (@log) {
        my ($line, $indent) = @$lref;
        my $xx = " " x $indent;
        $win->print($xx . $line);
    }
}

sub cmd_log_stats {

    my $win = Irssi::active_win();
    if ($enabled) {
        cmd_unregister_all_signals();
        $win->print("Disabled logging");
    }
}

sub build_init_func {
    my ($sig_name) = @_;

    return sub {
        my @args = @_;
        my $args_str = '';
        my $n = 0;

        foreach my $arg (@args) {
            $args_str .= "[$n] ";

            if (not defined $arg) {
                $args_str .= "undef, ";
                next;
            }

            if (ref $arg) {
                $args_str .= ref($arg) . ", "
            } else {
                $arg =~ s/^(.{20})/$1/;
                $args_str .= "$arg, ";
            }
            $n++;
        }
        my $msg = sprintf("%f: %s - First %s", time(), $sig_name, $args_str);
        push @log, [$msg, $depth];
        $depth++;
    }
}

sub build_end_func {
    my ($sig_name) = @_;

    return sub {
        my $msg = sprintf("%f: %s - End", time(), $sig_name);
        push @log, [$msg, $depth];
        $depth--;
    }
}

