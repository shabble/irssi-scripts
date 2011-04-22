use strict;
use warnings;

# export everything.
use Irssi;
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

# TODO: make this more tab-complete friendly
init();

sub init {
    Irssi::command('/alias se script exec use Data::Dumper\;'
                   .' use Irssi (@Irssi::EXPORT_OK)\; $0-');
    Irssi::command('/alias sep script exec -permanent '
                   . 'use Data::Dumper\; use Irssi (@Irssi::EXPORT_OK)\; $0-');

    Irssi::signal_add_last ('complete word', 'sig_complete_word');
}

sub sig_complete_word {
    my ($strings, $window, $word, $linestart, $want_space) = @_;
    # only provide these completions if the input line is otherwise empty.
    my $cmdchars = Irssi::settings_get_str('cmdchars');
    my $quoted = quotemeta($cmdchars);
    #print "Linestart: $linestart";
    return unless ($linestart =~ /^${quoted}(?:se|sep)/);
    
    my $clean_word = $word;
    $clean_word =~ s/^"//g;
    $clean_word =~ s/"$//g;
    $clean_word =~ s/->$//g;



    my @expansions = @Irssi::EXPORT_OK;
    push @$strings,  grep { $_ =~ m/^\Q$clean_word\E/ } @expansions;
    print "Sebug: " . join(", ", @$strings);
    $$want_space = 0;


    Irssi::signal_stop() if (@$strings);
}
