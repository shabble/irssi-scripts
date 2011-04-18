# NAME

vim_mode.pl

# DESCRIPTION

An Irssi script to emulate some of the vi(m) features for the Irssi inputline.

# INSTALLATION

Copy into your `~/.irssi/scripts/` directory and load with
`/SCRIPT LOAD vim_mode.pl`. You may wish to have it autoload in one of the
[usual ways](https://github.com/shabble/irssi-docs/wiki/Guide#Autorunning_Scripts).

## DEPENDENCIES

For proper :ex mode support, vim-mode requires the installation of `uberprompt.pl`
Uberprompt can be downloaded from:

[https://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl](https://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl)

and follow the instructions at the top of that file for installation.

If you don't need Ex-mode, you can run vim_mode.pl without the
uberprompt.pl script, but it is recommended.

### Irssi requirements

0.8.12 and above should work fine. However the following features are
disabled in irssi < 0.8.13:

- `j` `k` (only with count, they work fine without count in older versions)
- `gg`, `G`

It is intended to work with at Irssi  0.8.12 and later versions. However some
features are disabled in older versions (see below for details).

Perl >= 5.8.1 is recommended for UTF-8 support (which can be disabled if
necessary).  Please report bugs in older versions as well, we'll try to fix
them.  Later versions of Perl are also faster, which is probably beneficial
to a script of this size and complexity.

## SETUP

Use the following command to get a statusbar item that shows which mode
you're in.

`/statusbar window add vim_mode`

And the following to let `:b _name_` display a list of matching channels

`/statusbar window add vim_windows`

__Note:__ Remember to `/save` after adding these statusbar items to make them
permanent.



### FILE-BASED CONFIGURATION

Additionally to the irssi settings described in [SETTINGS](#pod_SETTINGS), vim_mode
can be configured through an external configuration file named "vim_moderc"
located in `~/.irssi/vim_moderc`. If available it's loaded on startup and every
supported ex-command is run. Its syntax is similar to "vimrc". To (re)load it
while vim_mode is running use `:so[urce]`.

Currently Supported ex-commands:

- `:map`

# USAGE

## COMMAND MODE

It supports most commonly used command mode features:

                - Insert/Command mode. Escape and Ctrl-C enter command mode.
                  /set vim_mode_cmd_seq j allows to use jj as Escape (any other character
                  can be used as well).
                - Cursor motion: h l 0 ^ $ <Space> <BS> f t F T
                - History motion: j k gg G
                  gg moves to the oldest (first) history line.
                  G without a count moves to the current input line, with a count it goes to
                  the count-th history line (1 is the oldest).
                - Cursor word motion: `w b ge e W gE B E`
                - Word objects (only the following work yet): `aw aW`
                - Yank and paste: `y p P`
                - Change and delete: `c d`
                - Delete at cursor: `x X`
                - Replace at cursor: `r`
                - Insert mode: `i a I A`
                - Switch case: `~`
                - Repeat change: `.`
                - Repeat `ftFT: ; ,`
                - Registers: `"a-"z "" "0 "* "+ "_` (black hole)
                - Appending to register with `"A-"Z`
            - `""` is the default yank/delete register.
        - `"0` contains the last yank (if no register was specified).
    - The special registers `"* "+` both contain irssi's internal cut-buffer.

- Line-wise shortcuts: `dd cc yy`
- Shortcuts: `s S C D`
- Scroll the scrollback buffer: `Ctrl-E Ctrl-D Ctrl-Y Ctrl-U Ctrl-F Ctrl-B`
- Switch to last active window: `Ctrl-6/Ctrl-^`
- Switch split windows: <Ctrl-W j Ctrl-W k>
- Undo/Redo: `u Ctrl-R`

Counts and combinations work as well, e.g. `d5fx` or `3iabc<esc>`.
Counts also work with mapped ex-commands (see below), e.g. if you map `gb` to do
`:bn`, then `2gb` will switch to the second next buffer.  Repeat also supports
counts.

## INSERT MODE

The following insert mode mappings are supported:

- Insert register content: Ctrl-R x (where x is the register to insert)

## EX-MODE

Ex-mode (activated by `:` in command mode) supports the following commands:

            - Command History: `<uparrow>`, `<<downarrow>`
                                   `:eh`       - show ex history
            - Switching buffers: `:[N]b [N]` - switch to channel number
                                 `:b#`       - switch to last channel
                                 `:b` <partial-channel-name>
                                 `:b` <partial-server>/<partial-channel>
                                 `:buffer {args}` (same as `:b`)
                                 `:[N]bn[ext] [N]` - switch to next window
                                 `:[N]bp[rev] [N]` - switch to previous window
            - Close window:      `:[N]bd[elete] [N]`
            - Display windows:  `:ls`, `:buffers`
            - Display registers: `:reg[isters] {args}`, `:di[splay] {args}`
            - Display undolist:  `:undol[ist]` (mostly used for debugging)
            - Source files       `:so[urce]` - only sources vim_moderc at the moment,
                                     `{file}` not supported
            - Mappings:          `:map`             - display custom mappings
            - `:map {lhs}`       - display mappings starting with {lhs}
        - `:map {lhs} {rhs}` - add mapping
    - `:unm[ap] {lhs}`   - remove custom mapping

- Save mappings:     `:mkv[imrc][!]` - like in Vim, but [file] not supported
- Substitute: `:s///` - _i_ and _g_ are supported as flags, only /// can
                             be used as separator, uses Perl regex instead of
                             Vim regex
- Settings: `:se[t]`                  - display all options
                     `:se[t] {option}`         - display all matching options
                     `:se[t] {option} {value}` - change option to value

### MAPPINGS

`{lhs}` is the key combination to be mapped, `{rhs}` the target. The
`<>`> notation is used

(e.g. `<C-F>` is Ctrl-F), case is ignored. Supported `<>` keys:

- `<C-A>` - `<C-Z>`,
- `<C-^>`
- `<C-6>`
- `<Space>`
- `&LT;CR&GT;`
- `&LT;BS&GT;`
- `<Nop>`

Mapping ex-mode and irssi commands is supported. When mapping ex-mode commands
the trailing `<Cr>` is not necessary. Only default mappings can be used
in {rhs}.

Examples:

- `:map w  W`      - to remap w to work like W
- `:map gb :bnext` - to map gb to call :bnext
- `:map gB :bprev`
- `:map g1 :b 1`   - to map g1 to switch to buffer 1
- `:map gb :b`     - to map gb to :b, 1gb switches to buffer 1, 5gb to 5
- `:map <C-L` /clear> - map Ctrl-L to irssi command /clear
- `:map <C-G` /window goto 1>
- `:map <C-E` <Nop>> - disable <C-E>, it does nothing now
- `:unmap <C-E`>     - restore default behavior of <C-E> after disabling it

Note that you must use `/` for irssi commands (like `/clear`), the current value
of Irssi's cmdchars does __not__ work! This is necessary do differentiate between
ex-commands and irssi commands.

## SETTINGS

The settings are stored as irssi settings and can be set using `/set` as usual
(prepend `vim_mode_` to setting name) or using the `:set` ex-command. The
following settings are available:

- utf8:                 support UTF-8 characters, boolean, default on
- debug:                enable debug output, boolean, default off
- cmd_seq:              char that when double-pressed simulates <esc>,
                        string, default ''
=item start_cmd:            start every line in command mode, boolean, default off
- max_undo_lines:       size of the undo buffer. Integer, default 50 items.
- ex_history_size:      number of items stored in the ex-mode history.
                            Integer, default 100.
- prompt_leading_space: determines whether ex mode prepends a space to the
                        displayed input. Boolean, default on

In contrast to irssi's settings, `:set` accepts 0 and 1 as values for boolean
settings, but only vim_mode's settings can be set/displayed.

Examples:

   :set cmd_seq=j   # set cmd_seq to j
   :set cmd_seq=    # disable cmd_seq
   :set debug=on    # enable debug
   :set debug=off   # disable debug

# SUPPORT

Any behavior different from Vim (unless explicitly documented) should be
considered a bug and reported.

__NOTE:__ This script is still under heavy development, and there may be bugs.
Please submit reproducible sequences to the bug-tracker at:
[http://github.com/shabble/irssi-scripts/issues](http://github.com/shabble/irssi-scripts/issues)

or contact rudi_s or shabble on irc.freenode.net (#irssi and #irssi_vim)

# AUTHORS

Copyright &copy; 2010-2011 Tom Feist `<shabble+irssi@metavore.org>` and
Copyright &copy; 2010-2011 Simon Ruderich `<simon@ruderich.org<gt`>

# THANKS

Particular thanks go to

- estragib: a lot of testing and many bug reports and feature requests
- iaj: testing
- tmr: explaining how various bits of vim work

as well as the rest of `#irssi` and `#irssi_vim` on Freenode IRC.

# LICENCE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

# BUGS

- count before register doesn't work: e.g. 3"ap doesn't work, but "a3p does
- mapping an incomplete ex-command doesn't open the ex-mode with the partial
  command (e.g. `:map gb :b` causes an error instead of opening the ex-mode and
  displaying `:b<cursor>`)
- undo/redo cursor positions are mostly wrong

# TODO

    - History:
    - ` * /,?,n,N` to search through history (like rl_history_search.pl)

        - Window switching (`:b`)
        - Tab completion of window(-item) names
    - non-sequential matches(?)

See also the TODO file at
[github](https://github.com/shabble/irssi-scripts/blob/master/vim-mode/TODO) for
many many more things.

## WONTFIX

Things we're not ever likely to do:

- Macros