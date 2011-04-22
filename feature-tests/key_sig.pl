use strict;
use warnings 'all';

use Irssi;
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

my $bacon = 10;

Irssi::signal_register({'key created' => [qw/Irssi::UI::Key/ ] });

Irssi::signal_add('key created', \&sig_key_created);
Irssi::signal_register({'key command' => [qw/string/]});
Irssi::signal_add_first('key command' => \&sig_key_cmd);

Irssi::signal_register({'key nothing' => [qw/string/]});
Irssi::signal_add_first('key nothing' => \&sig_key_cmd);

Irssi::signal_register({'keyboard created' => [qw/Irssi::UI::Keyboard/]});
Irssi::signal_add_first('keyboard created' => \&sig_keyboard);

sub sig_keyboard {
    my ($data) = @_;
    print "keyboard: " . Dumper($data);
}

sub sig_key_cmd {
    my ($data) = @_;
    print "key cmd: " . Dumper($data);

}

sub sig_key_created {
    my @args = @_;

    print "Key Created, Args: " . Dumper(\@args);
}

Irssi::command("bind meta-q /echo moo");
