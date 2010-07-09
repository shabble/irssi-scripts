use strict;
use warnings;

use lib '/opt/stow/lib/perl5';

use Irssi;
use Irssi::TextUI;
use Data::Dumper;
use vars qw/$BACON/;

my $bob = "hello bob";
our $HATS = "i like hats";

#Irssi::print(Dumper(\@INC));
Irssi::print("Package is " . __PACKAGE__);

#Irssi::gui_input_set("Hello");
# my $foo = Irssi::gui_input_get_pos();
# Irssi::print("foo is: $foo");
my $foo = Irssi::yay_horsies("What!");
Irssi::print($foo);

Irssi::command_bind('prompt', 'do_prompt');
Irssi::command_bind('emit', 'do_emit');
Irssi::command_bind('myprint', 'do_print');
Irssi::command_bind('myprint2', 'do_print2');

#Irssi::signal_add_last("gui print text", "do_gui_print");
Irssi::signal_add("print text", "do_print_intercept");

sub do_print_intercept {
    my ($dest, $text, $stripped) = @_;
    #if ($text =~ m/baconbacon/) {
    $text = $text . "lvl: " . $dest->{level};

        $dest->{level} |= MSGLEVEL_NO_ACT;
        $dest->{level} &= ~MSGLEVEL_HILIGHT;

#}
    Irssi::signal_continue($dest, $text, $stripped);
}

sub do_gui_print {
    Irssi::print(Dumper(\@_));
    Irssi::signal_stop();
    Irssi::signal_remove('gui print text', 'do_gui_print');
}

sub do_prompt {
    my ($msg) = @_;
    Irssi::gui_input_set_prompt($msg);
}

sub do_emit {
    my ($key) = @_;
    Irssi::print("emitting signal: keypress for $key");
    #Irssi::signal_emit("gui key pressed", $key);
    Irssi::signal_emit("gui dialog", "error", "What is going on?");
}

sub do_print {
    my ($msg) = @_;
    my $window = Irssi::active_win;
    my $len = length $msg;

    $window->print(Dumper($window->view));
    # $window->print("message is $msg which is $len long");
    # my $str = join( ', ', map { ord } split( '', $msg));
    # $window->print($str);

}


sub do_print2 {
    my ($msg) = @_;
    Irssi::print("message2 is $msg", MSGLEVEL_PUBLIC + MSGLEVEL_NOHILIGHT);
}
