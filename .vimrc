" Name:     dot vimrc config - Reasonable, Readable, Reliable(Ever for ordinary people)
" Author:   ashfinal <ashfinal@gmail.com>
" URL:      https://github.com/macplay
" License:  MIT license
" Created:  June 01, 2015
" Modified: February 14, 2016

" General {{{ "

" Environment - Encoding, Indent, Fold {{{ "

set nocompatible     " be iMproved, required

if !isdirectory(expand("~/.vim/"))
    call mkdir($HOME . "/.vim")
endif

set title
set ttyfast    " Improves smoothness of redrawing

" Don't redraw while executing macros (good performance config)
set lazyredraw

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

set t_ti= t_te=      " put terminal in 'termcap' mode

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" Enable clipboard if possible, and use
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" Ctrl-t: copy the full path of the current file to the clipboard
nmap <silent> <C-t> :let @+=expand("%:p")<CR>:echo "Copied current file
    \ path '".expand("%:p")."' to clipboard"<CR>

set selection=exclusive
set selectmode=mouse,key

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

set fileencodings=ucs-bom,utf-8,cp936,gb2312,big5,euc-jp,euc-kr,latin1

" Set terminal encoding
set termencoding=utf-8

" Use Unix as the standard file type
set fileformats=unix,mac,dos

set ambiwidth=double

" Also break at a multi-byte character above 255
set formatoptions+=m
" When joining lines, don't insert a space between two multi-byte characters
set formatoptions+=B

set autoindent    " Auto indent
set smartindent    " Smart indent

filetype on
filetype plugin on
filetype plugin indent on

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set expandtab    " Use spaces instead of tabs

set wrap    " Wrap lines

" Linebreak on 80 characters
" set linebreak
" set textwidth=80

set showbreak=+++     " show softwarpped continuing line
set whichwrap+=<,>,h,l,[,]

" Use these symbols for invisible chars
set listchars=tab:¦\ ,eol:¬,trail:⋅,extends:»,precedes:«

set foldenable

" Add a bit extra margin to the left
set foldcolumn=1

" }}} Environment - Encoding, Indent, Fold "

" Appearence - Scrollbar, Highlight, Numberline {{{ "

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Enable syntax highlighting
syntax enable

set shortmess=aoOtTI     " Abbrev. of messages

" Highlight current line
set cursorline

" the mouse pointer is hidden when characters are typed
set mousehide

" Always show current position
set ruler

" Always show linenumber
set number relativenumber
" Use absolute linenum in Insert mode; relative linenum in Normal mode
autocmd FocusLost,InsertEnter *
    \ if exists('#goyo') |
    \    exe "set nonumber norelativenumber" |
    \ else |
    \    exe "set number norelativenumber" |
    \ endif

autocmd FocusGained,InsertLeave *
    \ if exists('#goyo') |
    \    exe "set nonumber norelativenumber" |
    \ else |
    \    exe "set number relativenumber" |
    \endif

" Turn spell check off
set nospell

" Height of the command bar
set cmdheight=1
" Turn on the Wild menu
set wildmenu
set wildmode=list:longest,full
" Ignore compiled files
set wildignore=*.o,*.swp,*.bak,*.pyc,*.pyo,*.class,*.zip
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" }}} Appearence - Scrollbar, Highlight, Numberline "

" Edit - Navigation, History, Search {{{ "

" Map ; to : and save a million keystrokes
map ; :

" Map jj to enter normal mode
imap jj <Esc>

" Make cursor always on center of screen
nmap <silent> j gjzz
nmap <silent> k gkzz

" With a map leader it's possible to do extra key combinations
let mapleader = ","

set virtualedit=onemore

" How many lines to scroll at a time, make scrolling appears faster
set scrolljump=3

set viewoptions=folds,cursor,unix,slash     " Better Unix / Windows compatibility
" Save workspace and try to restore last session
set sessionoptions=buffers,curdir,tabpages
autocmd VimLeave * exe ":mksession! ~/.vim/.last.session"
" autocmd VimEnter *
   " \ if filereadable(expand("~/.vim/.last.session")) |
   " \   exe ":source ~/.vim/.last.session" |
   " \ endif
if filereadable(expand("~/.vim/.last.session"))
    nmap <silent> <Leader>r :source ~/.vim/.last.session<CR>
endif

set completeopt=menu,preview,longest
set pumheight=10
" automatically open and close the popup menu / preview window
autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" Set to auto read when a file is changed from the outside
set autoread

set autowrite    " Automatically write a file when leaving a modified buffer
set updatetime=200

" Sets how many lines of history VIM has to remember
set history=1000     " command line history
set undoreload=1000

" Turn backup off, since most stuff is in SVN, git etc anyway...
set nobackup
set nowritebackup
set noswapfile

" Turn persistent undo on, means that you can undo even when you close a buffer/VIM
set undofile
set undolevels=1000

if !isdirectory(expand("~/.vim/undotree"))
    call mkdir($HOME . "/.vim/undotree", "p")
endif
set undodir=~/.vim/undotree

" For regular expressions turn magic on
set magic

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch
" set nowrapscan    " Don't wrap around when jumping between search result

