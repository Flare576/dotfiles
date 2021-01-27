# This folder

Each sub-folder in this folder represents a _theme_. A theme consists of:

* Terminal Themes
  * `.terminal` for Terminal.app (OSX)
  * `.minttyrc` for mintty/wsltty (WSL)
  * `.gnome` for gnome (Chromebook)
* Main applications
  * *_tmux
  * *_vim
  * *_zsh
* config file

In addition to the core apps, `bat` can also be customized as long as you've loaded the theme to its
cache!

A theme's folder name must be the same as the `name` attribute in the config.

# Colors

It took me longer than I'd like to admit to grok colors in ZSH/terminals/tmux,
so I'll try to lay out what I've learned here.

## Start at the Top - Terminals

Your terminal emulator controls 2 things

- How many "Slots" of colors you can use
- The values those slots represent

For example, Apple's Terminal.app offers 16 colors in its themes. Some terminal
emulators offer 8, some offer 256 or more. See [ANSI Escape
Codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) for info on the
number of "slots" and their default values. For this doc, I'll be talking about
Terminal.app.

When you load a theme, you're filling the slots you have available with different values, but you're not changing
their *names*.

And their names are where I got lost. At the very core, though, the names are
escape sequences:

> \e[31m

That is literally how you refer to a color whose default value is "red". Go
ahead, type the following into your terminal; it should show up red.

```
echo "\e[31mHello World"
```

The first chart on the page I linked to above (for 3- and 4-bit colors) shows
that 30-37 are the number-parts for standard Foreground names, and 40-47 are
for Background. 90-97 and 100-107 are for "Bold" or "Bright" or "Extended"
colors; don't get too worried about the term, just think of them as a few more
names you have to work with.

## What the Shell

Then you step into your shell. I'll be talking about ZSH because that's what
I've researched, but other shells may do a similar re-assigning to this.

ZSH makes using colors easier* by replacing the escape codes with functions and
alternate keys: [ZSH Theme Cheat
Sheet](https://jsfiddle.net/seport/shrovLgf/embedded/result/). It provides 8
standardized names (black, red, green, yellow, blue, magenta, cyan, white) as
well as number codes for the spectrum of 256 colors.

> \*Once you understand how your terminal theme, escape codes, and ZSH's
> mappings work, it actually does make things easier... until then, it was just
> another layer of confusion for me.

My advice is to avoid both the `$fg[colorname]` and `%F{...}` mechanisms. While
experimenting I found that the 8 color names were essentially worthless (since
you can't access the "Bold" colors) and that the shorthand %F failed to load
any colors beyond `007`. **Just use the upper-case `$FG[###]` function.**

### $FG[###] Explained

If you run `spectrum_ls`, you'll get back an example of all the colors you have
available, but pay special attention to 000-015; these are your themes
definitions of 30-37 and 90-97. If you dive into [source code for
spectrum_ls](https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/spectrum.zsh#L17)
you'll see why...

It's our friend, escape codes! Going back to that Wiki page, we can see that
`\e[38;5;___m` is the escape code for "Select foreground color" and
`\e[48;5;___m` is the code for background! And that syntax is just making an
"associative array" where `${FG[001]}` holds the value `\e[38;5;001m`, which is
just the 8-bit way of writing `\e[31m;` from before!

### FG + %{ + %} = PROMPTS

So, now we know that, in ZSH, we can use the `FG` variable ([Array
Syntax](https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/))
and *000* through *255* to reference colors. Additionally, when we're building
command prompt, we use [the %{...%}
syntax](http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Visual-effects)
to indicate a string is an escape sequence. Putting those together, we can make
our shell prompt a red greater-than sign:

```
PROMPT='%{${FG[001]}%}> '
```

Except... now all of our input is red! ZSH also provides helper functions (`%f`
for foreground, `%k` for background) to turn off all the formatting we've
added, so we can round out our code with that:

```
PROMPT='%{${FG[001]}%}>%f '
```

## TMUX

[tmux](https://github.com/tmux/tmux/wiki), like ZSH, is beholden to the
terminal emulator in which it's running to define the colors it can use. Unlike
ZSH, however, it provides sane, [human-readable
values](https://man7.org/linux/man-pages/man1/tmux.1.html#STYLES)**. Running any
of the following from the tmux command line will cause the window listing to
display red text on a green background (ew)

```
:set-window-option -g window-status-current-style fg=colour9,bg=colour2
:set-window-option -g window-status-current-style fg=brightred,bg=green
:set-window-option -g window-status-current-style fg='#CC4D16',bg='#859900'
```
> \*\*Human readable, but also British English... still an improvement!

### VIM

I actually never even had to open the vim plugin; "It Just Works"! Based on a
quick look, though, I'd say that vim plugins get to use hex codes for their
colors.

# Attribution
- Solarized Dark Terminal.app Theme from [Matijs](https://gist.github.com/matijs/808eda8c133d41f9338f89a0077d6b95)
- Solarized Light Terminal.app Theme adapted from above using [Solarized Main Page](https://ethanschoonover.com/solarized/#usage-development)
- Solarized Light/Dark Tmux Theme from [Seebi](https://github.com/seebi/tmux-colors-solarized)
- Solarized Light/Dark ZSH Theme is based on work by [Wesbos](https://github.com/wesbos/cobalt2)
- Solarized Light/Dark vim Theme from [Ethan Schoonover](https://github.com/altercation/vim-colors-solarized)
