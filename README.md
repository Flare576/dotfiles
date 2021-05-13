# Flare's dotfiles
*You may also be interested in [Flare's Scripts](https://github.com/Flare576/scripts), a collection
of shell and NodeJS (check that project's readme!) scripts I use dozens of times an hour.*

Based on a lot of discoveries from [GitHub Does dotfiles](https://dotfiles.github.io/), this is my
repo for my dotfiles.  I've also included a setup script, mostly for personal use, that will bring a
brand new Mac from stock to stylish with minimal messing around.


```
bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/main/scripts/OSX/setupMac.sh)"
```

Or a new Mint Linux

```
bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/main/scripts/NIX/setupMint.sh)"
```

Or a new Ubuntu Linux

```
bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/main/scripts/NIX/setupUbuntu.sh)"
```
If not setting up a new machine I `git clone` directly into `~` and run the script for the thing(s) I want to setup:

```
sh dotfiles/scripts/setupRepo.sh # You should absoultey run this file to help prevent leaking secrets
sh dotfiles/scripts/setupLinks.sh # Symlinks files to ~
sh dotfiles/scripts/setupScripts.sh # pull scripts and sets up paths: see Flare57/scripts repo
sh dotfiles/scripts/setupVim.sh # Yes, this sets up vim
sh dotfiles/scripts/setupOmz.sh # Oh My Zshell goes deliciously with Zsh
sh dotfiles/scripts/setupLocations.sh # `wdate` and `wweather` use location information
```

> A quick note about secrets and private info: This project has keeps sensitive information in a set
of `.doNotCommit` files in the `$HOME/dotfiles/.doNotCommit.d` folder. They do not reside directly in `$HOME` because scripts in the `dotfiles` project can and do edit them.

If I also want to install all the apps I use frequently, I'll run

```
sh dotfiles/scripts/setupHomebrew.sh # Check the script for details
sh dotfiles/scripts/OSX/setupCasks.sh # Check the script for details
```

# Sure man, but what do they DO?!

You can read each of the scripts for details of how/what _they_ do, but as far as what YOU can do, here's a breakdown:

- [Hotkey Mentality](#hotkey-mentality)
- [vimrc](#vim-config-galore)
  - [Lots of custom config](#hand-picked-values)
  - [Plugins](#pathogen-driven-plugins)
  - [Hotkeys](#daily-hot-keys)
    - [Must-Know & Navigation](#must-know--navigation)
    - [Less Common](#less-common)
    - [Situational](#situational)
    - [Vim + Jira](#jira-colors)
    - [Quick-Edit](#quick-edit)
- [tmux](#tmux-hotkeys-galore)
- [Jira Awesomeness](#i-want-that-jira-cli-awesomeness)
  - [Jira Setup](#i-want-that-jira-cli-awesomeness)
  - [Jira Commands](#jira)
- [Zshell](#zshell)
  - [Hotkeys](#hotkeys)
  - [Kubernetes/Docker](#kubernetesdocker)
  - [vim-mode](#vimmode)
- [Tools](#tools)
    - [Theme Switching](#new-theme-switching)
- [Some fun autocompletes](#setup-keyboard-replacements)

## What do I get?

### Hotkey Mentality

There's a lot going on here, I know. Looking at all these lists is enough to make most folks close the browser tab, but bear with me for a moment.

The most important part of a program/tool is, in my opinion, getting around. For my configs, I've settled on a "vim-style" approach to this, which means using H, J, K, and L to move Left, Down, Up, and Right. Combining these movements with different modifiers makes up the bulk of getting around!

|  Modifier  | App |         Notes            |
|------------|------|-------------------------|
| Ctrl       | Vim  | Moves between *Buffers*
| Shift      | Vim  | Moves between *Tabs*
| Alt        | tmux | Moves between *panes*
| Shift+Alt  | tmux | Moves between *Windows*

As a bonus: `_` and `|` plus the above modifiers also splits/creates the thing it navigates horizontally or vertically!

### vim config galore!

#### Vim v8 Plugins
- [Badwolf](https://github.com/sjl/badwolf) - Beauty!
- [vim-airline](https://github.com/vim-airline/vim-airline) - Fast and flexible status line
- [vim-json](https://github.com/elzr/vim-json) - Make JSON better!
- [typescript-vim](https://github.com/leafgarland/typescript-vim) - Make Typescript... less awful
- [ag.vim](https://github.com/rking/ag.vim) - Silver Searcher... IN VIM
- [ctrlp.vim](https://github.com/kien/ctrlp.vim) - Fuzzy file finder!
- [z.vim](https://github.com/lingceng/z.vim) - The power of Z-script in Vim
- [undotree](https://github.com/mbbill/undotree) - Makes traversing the undo tree not suck
- [gutentags](https://github.com/ludovicchabant/vim-gutentags) + [tagabar](https://github.com/majutsushi/tagbar) - Index your source code and <Ctrl-]> your way to happiness
- [MergeTool](https://github.com/samoshkin/vim-mergetool) - Makes `git mergetool` way more useful
- [vim-surround]() - easily change '' to "" to ` `, with `cs` then the thing that's there, and the thing you want
  - (e.g. 'hello world' to "hello world", do `cs'"`)

#### Hand-picked values!
See https://dougblack.io/words/a-good-vimrc.html for info, or the `.vimrc` file for line-by-line comments

#### Daily hot keys!

##### Must-know & Navigation

| Mode | Keys | Actions |
|------|------|---------|
| Insert | jk | shortcut to Escape
| Normal/Visual | j/k/h/l | move "visually" up and down, makes soft-wraps easier
| Normal | B & E | shortcuts for `^` and `$`
| Normal | ctrl + j, k, h, l | change focus between windows
| Normal | H & L | Move between tabs
| Normal | :VE | Open a new Vertical buffer in Explore mode
| Normal | :HE | Open a new Horizontal buffer in Explore mode
| Normal | :TE | Open a new Tab in Explore mode
| Normal | ctrl + _ | split window horizontally
| Normal | ctrl + \| | split window vertically
| Normal | ,\<Enter> | zoom in/out of buffer
| Normal | >, &lt;, +, - | resize current window
| Normal | ,h | set Vim PWD to current directory (set home)
| Normal | ,a | fuzzy search (Silver Searcher) for files under `pwd`
| Normal | ,z | Open commonly used folders in current buffer (see [Z](https://github.com/rupa/z))
| Normal | ctrl+p | brings up file search under `pwd`
| Visual | ,y | yank selected to OSx/WSL clipboard |

##### Less Common

| Mode | Keys | Actions |
|------|------|---------|
| Visual |,uq | Removes quotes from selected text
| Normal | ,\<space> | turns off search highlighting
| Normal | ,d | Diff current buffer against on-disk file (changes since last save)
| Normal | ,dg | Diffs current buffer against git history
| Normal | ,D | Diffs visible windows against each other
| Normal | ,/ | Shows the count of your last search
| Normal | gV | highlight last inserted text
| Normal | ,u | Brings up "Super Undo"

##### Situational

| Mode | Keys | Actions |
|------|------|---------|
| Normal | @y | converts "Describe Table" and converts to YAML (beta)
| Visual | \<count>,\<Tab> | works on range, starts a # comment at column <count>
| Normal | ,q | saves current session to /tmp/ongoing and exits
| Normal | ,rb | [R]uns current file in [b]rowser (chrome by default)

##### Jira Colors

| Mode | Keys | Actions |
|------|------|---------|
| Insert | ,jg | Starts a Green section
| Insert | ,jr | Starts a Red section
| Insert | ,jo | Starts an Orange section

##### Quick-Edit

| Mode | Keys | Actions |
|------|------|---------|
| Normal | ,ev | Edit .vimrc in new tab
| Normal | ,ez | Edit .zshrc & .zshenv in new tab w/ split pane
| Normal | ,et | Edit .tmux.conf in new tab
| Normal | ,sv | Source .vimrc in open vim instance
| Normal | ,ej | Edit .jira.d/config.yml in new tab
| Normal | ,ed | Edit dotfiles root folder in new tab

### tmux Hotkeys Galore

|  Mode   |    Keys   | Actions |
|---------|-----------|---------|
| Default | Ma h, j, k, l  | Resize pane 2 units in given direction
| Default | M + h, j, k, l | Switch to pane given direction
| Default | M + \, -       | New horizontal, vertical split
| Default | M +⇧ + \|, _   | New window
| Default | M +⇧ + K       | Switch to the "last" window
| Default | M +⇧ + H, L    | Switch to window to the left/right
| Default | M +⇧ + :       | tmux command prompt
| Default | C-k            | clear buffer
| Default | M-Enter        | Maximize/Restore current pane
| Default | Ma b           | Sends UbuntuQuickInstall script to pane (for containers!)

## I want that Jira CLI Awesomeness
This script will get you all setup (assuming you cloned this project to ~/dotfiles)

```
~/dotfiles/scripts/jiraSetup
```

You should have on-hand:
- Emaill address in Jira
- Jira base URL
- Jira API token (see https://id.atlassian.com/manage/api-tokens)
- Main project name
- your "Shortname" (the name you use when you type [~first.last]) or otherwise tag yourself in Jira

The script will ask you for your information and write it to
`~/dotfiles/.doNotCommit.d/.doNotCommit.jira`

Now comes the fun part. If everything is setup correctly, you can run `jira -h`

You'll see the list of default commands (`help` through `session`), and then the ones I added.

My day generally goes like this (assuming I'm on Project **ABC** with various ticket numbers)

```
jira mine # See what I've been assigned
jira s -w # s[print], Otherwise, I'll see what we have in the sprint I can snag
jira v ABC-1234 # v(iew), Look at a ticket
jira w ABC-1234 # w[orkon], Set the global issue, depends on ~/.jira.d existing
jira g # g(rab) If it wasn't mine already, grab it
jira v # v(iew), Look at it again, notice no more typing ABC-1234!
jira c -m 'This is an awesome ticket' # c(omment), Drop a comment on it
jira ts # (TransitionS), After I'm done, check where it can go next

# if I don't have  a shortcut like `d(one)` or `p(R Review)`, I use the longer syntax
jira t -s "Whatever State" -m "I've done what I can!"```

# In case I need to drop a link to a poor, non-CLI coworker - this will put it on the Mac clipboard
jira link
```

The `r(eviewed)` command is a good example of combining several actions together if you want to add
your own!

The last thing I want to mention is that all of the views you see are 100% configurable; see the
`.jira.d/templates` folder.

#### Jira Commands

| Command | Params | Result |
|---------|--------|--------|
| jira w[orkon] | TicketID (e.g., PROJECT-123) | Set global story/ticket for `jira` commands |
| jira git | Branch Name | Create a new branch with JIRA_PREFIX/JIRA_ISSUE-BRANCH |
| jira s[print] | None | see the current sprint for your PROJECT |
| jira mine | None | see a list of unresolved tickets in PROJECT with you as ASSIGNEE |
| jira chrome | TicketID\* | Open ticket in Chrome |
| jira link | None | copies the link to the global ticket to the Mac clipboard |
| jira cookie | string | Hosted instances sometimes don't provide tokens; use sessions instead with daily cookies |
| jira i | None | Inspect current global story/ticket for `jira` commands |
| jira v | TicketID\* | View ticket details in `bat` if available, or `cat` otherwise |
| jira e | TicketID\* | Edit(vi) |
| jira c | TicketID\*, -m | Comment(vi) on ticket, follows `-m` pattern for predefined comment |
| jira t | State, TicketID\* | Transition ticket to new state (see `jira transitions`) |
| jira d | TicketID\* | Done: Transition ticket to "Ready for QA" (feel free to modify this to be your "Dev Done" state) |
| jira g | TicketID\* | Grab: Transition ticket to "In Progress" and assigns to you (feel free to modify this to your "In Progress" state) |
| jira qa | TicketID\* | QA: Transition ticket to "Testing" and sets you as the Reviewer (feel free to modify this to your "QA" state) |
| jira r | [State], TicketID\* | Review ticket by Comment(vi) on ticket, Transition to provided state or "Signoff" by default (feel free to modify this to your preferred Post-QA stateand with your preferred review template) |
> \*NOTE: If you don't provide a TicketID, the global story/ticket set by `jira w[orkon]` is used

### Zshell

#### Hotkeys
| Command | Parms | Result |
|---------|-------|--------|
| vz | none | Edit(vi) .zshrc and .zshenv |
| vd | none | Edit(vi) `dotfiles` root dir |
| vv | none | Edit(vi) with `/tmp/ongoing` session |
| vt | none | Edit(vi) with `/dotfiles/.tmux.conf` session |
| vs | none | Edit(vi) `~/scripts` root dir |
| sz | none | Source .zshrc and .zshenv |
| plcat | .plist file | OSX only: outputs human-readable contents of a `.plist` file |
| pi/py | various | runs `pipenv` and `pipenv run python` respectively

> See also [Git Aliases](https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet#git)

#### Kubernetes/Docker
| Command | Params    | Result                                                        |
|---------|-----------|---------------------------------------------------------------|
| k       | see docs  | alias to `kubectl`, so whatever you pass to kubectl           |
| k9s     | see docs  | UI for K8s. You're welcome                                    |
| klog    | none      | call kubelogin to authenticate in browser for current context |
| kcon    | context   | alias to `kubectl config use-context`                         |
| kcons   | none      | alias to `kubectl config get-context`                         |
| kn      | namespace | alias to `kubectl config set-context --current --namespace`   |
| lzy     | none      | opens lazydocker                                              |
| lzye    | none      | edits lazydocker config file                                  |
| dnuke   | none      | alias to `docker system prune --volumes -af`                  |

> See also [kubectl](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl), [docker-compose](https://github.com/sroze/docker-compose-zsh-plugin), [docker-aliases](https://github.com/webyneter/docker-aliases) or just run `alias | grep docker` to see them all!

#### vim-mode

ZSH has a [command-line editor](http://zsh.sourceforge.net/Guide/zshguide04.html) functionality,
which can be set to [vim-mode](http://stratus3d.com/blog/2017/10/26/better-vi-mode-in-zshell/) but
defaults to `emacs`. It's pretty nice, but I've become used to some of the emacs features. To bring
them back (and to make it act more like my vim), these changes were made

| Key(s) | Mode  | Action |
|--------|-------|--------|
| jk     | viins | "Escapes" to vicmd mode
| B      | vicmd | Jumps to front of line (imitate `^`)
| E      | vicmd | Jumps to front of line (imitate `$`)
| ↑ / ↓  | viins | Scrolls through previous commands (imitates emacs behavior)


### Tools

#### \*\*NEW\*\* Theme Switching!

I'd been using the same theme(s) for years and decided to take a look around and see what was
available. Turns out there's a lot, and [a lot to learn](./themes/README.md).

This package ships with Solarized Dark/Light themes, which you can flip between with

```
st [day, night, light, dark]
```

The script updates

- Supported terminal emulators
  - Terminal.app (OSX): *Script will switch any active windows, but new windows will have old style until application is restarted*
  - gnome (Chromebook)
  - mintty/wsltty (WSL)
- vim: *Will update the next time you enter/exit `input` mode, and only that instance of vim*
- zsh: *Will update after the next prompt refresh (generally after you enter/ctrl-c a command)*
- bat

#### Recommended

Sometimes you just don't want to dig through a bunch of scripts and want to know what a person suggests. Here's what makes my life easier:

1) Homebrew / Cask (https://brew.sh/)
1) `vim` [grab the most recent version](https://www.vim.org/) †
1) `git` + `hub` [gitHub actions in your CLI](https://hub.github.com/) †
1) `the_silver_searcher` [Bettah than awk](https://github.com/ggreer/the_silver_searcher) †
1) `tmux` [panel/window manager in terminal](https://github.com/tmux/tmux/wiki) †
1) `bat` [replaces `cat`](https://github.com/sharkdp/bat) †
1) `1password` [More secure, cleaner interface](https://1password.com) ††
1) `launchbar` [Spotlight kinda sux](https://www.obdev.at/products/launchbar/index.html) ††
1) `slack` [Please don't make me use teams](https://www.slack.com) ††
1) `pipenv` [w/ python 3.7.2](https://pipenv-fork.readthedocs.io/en/latest/) †
1) `nvm` [99 problems, but node versions ain't one](https://github.com/nvm-sh/nvm) †
1) ZSH [Bettah than bash](https://www.zsh.org/) †
1) `shellcheck` [static analysis on scripts](https://www.shellcheck.net/) †
1) `git-secrets` [enabled on this project](https://github.com/awslabs/git-secrets) †
1) `mas` [cli app store tool](https://github.com/mas-cli/mas) †
1) `cheat` [CLI Cheat sheets](https://github.com/cheat/cheat) †
1) `watch` [re-run commands on timer](https://linux.die.net/man/1/watch) †
1) `jq` [process JSON output](https://stedolan.github.io/jq/) †
1) `k9s` [CLI UI for K8s](https://github.com/derailed/k9s) †
1) `docker` [Container Manager](https://www.docker.com) ††
1) `lazydocker` [CLI UI for Docker](https://github.com/jesseduffield/lazydocker) †
1) All my Vim config; sorry, you're gonna have to read it for details.
> † Installable with Homebrew
> †† Installable with Homebrew Cask

# Setup keyboard replacements
```
kirbydance -> <(^.^<)  (>^.^)>  <(^.^)>
shruggy -> ¯\_(ツ)_/¯
fliptable -> (╯°□°）╯︵ ┻━┻
fixtable -> ┬─┬ノ( º _ ºノ)
middlefinger -> 凸 (｀0´)凸
```