"Keep search pattern at the center of the screen."
nmap <silent> n nzz
nmap <silent> N Nzz
nmap <silent> * *zz
nmap <silent> # #zz

" Disable highlight when <Space> is pressed
map <silent> <Space> :nohlsearch<CR>

" }}} Edit - Navigation, History, Search "

" Buffer - BufferSwitch, FileExplorer, StatusLine {{{ "

" A buffer becomes hidden when it is abandoned
set hidden

" Open "FileExplorer" with the current buffer's path
" Super useful when editing files in the same directory
set autochdir   " change current working directory automatically
let g:netrw_liststyle = 3
let g:netrw_winsize = 30
let g:netrw_list_hide = '^\..*$'
nmap <silent> <Leader>e :Vexplore <C-r>=expand("%:p:h")<CR>/<CR>

" Specify the behavior when switching between buffers
set switchbuf=useopen,usetab,newtab
set showtabline=1

set splitright    " Puts new vsplit windows to the right of the current
set splitbelow    " Puts new split windows to the bottom of the current

" Split management
nmap <Leader>m <C-w>_<C-w><Bar> " maximize split
nmap <silent> <Tab> :bnext<CR>
nmap <silent> <S-Tab> :bprevious<CR>
nmap <silent> <C-k> :exe "resize " . (winheight(0) * 3/2)<CR>
nmap <silent> <C-j> :exe "resize " . (winheight(0) * 2/3)<CR>
nmap <silent> <C-h> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nmap <silent> <C-l> :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
" autocmd vimResized * exe "normal! \<C-w>="

" always show status line
set laststatus=2

" }}} Buffer - BufferSwitch, FileExplorer, StatusLine "

" Key Mappings {{{ "

" Bash like keys for the command line
cnoremap <C-a> <home>
cnoremap <C-e> <end>

" Ctrl-[hl]: Move left/right by word
cnoremap <C-h> <S-left>
cnoremap <C-l> <S-right>

" Ctrl-a: Go to begin of line
inoremap <C-a> <esc>I

" Ctrl-e: Go to end of line
inoremap <C-e> <esc>A

" Ctrl-a: Go to begin of line
inoremap <C-a> <esc>I

" Ctrl-f: Move cursor right
inoremap <C-f> <Right>

" Ctrl-b: Move cursor left
inoremap <C-b> <Left>

" Ctrl-h: Move word left
inoremap <C-h> <C-o>b

" Ctrl-l: Move word right
inoremap <C-l> <C-o>e

" Ctrl-k: Move cursor up
inoremap <C-k> <Up>

" Ctrl-j: Move cursor down
inoremap <C-j> <Down>

" }}} Key Mappings "

" Misc {{{ "

set showcmd

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" Define how to use the CTRL-A and CTRL-X commands for adding to and subtracting from a number respectively
set nrformats=alpha,octal,hex

autocmd ColorScheme * call matchadd('Todo', '\W\zs\(NOTICE\|WARNING\|DANGER\)')

" Find out to which highlight-group a particular keyword/symbol belongs
nnoremap <silent> <C-c> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
    \ "> trans<" . synIDattr(synID(line("."),col("."),0),"name") .
    \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
    \ "> fg:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

nnoremap <silent> <Leader>s :call StripWSandBL()<CR>
" Strip Trailing whitespace and blank line of EOF when saving files
autocmd FileType php,html,javascript,css,python,xml,yml,markdown autocmd BufWritePre <buffer> :call StripWSandBL()
function! StripWSandBL()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    %s/\(\n^$\)\+\%$//ge
    call cursor(l, c)
endfunction

nnoremap <silent> <Leader>t :call ToggleTabandSpace()<CR>
function! ToggleTabandSpace()
    set list
    set expandtab!
    retab! 4
endfunction

nnoremap <silent> <Leader>x :setlocal modifiable!<CR>
nnoremap <silent> <Leader>l :setlocal list!<CR>
nnoremap <silent> <Leader>w :setlocal wrap!<CR>

" Make TOhtml behavior better
let g:html_dynamic_folds = 1
let g:html_prevent_copy = "fntd"

" Make search results can be foldable
nnoremap <silent> <Leader>z :call ToggleSearchFold()<CR>
function! ToggleSearchFold()
    if !exists("b:hasSearchFold") || (b:hasSearchFold == 0)
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2
        setlocal foldmethod=expr
        setlocal foldlevel=0
        let b:hasSearchFold=1
        setlocal foldmethod=manual
    else
        setlocal foldlevel=100
        let b:hasSearchFold=0
    endif
endfunction

" Toggle foldmethod
nnoremap <silent> <Leader><Space> :call ToggleFoldMethod()<CR>
function! ToggleFoldMethod()
    if (&foldmethod == "indent")
        set foldmethod=manual
        echo "Foldmethod: manual"
    elseif (&foldmethod == "manual")
        set foldmethod=syntax
        echo "Foldmethod: syntax"
    elseif (&foldmethod == "syntax")
        set foldmethod=marker
        echo "Foldmethod: marker"
    elseif (&foldmethod == "marker")
        set foldmethod=expr
        echo "Foldmethod: expr"
    elseif (&foldmethod == "expr")
        set foldmethod=diff
        echo "Foldmethod: diff"
    else
        set foldmethod=indent
        echo "Foldmethod: indent"
    endif
