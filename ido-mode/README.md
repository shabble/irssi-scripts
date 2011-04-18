# NAME

ido_switcher.pl

# DESCRIPTION 

Search and select windows similar to ido-mode for emacs

# INSTALLATION

This script requires that you have first installed and loaded `uberprompt.pl`

Uberprompt can be downloaded from:

[https://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl](https://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl)

and follow the instructions at the top of that file for installation.

If uberprompt.pl is available, but not loaded, this script will make one
attempt to load it before giving up.  This eliminates the need to precisely
arrange the startup order of your scripts.

## SETUP

`/bind ^G /ido_switch_start [options]`

## USAGE

`C-g` (or whatever you've set the above bind to), enters IDO window switching mode.
You can then type either a search string, or use one of the additional key-bindings
to change the behaviour of the search.  `C-h` provides online help regarding
the possible interactive options.

### EXTENDED USAGE:

It is possible to pass arguments to the /ido_switch_start command, which
correspond to some of the interactively settable parameters listed below.

The following options are available:

- `-channels` -- search through only channels.
- `-queries`  -- search through only queries.
- `-all`      -- search both queries and channels (Default).
- `-active`   -- limit search to only window items with activity.
- `-exact`    -- enable exact-substring matching
- `-flex`     -- enable flex-string matching

_If neither of `-exact` or `-flex` are given, the default is the value of
`/set ido_use_flex`_

#### EXAMPLE

- `/bind ^G /ido_switch_start -channels`
- `/bind ^F /ido_switch_start -queries -active`

__NOTE:__ When entering window switching mode, the contents of your input line will
be saved and cleared, to avoid visual clutter whilst using the switching
interface.  It will be restored once you exit the mode using either `C-g`, `Esc`,
or `RET`.

### INTERACTIVE COMMANDS

The following key-bindings are available only once the mode has been
activated:

- `C-g`   - Exit the mode without changing windows.
- `Esc`   - Exit, as above.
- `C-s`   - Rotate the list of window candidates forward by 1
- `C-r`   - Rotate the list of window candidates backward by 1
- `C-e`   - Toggle 'Active windows only' filter
- `C-f`   - Switch between 'Flex' and 'Exact' matching.
- `C-d`   - Select a network or server to filter candidates by
- `C-u`   - Clear the current search string
- `C-q`   - Cycle between showing only queries, channels, or all.
- `C-SPC` - Filter candidates by current search string, and then reset
                 the search string
- `RET`   - Select the current head of the candidate list (the green one)
- `SPC`   - Select the current head of the list, without exiting the
                 switching mode. The head is then moved one place to the right,
                 allowing one to cycle through channels by repeatedly pressing space.
- `TAB`   - __[currently in development]__ displays all possible completions
                 at the bottom of the current window.
- _All other keys_ (`a-z, A-Z`, etc) - Add that character to the current search
                        string.

### USAGE NOTES

- Using C-e (show actives), followed by repeatedly pressing space will cycle
   through all your currently active windows.
- If you enter a search string fragment, and realise that more than one candidate
   is still presented, rather than delete the whole string and modify it, you can
   use C-SPC to 'lock' the current matching candidates, but allow you to search
   through those matches alone.

# AUTHORS

Based originally on [window_switcher.pl](http://scripts.irssi.org/scripts/window_switcher.pl) script Copyright 2007 Wouter Coekaerts
`<coekie@irssi.org>`.

Primary functionality Copyright 2010-2011 Tom Feist
`<shabble+irssi@metavore.org>`.

# LICENCE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# BUGS:

- __FIXED__ Sometimes selecting a channel with the same name on a different
   network will take you to the wrong channel.

# TODO

- __DONE__ C-g - cancel
- __DONE__ C-spc - narrow
- __DONE__ flex matching (on by default, but optional)
- TODO server/network narrowing
- __DONE__ colourised output (via uberprompt)
- __DONE__ C-r / C-s rotate matches
- __DONE__ toggle queries/channels
- __DONE__ remove inputline content, restore it afterwards.
- TODO tab - display all possibilities in window (clean up afterwards)
how exactly will this work?
- __DONE__ sort by recent activity/recently used windows (separate commands?)
- __TODO__ need to be able to switch ordering of active ones (numerical, or most
recently active, priority to PMs/hilights, etc?)
- __DONE__ should space auto-move forward to next window for easy stepping
     through sequential/active windows?