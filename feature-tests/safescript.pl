use strict;
use Irssi;
use Irssi::TextUI; # for sbar_items_redraw
use Safe;

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

my $safe;
my $objs = {};
init();

sub _input {
    return int rand 1000;
}

sub load {
    my $file = shift;
    my $obj;
    if (-f $file) {
        $obj =  $safe->rdo($file);
    }
    $objs->{ref $obj} = $obj;
    #     print "Loading from file: $file";
    #     $funcs = do $file;
    # }
    # if (not defined $funcs) {
    #     if ($@) {
    #         print "failed to parse $file: $@";

    #     } elsif ($!) {
    #         print "failed to read $file: $!";

    #     }
    #     return;
    # }
    # my $ref = ref $funcs;
    # if ($ref ne 'HASH') {
    #     print "$file didn't return a hashref: ", defined $ref ? $ref : 'undef';
    #     return;
    # }

    # foreach my $name (keys %$funcs) {
    #     my $func = $funcs->{$name};
    #     if (exists $functions->{$name}) {
    #         print "Redefining function $name";
    #     } else {
    #         print "adding function: $name";
    #     }
    #     $functions->{$name} = $func;
    # }

    # print "Loaded " . scalar(keys(%$funcs)) . " functions";
}

sub init {
    Irssi::command_bind('subload', \&cmd_subload);
    Irssi::command_bind('sublist', \&cmd_sublist);
    Irssi::command_bind('subcall', \&cmd_subcall);

    $safe = new Safe;
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
