# Want to setup a new Mac?

```
curl "https://raw.githubusercontent.com/Flare576/randomSettings/master/macSetup.sh" | sh
```

This script will require your admin password a number of times, so don't just walk away from it :)

## What do I get?

### Zshell hotkey-style commands

#### General
| Command | Result |
|---------|--------|
| vz | Edit(vi) .zshrc and .zshenv |
| sz | Source .zshrc and .zshenv |
| vd | edit(vi) `dotfiles` root dir |

#### Git
| Command | Params | Result |
|---------|--------|--------|
| gac |Comment for commit (e.g., "Improve README")|Git Add/Commit/Push (set upstream if necessary |
| gmb | None | Git Master Branch |

#### Jira
| Command | Params | Result |
|---------|--------|--------|
| jiras | TicketID (e.g., PROJECT-123) | Set global story/ticket for `jira` commands |
| jira sprint | None | see the current sprint for your PROJECT |
| jira mine | None | see a list of unresolved tickets in PROJECT with you as ASSIGNEE |
| jira chrome | TicketID\* | Open ticket in Chrome |
| jira v | TicketID\* | View ticket details in `bat` if available, or `cat` otherwise |
| jira e | TicketID\* | Edit(vi) |
| jira c | TicketID\*, -m | Comment(vi) on ticket, follows `-m` pattern for predefined comment |
| jira t | State, TicketID\* | Transition ticket to new state (see `jira transitions`) |
| jira d | TicketID\* | Transition ticket to "Ready for QA" (feel free to modify this to be your "Dev Done" state) |
| jira g | TicketID\* | Transition ticket to "In Progress" and assigns to you (feel free to modify this to your "In Progress" state) |
| jira qa | TicketID\* | Transition ticket to "Testing" and sets you as the Reviewer (feel free to modify this to your "QA" state) |
| jira r | [State], TicketID\* | Review ticket by Comment(vi) on ticket, Transition to provided state or "Signoff" by default (feel free to modify this to your preferred Post-QA stateand with your preferred review template) |
> \*NOTE: If you don't provide a TIcketID, the global story/ticket set by `jiras` is used

#### Kubernetes
| Command | Params | Result |
|---------|--------|--------|
| kc | \* | alias to `kubectl`, so whatever you pass to kubectl |
| kcw | [namepace] | Watch the pods in context, refreshing 2sec, optionally grepping results |
| kcp | [namespace] | view pods in context, optionally grepping results |
| kcd\* | <namespace pod> | describe the pod |
| kcsh\* | <namespace pod> | ssh into the pod
| kced\* | <namespace> | edit deployment for namespace |
> \*note: these commands are designed for you to copy/paste the left-two columns from `kcp` or `kcw` and paste them in as their arguments

### vim config galore!

#### pathogen-driven plugins
- Badwolf - Beauty!
- vim-json - Make JSON better!
- typescript-vim - Make Typescript... less awful
- ag.vim - Silver Searcher... IN VIM
- ctrlp.vim - Fuzzy file finder!
- z.vim - The power of Z-script in Vim... not sure I like it yet
- vim-surround - easily change '' to "" to ` `, with `cs` then the thing that's there, and the thing you want
  - (e.g. 'hello world' to `hello world`, do cs'\`)

#### Hand-picked values!
See https://dougblack.io/words/a-good-vimrc.html for info, or the `.vimrc` file for line-by-line comments

#### Daily hot keys!
| Mode | Keys | Actions |
|------|------|---------|
| Visual | 'y | yank selected to mac clipboard |
| Normal | 'h | set Vim PWD to current directory (set home)
| Normal | 'd | Diff current buffer against on-disk file (changes since last safe)
| Normal | 'D | Diffs visible windows against eachother
| Normal | '<space> | turns off search highlighting
| Normal/Visual | j & k | move "visually" up and down, makes softwraps easier
| Insert | jk | shortcut to Escape
| Normal | B & E | shortcuts for `^` and `$`
| Normal | ctrl + j, k, h, l | change focus between windows
| Normal | H & L | Move between tabs
| Normal | >, <, +, - | resize current window
| Normal | gV | highlight last inserted text
| Normal | 'u | Brings up "Super Undo"
| Normal | 'a | fuzzy search for files under `pwd`
| Normal | ctrl+p | brings up file search under `pwd`

##### Editing with _style_ in Jira

| Mode | Keys | Actions |
|------|------|---------|
| Insert | 'jg | Starts a Green section
| Insert | 'jr | Starts a Red section
| Insert | 'jo | Starts an Orange section

#### Dot file hot keys!
| Mode | Keys | Actions |
|------|------|---------|
| Normal | ev | Edit .vimrc in new window
| Normal | ez | Edit .zshrc in new window
| Normal | ee | Edit .zshenv in new window
| Normal | sv | Source .vimrc in open vim instance
| Normal | ej | Edit .jira.d/config.yml in new window
| Normal | ed | Edit dotfiles root folder in new window

## What does it do?
1. Installs Xcode CLI _Admin Password Required_
1. Installs Homebrew
1. Installs brews:
      - cask
      - python
      - git
      - nvm
      - the\_silver_searcher
      - zsh
      - git-secrets
      - mas
      - vim (with vi override)
1. Pull down the rest of the package from github.com/flare576/dotfiles
1. Wires `git-secrets` to the project (prevent accidental secret commits)
1. Asks if you want to setup Github Accounts _Git Credentials Required... duh_
    - supports multiple accounts with MFA
    - uses domain name manipulation to tell which account you want to use
1. Install Oh My Zshell _Admin Password Required_
    - With custom Cobalt2 theme
    - With powerline fonts
1. Wires iTerm2's preferences to dotfiles version
1. Installs casks _Admin Password Required_
    - Dash (offline documentation)
    - Docker Edge
    - Dropbox
    - Firefox
    - IntelliJ IDEA
    - iTerm2
    - LaunchBar
    - Slack
    - Steam
    - Spotify
    - VLC
    - Google Chrome
1. Sets up initial Z file
1. Sets desktop image to resources/background.jpg
1. Moves dock to left side of screen
1. Shows hidden items in Finder
1. Fixes scroll direction
1. Kills smart quotes
1. Installs FadeText screen saver _Admin Password Required_
1. Makes bottom-left hot corner for screen saver
1. Locks machine on screen saver
1. Sets profile pic to resources/profile.jpg
1. Restarts Finder and Dock
1. Sets up vim
    - symlink .vimrc
    - pulls down Pathogen and
        - Badwolf
        - vim-json
        - typescript-vim
        - ag.vim
        - ctrlp.vim
1. Sets up other symlinks
    - .doNotCommit - Where secrets can safely live
    - .zshrc
    - .zshenv
    - .gitconfig
    - .zshrc.kubeHelper
    - idea script
    - vroom script
1. Installs Apps from AppStore _Requires AppStore Credentials_
    - Magnet
    - Spark
    - MS Remote Desktop
1. Installs text replacements _Requires manual interaction_
1. Forces setup of apps _Requires manual interaction_
    - Magnet
    - Spotify
    - Dropbox
    - LaunchBar
    - Dash
    - Spark

# I don't want ALL of that! I just want SOME of it!
It'll make your life easier if you clone the dotfiles project to your home directory (i.e. ~/dotfiles). You don't have to setup all the symlinks (though I highly recommend it), butall of the scripts assume you're following this structure.

The one exception is `.doNotCommit`; this file must be located in `~/dotfiles/` and symlinked to `~`. If you didn't run `scripts/macSetup`, you should run this:

```
touch ~/dotfiles/.doNotCommit
ln -sF ~/dotfiles/.doNotCommit ~
```

## I want that Jira CLI Awesomeness
This script will get you all setup:

```
~/dotfiles/scripts/jiraSetup
```

You should have on-hand:
- Emaill address in Jira
- Jira base URL
- Jira API token (see https://id.atlassian.com/manage/api-tokens)
- Main project name
- your "Shortname" (the name you use when you type [~first.last]) or otherwise tag yourself in Jira

## Others coming soon!

# Doing it manually? OSX? Install iterm2

https://www.iterm2.com/

# Install zshell

https://github.com/robbyrussell/oh-my-zsh

# Add to .zshrc

```
plugins=(git extract node npm z)
alias chrome='open -a Google\ Chrome'
function gac() {
  git add .
  git commit -m "$1"
  git push
}
```

# Add to .gitconfig
> This enables `npm cleanhouse` to delete branches no longer tied to origin branches for a given project
```
[alias]
	cleanhouse = ! echo "Deleting old branches" && git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
 ```

# Theme for zshell:

https://github.com/wesbos/Cobalt2-iterm

## Font for terminal:

Icons need the *Inconsolata* fonts

https://github.com/powerline/fonts/blob/master/Inconsolata/Inconsolata%20for%20Powerline.otf

## Changes:

```
diff cobalt2.zsh-theme ~/.oh-my-zsh/themes/cobalt2.zsh-theme
52c52
<     prompt_segment black default "%(!.%{%F{yellow}%}.)✝"
---
>     prompt_segment black default "%(!.%{%F{yellow}%}.)Ⓐ "
74c74
<   prompt_segment blue black '%3~'
---
>   prompt_segment blue white '%3~'
```

# Setup keyboard replacements
```
kirbydance -> <(^.^<)  (>^.^)>  <(^.^)>
shruggy -> ¯\_(ツ)_/¯
fliptable -> (╯°□°）╯︵ ┻━┻
fixtable -> ┬─┬ノ( º _ ºノ)
middlefinger -> 凸 (｀0´)凸
```

# Install Homebrew
```
xcode-select --install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

# Install The Silver Searcher
```
brew install the_silver_searcher
```

# Kubernetes Shortcuts

```
alias kc='kubectl'
alias kcp='kubectl get pods -o wide --all-namespaces $1'
```

# Vivium mappings
```
# Insert your preferred key mappings here.
map <c-f> scrollPageDown
map <c-b> scrollPageUp
map <c-h> previousTab
map <c-l> nextTab
```
