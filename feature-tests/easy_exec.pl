use strict;
use warnings;

# export everything.
use Irssi; #(@Irssi::EXPORT_OK);
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'easy_exec',
              description => 'drop-in replacement for /script exec which imports'
               . ' all of the Irssi:: namespace for easier testing',
              license     => 'Public Domain',
             );

#Irssi::signal_add_first 'command script exec', \&better_exec;
Irssi::command_bind('script exec', \&better_exec);

sub better_exec {
    my ($args, $serv, $witem) = @_;
    # todo: handle permanent arg?
    my $perm = 0;
    print "Args: $args";
    if ($args =~ s/^\s*-permanent\s*(.*)$/$1/) {
        $perm = 1;
    }
    print "Args now: $args";

#    eval $args;
    my $str = "//script exec " .
     ($perm ? '-permanent' : '')
     . 'use Irssi (@Irssi::EXPORT_OK); ' . $args;
     print "Running: $str";

#    Irssi::command($str);
    Irssi::signal_continue($str, @_[1..$#_]);
}

sub Dump {
    print Dumper(\@_);
}

sub test() {
    print "This is a test";
}
