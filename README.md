# Flare's dotfiles
*You may also be interested in [Flare's Scripts](https://github.com/Flare576/scripts), a collection
of shell and NodeJS (check that project's readme!) scripts I use dozens of times an hour.*

Based on a lot of discoveries from [GitHub Does dotfiles](https://dotfiles.github.io/), this is my
repo for my dotfiles.  I've also included a setup script, mostly for personal use, that will bring a
brand new Mac from stock to stylish with minimal messing around.

```
bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/main/setup/OSX/mac.sh)"
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
sh dotfiles/setup/secureRepo.sh # You should absolutely run this file to help prevent leaking secrets
sh dotfiles/setup/linkFiles.sh # Symlinks files to ~
sh dotfiles/setup/scripts.sh # pull scripts and sets up paths: see Flare57/scripts repo
sh dotfiles/setup/vim.sh # Yes, this sets up vim
sh dotfiles/setup/omz.sh # Oh My Zshell goes deliciously with Zsh
```

> A quick note about secrets and private info: This project recommends keeping sensitive information
in a set of `.doNotCommit` files in the `$HOME/dotfiles/.doNotCommit.d` folder. They do not reside
directly in `$HOME` because scripts in the `dotfiles` project can and do edit them.

If I also want to install all the apps I use frequently, I'll run

```
sh dotfiles/setup/homebrew.sh # Check the script for details
sh dotfiles/setup/OSX/casks.sh # Check the script for details
```

# Sure man, but what do they DO?!

You can read each of the scripts for details of how/what _they_ do, but as far as what YOU can do,
here's a breakdown:

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

There's a lot going on here, I know. Looking at all these lists is enough to make most folks close
the browser tab, but bear with me for a moment.

The most important part of a program/tool is, in my opinion, getting around. For my configs, I've
settled on a "vim-style" approach to this, which means using H, J, K, and L to move Left, Down, Up,
and Right. Combining these movements with different modifiers makes up the bulk of getting around!

|  Modifier  | App |         Notes            |
|------------|------|-------------------------|
| Ctrl       | Vim  | Moves between *Buffers*
| Shift      | Vim  | Moves between *Tabs*
| Alt        | tmux | Moves between *panes*
| Shift+Alt  | tmux | Moves between *Windows*

As a bonus: `_` and `|` plus the above modifiers also splits/creates the thing it navigates
horizontally or vertically!

### vim config galore!

#### Vim v8 Plugins
- [Solarized](https://ethanschoonover.com/solarized/) - Beauty!
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
| Normal | ,a | fuzzy search (Silver Searcher) for files under `pwd`
| Normal | ,z | Open commonly used folders in current buffer (see [Z](https://github.com/rupa/z))
| Normal | ctrl+p | brings up file search under `pwd`
| Visual | ,y | yank selected to OSx/WSL clipboard

##### Less Common

| Mode | Keys | Actions |
|------|------|---------|
| Visual |,uq | Removes quotes from selected text
| Normal | ,\<space> | turns off search highlighting
| Normal | ,dc | Diff current buffer against on-disk file (changes since last save)
| Normal | ,dg | Diffs current buffer against git history
| Normal | ,do | Diffs "open" buffers against each other
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
| Default | Ma Enter       | Maximize/Restore current pane
| Default | Ma b           | Sends UbuntuQuickInstall script to pane (for containers!)

## I want that Jira CLI Awesomeness

Check out [flare576/jira-cli](https://github.com/Flare576/jira-cli).

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
| B      | vicmd | Jumps to front of line (imitate `^`)
| E      | vicmd | Jumps to front of line (imitate `$`)
| ↑ / ↓  | viins | Scrolls through previous commands (imitates emacs behavior)


### Tools

#### Theme Switching!

See [flare576/switch-themes](https://github.com/Flare576/switch-theme).

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
