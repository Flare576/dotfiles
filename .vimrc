" "ARE YOU SERIOUS RIGHT MEOW?! 300+ LINES IN A VIM CONFIG?!"
" Yeah, I know. I tried splitting it out into logical pieces and hated it; too
" much time spent looking for the right file, and if you end up
" searching/grepping anyway, why not just stick it all in the same file.
" Here's an index, though!
"
"# Settings
"## Configuration
"## Foramtting
"## Look_and_Feel
"# Mappings
"## Common
"## Movement
"## Sizing
"## Other_mappings
"# Plugins
"# Diff_and_Merge
"# Editing_Tricks
"## Config_File_Hotkeys
"# Macros
"# Filetypes
"## JavaScript
"## TypeScript
"## Python
"## Other_filetypes
"# References

"############################## Settings ###########

"########################## Configuration
syntax enable
set exrc                " Allow project-specific .vimrc files THIS CAN BE DANGEROUS
let g:netrw_keepdir=0   " see :help netrw-c
set shell=zsh           " bring ZShell config in
let mapleader=","       " leader is comma
set spelllang=en        " English for spelling!
" AG snags Shift+H, which breaks switching tabs while in quickfix
let g:ag_apply_qmappings=0
" New, better words!
set spellfile=$HOME/dotfiles/en.utf-8.add,$HOME/dotfiles/.doNotCommit.en.utf-8.add
set thesaurus+=$HOME/.local/share/thesaurus.txt
set timeoutlen=1000 ttimeoutlen=0

"########################## Formatting
set tabstop=2           " number of visual spaces per TAB
set softtabstop=2       " number of spaces in tab when editing
set shiftwidth=2        " size of an "indent
set expandtab           " tabs are spaces
set showcmd             " Show info like highlighted row count
set noshowmode          " Hide mode, shown in airline
set smarttab            " find next tabstop and insert spaces until it
set nowrapscan          " If you want to start at the beginning, just `gg`

"########################## Look_and_Feel

set number              " show line numbers
set cursorline          " highlight current line
set wildmenu            " visual autocomplete for command menu
set lazyredraw          " redraw only when we need to.
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set ignorecase          " ignore case in search, use \C to enable
set smartcase           " if you use upper-case, turn on Case Sensitive
set hlsearch            " highlight matches
set foldlevelstart=10   " open most folds by default
set foldmethod=indent   " Auto-define folds by indentation
set foldcolumn=2        " Show fold status by line numbers
set splitbelow          " Open new split windows UNDER current window
set splitright          " Open new vsplit windows RIGHT of current window
set switchbuf=split     " open new splits when using :sb, :cc, etc. (or Ag results)
" on trial
set switchbuf=useopen,usetab,uselast
set backspace=2         " Same as indent, eol, start, allows backspace essentially anywhere in insert mode
set modeline            " Allows files to define some variables (e.g., filetype)
set modelines=5         " Modelines need to be within 5 lines of top/bottom
set textwidth=120       " auto-formatter (gq) width
set cc=120              " highlights characters over 120 width

" White text on maroon in search highlight (default difficult to read)
highlight Search ctermbg=5 ctermfg=white
" Extra whitespace in red
highlight ExtraWhitespace ctermbg=red ctermfg=white guibg=red
augroup whitespace
  au!
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red ctermfg=white guibg=red " Define for color schemes
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/ " Run on Window enter
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/ " Run on insert enter (this plus next makes screen not flash)
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/ " Run on exiting Insert Mode (only trailing)
  autocmd BufWinLeave * call clearmatches() " Run on leaving window (Clear all the matches)
augroup END

"############################## Mappings ###########

"########################## Common
" jk is a great "ESC", but new key layout means ESC is easier
"inoremap jk <esc>

"########################## Movement
" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Flip ^->B and $->E
" B/E moves to ends of line
noremap B ^
noremap E $
" ^/$ doesn't do anything (muscle training)
noremap ^ <nop>
noremap $ <nop>

" move between buffers windows sanely
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>
nmap <silent>  :spli<CR>
nmap <silent>  :vspli<CR>

" move between tabs with Shift+ H/L
nmap <silent> H gT
nmap <silent> L gt

"########################## Sizing
nnoremap <silent> > :exec "vertical resize +1"<CR>
nnoremap <silent> < :exec "vertical resize -1"<CR>
nnoremap <silent> + :exec "resize +1"<CR>
nnoremap <silent> - :exec "resize -1"<CR>

"########################## Other_mappings
" Insert 10 dashes
nnoremap <leader>- 10i-<ESC>
" Show count of last find
nnoremap <leader>/ :%s///gn<CR>
" Run current file with various commands
" r[un] with [b]rowser, currently Firefox
nnoremap <leader>rb :silent !firefox %<CR> :redraw!<CR>
nnoremap <leader>rm :silent !macdown %<CR> :redraw!<CR>
" Save session to /tmp and exit
nnoremap <leader>q :call MakeRootSession()<CR> :qa<CR>
function! MakeRootSession()
  let git_dir = system("git rev-parse --show-toplevel")
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
  " if git project, use that root for Sesion
  if empty(is_not_git_dir)
    let mysession = substitute(git_dir, '\n*$', "", "")
  else
    let mysession = expand('%:p:h')
  endif
  echo mysession
  execute 'mksession! '. mysession . "/Session.vim"
