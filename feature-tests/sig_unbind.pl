use strict;
use warnings;


use Irssi (@Irssi::EXPORT_OK);
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;


our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => '',
              description => '',
              license     => 'Public Domain',
             );

command_bind("dosig_r",
             sub {
                 my $ref = \&cmd_oink;
                 _print("binding oink to $ref");
                 signal_add("command oink", $ref);
             });

command_bind("undosig_r",
             sub {
                 my $ref = \&cmd_oink;

                 _print("unbinding oink from $ref");

                 signal_remove("command oink", $ref);
                 });

command_bind("dosig_s",
             sub {
                 signal_add("command oink", 'cmd_oink');
             });

command_bind("undosig_s",
             sub {
                 signal_remove("command oink", 'cmd_oink');
                 });

sub cmd_oink {
    Irssi::active_win()->print("Oink:");
}

sub _print  {
    Irssi::active_win()->print($_[0]);
}

command("dosig_r");
command("oink");
command("undosig_r");
command("oink");
