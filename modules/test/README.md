## What is this?

A simple Irssi C module for testing and experimentation purposes.
It was originally derived from the
[irssi-lua project](https://github.com/ahf/irssi-lua)

I intend to build it into a simple template of a loadable module, featuring
the use of various common constructs, to allow others to quickly get
up to speed when developing modules.

Note that modules are significantly more effort (and less portable, without
a huge amount of effort), so Perl scripts are to be preferred in call cases
where possible.

## Usage

* Edit the Makefile as per the comments at the top.
* `make && make install`
* Start up a spare Irssi client (no point segfaulting your main one)
* `/load test`
* Party in the streets.

## Contributing

Contributions to this project are welcome (i.e.: to demonstrate more useful
things that a module can do)

 * Patches can be submitted via e-mail, or preferably via forking
   and sending a pull-request using GitHub.  The repository for this
   code is `git://github.com/shabble/irssi-scripts.git` and the
   corresponding web-page is
   [irssi-scripts/modules](https://github.com/shabble/irssi-scripts/modules).
   
   Details of pull-requests can be found at
   [GitHub](http://help.github.com/pull-requests/)
   
 . Please poke me on Freenode IRC (`shabble` on `#irssi`) before
   spending too much time on the code. Use the `git format-patch`-tool when
   emailing patches.

## Authors

 * Alexander Færøy <ahf@irssi.org>
     Original Author of irssi-lua, who did all the hard work figuring
     out the module interface stuff.  Also an Irssi project committer, I
     believe, so that probably counts as cheating.

 * Tom Feist [shabble+irssi@metavore.org](mailto://shabble+irssi@metavore.org)
     Chief plunderer of the modular goodness.
 