endfunction

"############################## Plugins ###########

" netrw can be a dick about <c-l>
" see https://stackoverflow.com/questions/33351179/how-to-rewrite-existing-vim-key-bindings
nmap <c-a-r> <Plug>NetrwRefresh
" Apparently :E only works by default because there's only one command that starts with E... fix that
command! -bang  E Explore<bang>
command!        VE Vexplore!
command!        HE Hexplore
command!        TE Texplore

" Super-undo
nnoremap <leader>u :UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle = 1
" TagBar
nnoremap <leader>. :TagbarToggle<CR>
" Zoom / Restore window. Stolen from https://github.com/markstory/vim-zoomwin/blob/master/plugin/zoomwin.vim
function! s:ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction

command! ZoomToggle call s:ZoomToggle()
nnoremap <leader><Enter> :ZoomToggle<CR>
" nnoremap <leader><Enter> :call Toggler('zoomed', 'let t:zoom_winrestcmd = winrestcmd();resize;vertical resize', ':call winrestcmd()')<CR>
nnoremap <leader>a :Ag! |" Silver Searcher in quick-fix window (close with :ccl)
nnoremap <leader>z :Zc |" "Z" script for Vim, Zc to open in current buffer

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"############################## Diff_and_Merge ###########

" Diff unsaved buffer against original
nnoremap <silent> <leader>dc :DiffChangesDiffToggle<CR>
" Diff against git
nnoremap <leader>dg :call GitDiff()<CR>
" Diff open windows
nnoremap <silent> <leader>do :call Toggler('windiff', ':windo diffthis', ":windo diffoff")<CR>

" Opens mergetool
nmap <leader>mt <plug>(MergetoolToggle)

function GitDiff()
    :silent write
    :silent execute '!git diff --color=always -- ' . expand('%:p') . ' | less --RAW-CONTROL-CHARS'
    :redraw!
endfunction

function! Toggler(vari, on_code, off_code) abort
  let vis_pt = 't:' . a:vari
  if exists('{vis_pt}') && {vis_pt}
    execute a:off_code
    let {vis_pt} = 0
  else
    execute a:on_code
    let {vis_pt} = 1
  endif
endfunction

"############################## Editing_Tricks  ###########

" enables Leader + y to do clipboard copy in visual mode (OSx)
vnoremap <silent> <leader>y :<CR>:let @a=@" \| execute "normal! vgvy" \| let res=system("pbcopy", @") \| let @"=@a<CR>
" enables Leader + y to do clipboard copy in visual mode (WSL)
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " default location
if executable(s:clip)
  augroup WSLYank
    autocmd!
    autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' | '.s:clip)
  augroup END
end
" enables Leader + uq to remove quotes from selection
vnoremap <leader>uq :s/\v"([^"]+)"/\1/g<CR>
" enables Leader + [space] to clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>
" Remove trailing whitespace from file
nnoremap <silent> <leader>ws :%s/\s\+$//g<CR>
" highlight last inserted text
nnoremap gV `[v`]
" Make right-side notes                 # like this
" Highlight block, type note start column, then ,<Tab>
vnoremap <leader><Tab> :<C-U>'<,'>call RightNote()<CR>
function RightNote()
  if (v:count)
    let g:startNote = v:count
  endif

  let @m=''
  :execute "normal! ^t#l\"md$"
  :execute "normal! " . g:startNote . "A \<Esc>d" . g:startNote . "\|A\<Esc>\"mp"
endfunction

