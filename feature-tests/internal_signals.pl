# not a complete script, just a useful snippet
Irssi::signal_register({'complete command set'
                        => ["glistptr_char*", "Irssi::UI::Window",
                                "string", "string", "intptr"]});

my @res = ();
my $num;
Irssi::signal_emit('complete command set', \@res, Irssi::active_win(),
                   '', '', \$num);

print "results: @res";

# will return all the possible completions for the /set command.  you can filter
# it by changing the 2 empty strings (word-fragment, and line context)
