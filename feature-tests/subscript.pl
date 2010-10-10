use strict;
use Irssi;
use Irssi::TextUI; # for sbar_items_redraw

use vars qw($VERSION %IRSSI);

$VERSION = "0.1";

%IRSSI = (
	authors         => "shabble",
	contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
	name            => "",
	description     => "",
	license         => "Public Domain",
	changed         => ""
);

my $functions = {};

init();

sub load {
    my $file = shift;
    my $funcs;
    if (-f $file) {
        print "Loading from file: $file";
        $funcs = do $file;
    }

    return unless ref $funcs eq 'HASH';
    print "Got hashref from file";

    foreach my $name (keys %$funcs) {
        my $func = $funcs->{$name};
        $functions->{$name} = $func;
    }

    $functions = $funcs;
    print "Loaded " . scalar(keys(%$funcs)) . " functions";
}

sub init {
    Irssi::command_bind('subload', \&cmd_subload);
    Irssi::command_bind('sublist', \&cmd_sublist);
    Irssi::command_bind('subcall', \&cmd_subcall);
}

sub cmd_subload {
    my $args = shift;
    print "Going to load: $args";
    load($args);
}

sub cmd_sublist {
    foreach my $name (keys %$functions) {
        my $func = $functions->{$name};
        print "Function: $name => $func";
    }
}

sub cmd_subcall {
    my $args = shift;
    my ($cmd, $cmdargs);
    if ($args =~ m/^(\w+\b)(.*)$/) {
        $cmd = $1; $cmdargs = $2;
    } else {
        print "Couldn't parse $args";
        return;
    }
    my $fun = $functions->{$cmd};

    if (ref $fun eq 'CODE') {
        print "Calling $cmd with $cmdargs";
        $fun->($cmdargs);
    } else {
        print "$cmd is not a coderef. cannot run";
    }
}