" Jira green/red/orange text
map <silent> <leader>jg E:setlocal indentkeys-=<:><CR>a {color:#14892c}{color}<Esc>7h:setlocal indentkeys+=<:><CR>a
map <silent> <leader>jr E:setlocal indentkeys-=<:><CR>a {color:#d04437}{color}<Esc>7h:setlocal indentkeys+=<:><CR>a
map <silent> <leader>jo E:setlocal indentkeys-=<:><CR>a {color:#f79232}{color}<Esc>7h:setlocal indentkeys+=<:><CR>a

" F5 does :e on each buffer, basically a "safe" refresh
nnoremap <F5> :bufdo e<CR>

"############################## Config_File_Hotkeys ###########
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ez :tabnew ~/dotfiles/.zshrc<CR>:spl ~/dotfiles/.zshenv<CR>
nnoremap <leader>et :tabnew ~/dotfiles/.tmux.conf<CR>
nnoremap <leader>ej :tabnew ~/.jira.d/config.yml<CR>
nnoremap <leader>ed :tabnew ~/dotfiles<CR>

"############################## Macros ###########
" Take the jest coverage and convert it to PR format
let @c=':set nowrapkkBt|jjdET|jjd:set wrap'
" Take a row from postgres with headers and make an insert sequelize line
let @v='I|jk:s/\v\s+\|/|/g:s/\v\|\s+/|/g:s/\v\|([^\|]*)/''\1'', /g::silent! s/\v''''/NULL/gExxa)jk'
let @p='OAOAI|jk:s/\v\s+\|/|/g:s/\v\|\s+/|/g:s/\v\|([^\|]*)/\1, /gI(jkExxa) VALUES (jkOBdd@vOAEJx'
" Take a table def from `describe table` and convert to YAML
let @y=':%s/\v^\|\s*([^ ]+)\s*\|\s*([^ ]+)\s*\|\s*([^ ]+)\s*\|\s*([^ ]*)\s*\|\s*([^ ]*)\s*\|\s*(\w[^\|]+|)\s+\|/  - field_name: \1\r    description:\r    type: \2\r    nullable: \3\r    key: \4\r    default: \5\r    extra: \6'

"############################## Filetypes ###########
" load filetype-specific indent files and plugins
filetype indent plugin on

"########################## JavaScript
autocmd Filetype javascript setlocal ts=2 sw=2 sts=0 suffixesadd=.js,.jsx
autocmd Filetype javascript highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd Filetype javascript match OverLength /\%121v.\+/

"########################## TypeScript
autocmd Filetype typescript setlocal ts=2 sw=2 sts=0 suffixesadd=.ts,.tsx
autocmd Filetype typescript highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd Filetype typescript match OverLength /\%121v.\+/
autocmd Filetype typescriptreact setlocal ts=4 sw=4 sts=0 suffixesadd=.ts,.tsx
autocmd Filetype typescriptreact highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd Filetype typescriptreact match OverLength /\%121v.\+/

" TSX files get mapped as typescriptreact
let g:tagbar_type_typescriptreact = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'C:const',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }
"########################## Python

autocmd BufRead python
    \ setlocal tabstop=4
    \ setlocal softtabstop=4
    \ setlocal shiftwidth=4
    \ setlocal textwidth=79
    \ setlocal expandtab
    \ setlocal autoindent
    \ setlocal fileformat=unix

" vim-jedi's tips can get in the way; turn them off temporarily
autocmd FileType python imap <C-j> <ESC>:let g:jedi#show_call_signatures=0<CR>a
autocmd InsertLeave * :let g:jedi#show_call_signatures=1

"########################## Other_filetypes
autocmd Filetype markdown setlocal spell linebreak textwidth=0 cc=0 conceallevel=3 formatoptions+=ro
autocmd BufNewFile,BufRead Dockerfile* set syntax=dockerfile

" See https://vim.fandom.com/wiki/Folding_for_plain_text_files_based_on_indentation
" Used in conjunction with https://github.com/obreitwi/vim-sort-folds to sort blocks
autocmd Filetype text setlocal linebreak spell complete+=s wrap
      \ noexpandtab textwidth=0 cc=0 formatoptions=qtc1
      \ setlocal foldmethod=expr
      \ setlocal foldexpr=(getline(v:lnum)=~'^$')?-1:((indent(v:lnum)<indent(v:lnum+1))?('>'.indent(v:lnum+1)):indent(v:lnum))
      \ set foldtext=getline(v:foldstart)
      \ set fillchars=fold:\ "(there's a space after that \)
      \ highlight Folded ctermfg=DarkGreen ctermbg=Black

autocmd BufRead COMMIT_EDITMSG setlocal spell

"###### Hyper-aggressive "indent" folding
" See https://vim.fandom.com/wiki/Folding_for_plain_text_files_based_on_indentation
" Used in conjunction with https://github.com/obreitwi/vim-sort-folds to sort blocks
"setlocal foldmethod=expr
"setlocal foldexpr=(getline(v:lnum)=~'^$')?-1:((indent(v:lnum)<indent(v:lnum+1))?('>'.indent(v:lnum+1)):indent(v:lnum))
"set foldtext=getline(v:foldstart)
"set fillchars=fold:\ "(there's a space after that \)
"highlight Folded ctermfg=DarkGreen ctermbg=Black

"############################## References ###########
" Functions guides
" https://developer.ibm.com/technologies/linux/tutorials/l-vim-script-2/
" https://learnvimscriptthehardway.stevelosh.com/chapters/23.html
"
" Using counts in mappings
" https://jdhao.github.io/2019/04/29/nvim_map_with_a_count/
"
" WSL copy/paste trick!
" https://superuser.com/questions/1291425/windows-subsystem-linux-make-vim-use-the-clipboard

" Status line/WordCount
" https://cromwell-intl.com/open-source/vim-word-count.html
" https://github.com/vim-airline/vim-airline
"
" Example of dynamic vs. static environment variables
" https://vi.stackexchange.com/questions/16071/how-can-i-use-a-string-variables-for-filepath-in-vimscript-map-command
"
" Comments on mapping lines
" https://stackoverflow.com/questions/24716804/inline-comments-in-vimrc-mappings
"
" vim working path
" http://inlehmansterms.net/2014/09/04/sane-vim-working-directories/