endfunction

autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown set filetype=markdown

" Use ~/.vimrc.local if exists
if filereadable(expand("~/.vimrc.local"))
    source $HOME/.vimrc.local
endif

" }}} Misc "

" }}} General "

" Plugins Config {{{ "

" Plugin List {{{ "

if !filereadable(expand("~/.vim/autoload/plug.vim"))
    exe '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'mbbill/undotree'
Plug 'mattn/emmet-vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'tpope/vim-surround'
Plug 'Lokaltog/vim-easymotion'
Plug 'kshenoy/vim-signature'
Plug 'scrooloose/nerdcommenter'
Plug 'Raimondi/delimitMate'
Plug 'Shougo/neocomplete.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'tsaleh/vim-align'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/YankRing.vim'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'dhruvasagar/vim-table-mode'
Plug 'reedes/vim-colors-pencil'

call plug#end()

if filereadable(expand("~/.vim/plugged/vim-colors-pencil/colors/pencil.vim"))
    colorscheme pencil
endif

" }}} Plugin List "

" Plugin Config - undotree {{{ "

let g:undotree_SplitWidth = 40
let g:undotree_SetFocusWhenToggle = 1
nmap <silent> U :UndotreeToggle<CR>

" }}} Plugin Config - undotree "

" Plugin Config - vim-easymotion {{{ "

let g:EasyMotion_smartcase = 1
let g:EasyMotion_use_smartsign_us = 1
map <Leader> <Plug>(easymotion-prefix)
nmap f <Plug>(easymotion-s)
nmap t <Plug>(easymotion-s)
nmap T <Plug>(easymotion-sn)
nmap F <Plug>(easymotion-sn)

" }}} Plugin Config - vim-easymotion "

" Plugin Config - ultisnips {{{ "

let g:UltiSnipsExpandTrigger = "ii"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
let g:UltiSnipsEditSplit = "context"
if !isdirectory(expand("~/.vim/UltiSnips"))
    call mkdir($HOME . "/.vim/UltiSnips", "p")
endif
let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"

" }}} Plugin Config - ultisnips "

" Plugin Config - emmet-vim {{{ "

let g:user_emmet_install_global = 0
autocmd FileType html,css,markdown,php EmmetInstall
let g:user_emmet_leader_key = ','

" }}} Plugin Config - emmet-vim "

" Plugin Config - neocomplete {{{ "

let g:neocomplete#enable_at_startup = 1

" }}} Plugin Config - neocomplete "

" Plugin Config - nerdcommenter {{{ "

" Always leave a space between the comment character and the comment
let NERDSpaceDelims = 1
map <Bslash> <plug>NERDCommenterInvert
vmap <C-Bslash> <plug>NERDCommenterSexy

" }}} Plugin Config - nerdcommenter "

" Plugin Config - Goyo & Limelight {{{ "

function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    set nocursorline
    set foldcolumn=0
endfunction

function! s:goyo_leave()
    set showmode
    set showcmd
    set cursorline
    set foldcolumn=1
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Goyo.vim integration
let g:limelight_conceal_ctermfg = 250
let g:limelight_default_coefficient = 0.8
autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

" }}} Plugin Config - Goyo & Limelight "

" Plugin Config - JsBeautify {{{ "
if executable('node')
    autocmd FileType javascript noremap <buffer> <Leader>js :call JsBeautify()<CR>
    autocmd FileType html noremap <buffer> <Leader>js :call HtmlBeautify()<CR>
    autocmd FileType css noremap <buffer> <Leader>js :call CSSBeautify()<CR>
endif

" }}} Plugin Config - JsBeautify "

" Plugin Config - CtrlP {{{ "

let g:ctrlp_map = '<Leader>o'
let g:ctrlp_cmd = 'CtrlPBuffer'

" }}} Plugin Config - CtrlP "

" Plugin Config - YankRing {{{ "

nmap <silent> <Leader>y :YRShow<CR>
let g:yankring_min_element_length = 3
let g:yankring_replace_n_pkey = '<C-p>'
let g:yankring_replace_n_nkey = '<C-n>'
if !isdirectory(expand("~/.vim/yankring"))
    call mkdir($HOME . "/.vim/yankring", "p")
endif
let g:yankring_history_dir = '~/.vim/yankring/'

" }}} Plugin Config - YankRing "

" Plugin Config - vim-align {{{ "

nmap <Leader>g :AlignCtrl<Space>
vmap gl :Align<Space>

" }}} Plugin Config - vim-align "

" Plugin Config - tablemode {{{ "

let g:table_mode_corner="|"
let g:table_mode_align_char=":"

" }}} Plugin Config - tablemode "

" Plugin Config - airline {{{ "

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" }}} Plugin Config - airline "

" }}} Plugins Config "

" vim:set et sw=4 ts=4 tw=80 fdm=marker fdl=1:
