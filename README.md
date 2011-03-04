# Shabble's Irssi Scripts

This repository contains a collection of scripts I have written or adapted from
others to improve my (and your!) irssi using experience.

## What's In Here

I never thought I'd end up writing so many scripts, so rather than give them
each their own repository as might be sensible, they're all stuffed in here.

The following is a brief list of the interesting scripts, and why you might want
to use them.

* `auto_server/` -- provides a `/join+` command which allows you to join
  channels on servers to which you're not currently connected, as long as you've
  got everything set up correctly in your `/channels` and `/networks` config.
  

* `history_search/` -- an improved version of coekie's original history_search, it
  behaves a lot more like the standard Readline incremental
  search over your recent command history.
                    
* `ido_mode/` -- A window switching mode best described as "The bastard lovechild
  of emacs ido-mode and window_switcher.pl".  It supports flexible matching of
  channel names, filtering by active windows, servers, and more. See the script
  comments for details.
  
* `feature_tests/` has a bunch of different little scripts written to test certain
  aspects of Irssi behaviour.  None of them are likely to be particularly useful
  unless you're looking for simple examples of various things on which to build.
  The exception is 'key_test.pl', which is good for figuring out what keycodes
  Irssi sees when you give it input.
  
  pipes.pl might also be interesting as a barebones template for a script which
  uses forking and pipes to handle async tasks in the background without hanging
  Irssi.
  
* `modules/` contains a few half-baked attempts at loadable modules for Irssi,
  none of which do very much at the moment.  They might be useful as templates
  for your own modules, however.
  
* `no_key_modes/` provides an additional expando `$M_nopass` which you can
  add to your theme to provide channel modes, but without showing the channel
  key.  This is probably less useful since someone pointed me at `/set
  chanmode_expando_strip` which has much the same effect.
  
* `patches/` contains a few patches for the irssi source, probably out of date
  by now, which do various things. The easiest way to figure out what is to read
  them, unless I get bored and document them sometime.
  
* `prompt_info/` was the original "How can I put dynamic status crap into my
  prompt string" script.  This has since been superceded by the far nicer
  `uberprompt.pl` which also lives in that dir.  Many of my other scripts
  require uberprompt as a way to provide part of their user interface.
  
* `sb_position/` gives you an additional status bar item which indicates
  approximately how far you are scrolled in a given window buffer, in terms
  of pages and percentage.  It is configurable as the comments in the script
  explain.
  
* `scrolled_reminder/` is a script that tries to prevent one of the more
  common accidental IRC screwups -- replying to a conversation that happened
  hours ago because you didn't notice you were scrolled up in the history buffer.
  If you try to send a message whilst scrolled, it'll warn you and check you
  really want to first.
  
* `testing/` is a Perl framework external to Irssi (ie: not a script) that will
  ultimately allow you to write unit tests for your scripts, and run them in a
  real irssi instance, and check that they behave correctly.  Still undergoing
  heavy development, and not really ready for public usage.
  
* `throttled_autojoin/` doesn't work. It's meant to allow people with huuuuuuge
  numbers of autojoin channels and servers to connect slowly, so as not to time
  themselves out when reconnecting. Mostly dead.
  
* `tinyurl_tabcomplete/` is a script which lets you hit tab following anything
  that looks like a URL to replace it with a tinyurl'd version.  Handy if you
  regularly paste Google-maps links or other massive horrible links.
  
* `url_hilight/` I can't remember what this one does. Suggestions welcome.

* `vim_mode/` The most exciting (and by far the largest) script here. Gives
  vim-addicted users a way to use most of their finger-memory in Irssi.  Still
  under active development, features and bug-requests welcome.  Also supported
  in #irssi_vim on Freenode.
                     
## Documentation

If you are here looking for my Irssi scripting documentation, please note that
it has been moved to
[https://github.com/shabble/irssi-docs/wiki](https://github.com/shabble/irssi-docs/wiki)

## Other Things

Many of my scripts require [uberprompt](https://github.com/shabble/irssi-scripts/blob/master/prompt_info/uberprompt.pl) as a
dependency.  Those that do will say so in the comments at the top of the file,
and will probably refuse to load without it.

