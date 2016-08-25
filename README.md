# Shabble's Irssi Scripts

This repository contains a collection of scripts and things I have written or
adapted from others to improve my (and maybe your!) Irssi using experience.

**Important Note:** Some of these scripts might be outdated, and newer & better versions available
elsewhere on the interwebs. I suggest checking [https://scripts.irssi.org/](https://scripts.irssi.org/) first
to ensure they haven't already superceded some of these (pretty old) scripts.

Please `/msg shabble` on Freenode if there's something here that you maintain that you'd prefer I didn't keep
hosted here.

## What's In Here

I never thought I'd end up writing so many scripts, so rather than give them
each their own repository as might be sensible, they're all stuffed in here.

The following is a brief list of the interesting scripts, and why you might want
to use them.

* [`auto-server/`](irssi-scripts/tree/master/auto-server) -- provides a `/join+`
  command which allows you to join channels on servers to which you're not
  currently connected, as long as you've got everything set up correctly in your
  `/channels` and `/networks` config.
  

* [`history-search/`](irssi-scripts/tree/master/history-search) -- an improved
  version of [@coekie](/coekie/irssi-scripts/blob/master/history_search.pl)'s
  original history_search, it behaves a lot more like the standard Readline
  incremental search over your recent command history.
                    
* [`ido-mode/`](irssi-scripts/tree/master/ido-mode) -- A window switching mode
  best described as "The bastard lovechild of Emacs
  [ido-mode](http://www.emacswiki.org/emacs/InteractivelyDoThings) and
  [window_switcher.pl](http://scripts.irssi.org/html/window_switcher.pl.html)".
  It supports flexible matching of channel names, filtering by active windows,
  servers, and more. See the script comments for details.
  
* [`feature-tests/`](irssi-scripts/tree/master/feature-tests) has a bunch of
  different little scripts written to test certain aspects of Irssi behaviour.
  None of them are likely to be particularly useful unless you're looking for
  simple examples of various things on which to build.  Some of the ones which
  might actually be useful are:

 * [`key_test.pl`](irssi-scripts/tree/master/feature-tests/key_test.pl) -
   decodes and prints keyboard inputs from the `gui key pressed` signal.  Useful
   for checking what keycode a particular combo generates.

 * [`template.pl`](irssi-scripts/tree/master/feature-tests/template.pl) - A
   basic outline of a script to use as a starting point for others.

 * [`pipes.pl`](irssi-scripts/tree/master/feature-tests/pipes.pl) A barebones
   template for a script which uses forking and pipes to handle async tasks in
   the background without hanging Irssi.
  
* [`modules/`](irssi-scripts/tree/master/modules) contains a few half-baked
  attempts at loadable modules for Irssi, none of which do very much at the
  moment.  They might be useful as templates for your own modules, however.
  
* [`no-key-modes/`](irssi-scripts/tree/master/no-key-modes) provides an
  additional expando `$M_nopass` which you can add to your theme to provide
  channel modes, but without showing the channel key.  This is probably less
  useful since someone pointed me at `/set chanmode_expando_strip` which has
  much the same effect.
  
* [`patches/`](irssi-scripts/tree/master/patches) contains a few patches for the
  irssi source, probably out of date by now, which do various things. The
  easiest way to figure out what is to read them, unless I get bored and
  document them sometime.
  
* [`prompt_info/`](irssi-scripts/tree/master/prompt_info) was the original "How
  can I put dynamic status crap into my prompt string" script.  This has since
  been superceded by the far nicer `uberprompt.pl` which also lives in that dir.
  Many of my other scripts require uberprompt as a way to provide part of their
  user interface.
  
* [`sb-position/`](irssi-scripts/tree/master/sb-position) gives you an
  additional status bar item which indicates approximately how far you are
  scrolled in a given window buffer, in terms of pages and percentage.  It is
  configurable as the comments in the script explain.
  
* [`scrolled-reminder/`](irssi-scripts/tree/master/scrolled-reminder) is a
  script that tries to prevent one of the more common accidental IRC screwups --
  replying to a conversation that happened hours ago because you didn't notice
  you were scrolled up in the history buffer.  If you try to send a message
  whilst scrolled, it'll warn you and check you really want to first.
 
* [`quit-notify/`](irssi-scripts/tree/master/quit-notify) is based on a script
  by vague@#irssi/Freenode.  It is most useful when you are ignoring
  joins/parts/quits from a channel, and hence don't realise when the person you
  are responding to has left.  If they have (or if you prefix your message with
  a nonexistent nick), the script will ask you to confirm that you want to send
  the message, much like `scrolled_reminder`.
  
* [`undo/`](irssi-scripts/tree/master/undo) contains 2 scripts, `undo.pl` and
  `kill-ring.pl`. See their header for further documentation.

  *Still undergoing heavy development, and not really ready for public usage.*

  
* [`testing/`](irssi-scripts/tree/master/testing) is a Perl framework external
  to Irssi (ie: not a script) that will ultimately allow you to write unit tests
  for your scripts, and run them in a real irssi instance, and check that they
  behave correctly.

  *Still undergoing heavy development, and not really ready for public usage.*
  
* [`throttled-autojoin/`](irssi-scripts/tree/master/throttled-autojoin) doesn't
  work. It's meant to allow people with huuuuuuge numbers of autojoin channels
  and servers to connect slowly, so as not to time themselves out when
  reconnecting. Mostly dead.
  
* [`tinyurl-tabcomplete/`](irssi-scripts/tree/master/tinyurl-tabcomplete) is a
  script which lets you hit tab following anything that looks like a URL to
  replace it with a tinyurl'd version.  Handy if you regularly paste Google-maps
  links or other massive horrible links.
  
* [`url_hilight/`](irssi-scripts/tree/master/url_hilight) I can't remember what
  this one does. Suggestions & ideas welcome.

* [`vim-mode/`](irssi-scripts/tree/master/vim-mode) The most exciting (and by
  far the largest) script here. Gives vim-addicted users a way to use most of
  their finger-memory in Irssi.  Still under active development, features and
  bug-requests welcome.  Also supported in
  [#irssi_vim on Freenode](irc://irc.freenode.org/#irssi_vim).
                     
## Documentation

If you are here looking for my Irssi scripting documentation, please note that
it has been moved to
[https://github.com/shabble/irssi-docs/wiki](https://github.com/shabble/irssi-docs/wiki)

## Other Things

Many of my scripts require
[uberprompt](https://github.com/shabble/irssi-scripts/blob/master/prompt_info/uberprompt.pl)
as a dependency.  Those that do will say so in the comments at the top of the
file, and will probably refuse to load without it.

## Reminders for myself

*Not for public consumption. This section contains text known to the State of
California to cause madness, rabies, or reproductive harm.*

### Todo Lists

I should really put these into the issue tracker instead. That can be a
reminder. I'll go create an issue for it Right Now!

#### Script ideas

* override `/set` to provide list manipulation options, something like `/set
{-append, -remove} $param $value`. Bit like a general purpose version of
[`hide.pl`](http://scripts.irssi.org/html/hide.pl.html)

* Finish work on [`foreach-guard`](irssi-scripts/tree/master/foreach-guard)

* Finish (Well, start) something in [`colour-popup`](irssi-scripts/tree/master/colour-popup)
 to make an actual popup

* Revisit some of the cracked-out ideas for colour/format overlays

* Go back and clean up [`irssi-vim`](irssi-scripts/tree/master/irssi-vim) like I promised to
  everyone ages and ages ago. Also do the features thing.
  
* Actually fix all the [issues](https://github.com/shabble/irssi-scripts/issues)
  people have dilligently reported.
  
#### Other things

* Go do something useful regarding the `IrssiX::` namespace and add some useful
general features.

 * Window and transient-split handling
 
 * Higher-level abstraction for key-interception
 
 * Overlays?
 
 * Format helper functions like the ones listed in the
 [Guide](https://github.com/shabble/irssi-docs/wiki/Guide).
   
* Refactor just about everything to use the above.

* Do something productive again on the 256colour fork/patches

* Ditto [@leonerd](/leonerd)'s
[fixterms](http://www.leonerd.org.uk/hacks/fixterms/) key binding support

* Try to get someone to look at my patches & bug reports.

#### Documentation Wiki

You know, [that](https://github.com/shabble/irssi-docs/wiki) one.

* Fix the stupid ToC generator internal anchor names problem.

* Add more examples, always more examples.

### Deployment Process

* Commit messages should be prefixed with something approximating the name of
  the script or directory to make it obvious what thing is being worked on.
  
* `./readme_generator.pl <dir> [<dirs]` to generate README files for each script
  that has POD in it. Use `--overwrite` from time to time to clean things out.
  
* `./changed_update.pl <script_name>` changes the %IRSSI{changed} timestamp to
  the current time, which is something I always forget to do.
  
* Think about bumping the internal version number if it's a big change.

* Commit!

   
