"# Settings
"## Configuration
"## Foramtting
"## Look_and_Feel
"# Mappings
"## Common
"## Movement
"## Sizing
"## Others
"# Plugins
"# Diff_and_Merge
"# Editing_Tricks
"## Config_File_Hotkeys
"# Macros
"# Filetypes
"## JavaScript
"## TypeScript
"## Others
"# References

"############################## Settings ###########

"########################## Configuration
execute pathogen#infect()
syntax enable
set shell=zsh           " bring ZShell config in
let mapleader=","       " leader is comma
set spelllang=en        " English for spelling!
" New, better words!
set spellfile=$HOME/dotfiles/en.utf-8.add

"########################## Formatting
set tabstop=2           " number of visual spaces per TAB
set softtabstop=2       " number of spaces in tab when editing
set shiftwidth=2        " size of an "indent
set expandtab           " tabs are spaces
set showcmd             " Will display the command as it is typed
set smarttab            " find next tabstop and insert spaces until it

"########################## Look_and_Feel
set t_Co=256            " compatibility with tmux: 256 colors
colorscheme badwolf     " try it out
" take BG from term/tmux
hi Normal guibg=NONE ctermbg=NONE
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
set splitbelow          " Open new split windows UNDER current window
set splitright          " Open new vsplit windows RIGHT of current window
set switchbuf=split     " open new splits when using :sb, :cc, etc. (or Ag results)
set backspace=2         " Same as indent, eol, start, allows backspace essentially anywhere in insert mode
set modeline            " Allows files to define some variables (e.g., filetype)
set cc=120              " highlights characters over 120 width

" Extra whitespace in yellow
highlight ExtraWhitespace ctermbg=yellow ctermfg=white guibg=#592929 " Define color scheme
match ExtraWhitespace /\s\+\%#\@<!$/ " Define match set
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/ " Run on Window enter
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/ " Run on insert enter (this plus next makes screen not flash)
autocmd InsertLeave * match ExtraWhitespace /\s\+$/ " Run on exiting Insert Mode (only trailing)
autocmd BufWinLeave * call clearmatches() " Run on leaving window (Clear all the matches)

"############################## Mappings ###########

"########################## Common
" jk is escape
inoremap jk <esc>

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

"########################## Others
" Show count of last find
nnoremap <leader>/ :%s///gn<CR>
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
" TagBar
nnoremap <leader>. :TagbarToggle<CR>
" ZoomWin (fullscreen toggle)
nnoremap <leader><Enter> <C-w>o

" Note: intentional trailing space on these comamnds
" open Silver Searcher - Close window with :ccl(ose)
nnoremap <leader>a :Ag! 
" Z for Vim!
nnoremap <leader>z :Z 

" CtrlP settings
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"############################## Diff_and_Merge ###########

" Diff unsaved buffer against original
nnoremap <silent> <leader>d :DiffChangesDiffToggle<CR>
" Diff open windows
nnoremap <silent> <leader>D :windo diffthis<CR>
" Diff against git
nnoremap <leader>dg :call GitDiff()<cr>
" Opens mergetool
nmap <leader>mt <plug>(MergetoolToggle)

function GitDiff()
    :silent write
    :silent execute '!git diff --color=always -- ' . expand('%:p') . ' | less --RAW-CONTROL-CHARS'
    :redraw!
endfunction

"############################## Editing_Tricks  ###########

" enables Leader + y to do clipboard copy in visual mode (OSx)
vnoremap <silent> <leader>y :<CR>:let @a=@" \| execute "normal! vgvy" \| let res=system("pbcopy", @") \| let @"=@a<CR>
" enables Leader + h to set vim pwd on local buffer
nnoremap <silent> <leader>h :lcd %:p:h<CR>
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
map <silent> <leader>jg E:setlocal indentkeys-=<:><CR>a {color:#14892c}{color}jk7h:setlocal indentkeys+=<:><CR>a
map <silent> <leader>jr E:setlocal indentkeys-=<:><CR>a {color:#d04437}{color}jk7h:setlocal indentkeys+=<:><CR>a
map <silent> <leader>jo E:setlocal indentkeys-=<:><CR>a {color:#f79232}{color}jk7h:setlocal indentkeys+=<:><CR>a

" F5 does :e on each buffer, basically a "safe" refresh
nnoremap <F5> :bufdo e<CR>

"############################## Config_File_Hotkeys ###########
nnoremap <leader>ev :tabnew $MYVIMRC<CR>
nnoremap <silent> <leader>sv :source $MYVIMRC<CR>
nnoremap <leader>ez :tabnew ~/dotfiles/.zshrc<CR>:spl ~/dotfiles/.zshenv<CR>
nnoremap <leader>ej :tabnew ~/dotfiles/.jira.d/config.yml<CR>
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
filetype indent on      " load filetype-specific indent files

"########################## JavaScript
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 suffixesadd=.js,.jsx
autocmd Filetype javascript highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd Filetype javascript match OverLength /\%121v.\+/

"########################## TypeScript
" If you get errors, run the following command:
" npm install --global git+https://github.com/Perlence/tstags.git
autocmd Filetype typescript setlocal ts=2 sw=2 sts=0 suffixesadd=.ts,.tsx
autocmd Filetype typescript highlight OverLength ctermbg=red ctermfg=white guibg=#592929
autocmd Filetype typescript match OverLength /\%121v.\+/

let g:tagbar_type_typescript = {
  \ 'ctagsbin' : 'tstags',
  \ 'ctagsargs' : '-f-',
  \ 'kinds': [
    \ 'e:enums:0:1',
    \ 'f:function:0:1',
    \ 't:typealias:0:1',
    \ 'M:Module:0:1',
    \ 'I:import:0:1',
    \ 'i:interface:0:1',
    \ 'C:class:0:1',
    \ 'm:method:0:1',
    \ 'p:property:0:1',
    \ 'v:variable:0:1',
    \ 'c:const:0:1',
  \ ],
  \ 'sort' : 0
\ }

"########################## Others
autocmd Filetype markdown setlocal spell
autocmd Filetype text setlocal linebreak spell
autocmd BufRead COMMIT_EDITMSG setlocal spell

"############################## References ###########
" Functions guides
" https://developer.ibm.com/technologies/linux/tutorials/l-vim-script-2/
" https://learnvimscriptthehardway.stevelosh.com/chapters/23.html
"
" Using counts in mappings
" https://jdhao.github.io/2019/04/29/nvim_map_with_a_count/
