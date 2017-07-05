" Name:     re-vim: Lightweight, extensible vim configuration
" Author:   ashfinal <ashfinal@gmail.com>
" URL:      https://github.com/ashfinal
" License:  MIT license

" Use ~/.vimrc.before if exists
if filereadable(expand("~/.vimrc.before"))
    source $HOME/.vimrc.before
endif

" General {{{ "

" Environment - Encoding, Indent, Fold {{{ "

set nocompatible " be iMproved, required

if !isdirectory(expand("~/.vim/"))
    call mkdir($HOME . "/.vim")
endif

if has('win32') || has('win64')
    set runtimepath+=$HOME/.vim
endif

set title
set ttyfast " Improves smoothness of redrawing

" Don't redraw while executing macros (good performance config)
set lazyredraw

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=

set t_Co=256 " using 256 colors
set t_ti= t_te= " put terminal in 'termcap' mode
set guicursor+=a:blinkon0 " no cursor blink

" Configure backspace so it acts as it should act
set backspace=eol,start,indent

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a

" Enable clipboard if possible
if has('clipboard')
    if has('unnamedplus') " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" Set terminal encoding
set termencoding=utf-8

" Use Unix as the standard file type
set fileformats=unix,mac,dos

set ambiwidth=double

" Also break at a multi-byte character above 255
set formatoptions+=m
" When joining lines, don't insert a space between two multi-byte characters
set formatoptions+=B

set autoindent " Auto indent
set smartindent " Smart indent

filetype on
filetype plugin on
filetype plugin indent on

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set smarttab

set expandtab " Use spaces instead of tabs

set wrap " Wrap lines

" set iskeyword+=-
set whichwrap+=<,>,h,l,[,]
" clear split fillchar
set fillchars=vert:\ 
" Use these symbols for invisible chars
set listchars=tab:¦\ ,eol:¬,trail:⋅,extends:»,precedes:«

set foldlevel=100 " unfold all by default

" }}} Environment - Encoding, Indent, Fold "

" Appearence - Scrollbar, Highlight, Numberline {{{ "

" Disable scrollbars (real hackers don't use scrollbars for navigation!)
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" Customize gui fontfamily and fontsize
" if has("gui_running")
    " set guifont=Inziu_Iosevka_Slab_SC:h12
" endif

" Enable syntax highlighting
syntax enable

" Use desert colorscheme by default
" colorscheme desert

" Use light background under macos and GUI
if has('mac') || has('gui_running')
    set background=light
endif

set shortmess=aoOtTI " Abbrev. of messages

" Highlight current line
set cursorline

" the mouse pointer is hidden when characters are typed
set mousehide

" Always show current position
set ruler

" Show linenumber by default
if !exists('g:noshowlinenumber')
    set number relativenumber
else
    set nonumber norelativenumber
endif

" Use absolute linenum in Insert mode; relative linenum in Normal mode
autocmd FocusLost,InsertEnter * :call UseAbsNum()
autocmd FocusGained,InsertLeave * :call UseRelNum()

function! UseAbsNum()
    if exists('g:noshowlinenumber') || exists('#goyo')
        set nonumber norelativenumber
    else
        set number norelativenumber
    endif
endfunction

function! UseRelNum()
    if exists('g:noshowlinenumber') || exists('#goyo')
        set nonumber norelativenumber
    else
        set number relativenumber
    endif
endfunction

" Turn spell check off
set nospell

" Height of the command bar
set cmdheight=1
" Turn on the Wild menu
set wildmenu
set wildmode=list:longest,full
" Ignore compiled files
set wildignore=*.o,*.swp,*.bak,*.pyc,*.pyo,*.class,*.zip
if has("win32") || has("win64")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" }}} Appearence - Scrollbar, Highlight, Numberline "

" Edit - Navigation, History, Search {{{ "

" Map ; to : and save a million keystrokes
map ; :

" Map jk to enter normal mode
imap jk <Esc>

" Make cursor always on center of screen by default
if !exists('noalwayscenter')
    " Calculate proper scrolloff
    autocmd VimEnter,WinEnter,VimResized,InsertLeave * :let &scrolloff = float2nr(floor(winheight(0)/2)+1)
    autocmd InsertEnter * :let &scrolloff = float2nr(floor(winheight(0)/2))
    " Use <Enter> to keep center in insert mode, need proper scrolloff
    inoremap <CR> <CR><C-o>zz
endif

" Make moving around works well in multi lines
nmap <silent> j gj
nmap <silent> k gk

" With a map leader it's possible to do extra key combinations
let mapleader = ","

set virtualedit=onemore

" How many lines to scroll at a time, make scrolling appears faster
" set scrolljump=3

set viewoptions=folds,cursor,unix,slash " Better Unix / Windows compatibility
" Save workspace and try to restore last session
set sessionoptions=buffers,curdir,tabpages
autocmd VimLeave * exe ":mksession! ~/.vim/.last.session"

" Restore last session automatically (Default Off)
autocmd VimEnter * :call RestoreLastSession()
function! RestoreLastSession()
    if exists('g:restorelastsession')
        if filereadable(expand("~/.vim/.last.session"))
           exe ":source ~/.vim/.last.session"
       endif
   endif
endfunction

if filereadable(expand("~/.vim/.last.session"))
    nmap <silent> <Leader>r :source ~/.vim/.last.session<CR>
endif

set completeopt=menu,preview,longest
set pumheight=10
" automatically open and close the popup menu / preview window
if !exists('g:noautoclosepum')
    autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
endif

inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     exe "normal! g`\"" |
            \ endif

" Set to auto read when a file is changed from the outside
set autoread

set autowrite " Automatically write a file when leaving a modified buffer
set updatetime=200

" Set how many lines of history VIM has to remember
set history=1000 " command line history
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
" set nowrapscan " Don't wrap around when jumping between search result

" Disable highlight when <Enter> is pressed
nnoremap <silent> <BS> :nohlsearch<CR>

" }}} Edit - Navigation, History, Search "

" Buffer - BufferSwitch, FileExplorer, StatusLine {{{ "

" A buffer becomes hidden when it is abandoned
set hidden

set autochdir " change current working directory automatically

" Specify the behavior when switching between buffers
set switchbuf=useopen
set showtabline=1

set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current

" Split management
nnoremap <silent> [b :bprevious<cr>
nnoremap <silent> ]b :bnext<cr>
nmap <silent> <C-k> :exe "resize " . (winheight(0) * 3/2)<CR>
nmap <silent> <C-j> :exe "resize " . (winheight(0) * 2/3)<CR>
nmap <silent> <C-h> :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nmap <silent> <C-l> :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" Always show status line
set laststatus=2
set statusline=%<%f\ " filename
set statusline+=%w%h%m%r " option
set statusline+=\ [%{&ff}]/%y " fileformat/filetype
set statusline+=\ [%{getcwd()}] " current dir
set statusline+=\ [%{&encoding}] " encoding
set statusline+=%=%-14.(%l/%L,%c%V%)\ %p%% " Right aligned file nav info

" }}} Buffer - BufferSwitch, FileExplorer, StatusLine "

" Key Mappings {{{ "

" Bash like keys for the command line
cnoremap <C-a> <Home>

" Ctrl-[hl]: Move left/right by word
cnoremap <C-h> <S-Left>
cnoremap <C-l> <S-Right>

" Ctrl-[bf]: I don't use <C-b> to open mini window often
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" Ctrl-a: Go to begin of line
inoremap <C-a> <Home>

" Ctrl-e: Go to end of line
inoremap <C-e> <End>

" Ctrl-[bf]: Move cursor left/right
inoremap <C-b> <Left>
inoremap <C-f> <Right>

" Ctrl-[hl]: Move left/right by word
inoremap <C-h> <S-Left>
inoremap <C-l> <S-Right>

" Ctrl-[kj]: Move cursor up/down
inoremap <C-k> <C-o>gk
inoremap <C-j> <C-o>gj

" Ctrl-[kj]: Move lines up/down
" nnoremap <silent> <C-j> :m .+1<CR>==
" nnoremap <silent> <C-k> :m .-2<CR>==
" inoremap <silent> <C-j> <Esc>:m .+1<CR>==gi
" inoremap <silent> <C-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
vnoremap <silent> <C-k> :m '<-2<CR>gv=gv

" }}} Key Mappings "

" Misc {{{ "

set noshowcmd

" vertical diffsplit
set diffopt+=vertical

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" Define how to use the CTRL-A and CTRL-X commands for adding to and subtracting from a number respectively
set nrformats=alpha,octal,hex

" For when you forget to sudo... Really Write the file.
if !(has('win32') || has('win64')) && !has("gui_running")
    command! W w !sudo tee % > /dev/null
endif

autocmd ColorScheme * call matchadd('Todo', '\W\zs\(NOTICE\|WARNING\|DANGER\)')

" Find out to which highlight-group a particular keyword/symbol belongs
command! Wcolor echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
            \ "> trans<" . synIDattr(synID(line("."),col("."),0),"name") .
            \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
            \ "> fg:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")

nnoremap <silent> <Leader>b :call ToggleBackground()<CR>
function! ToggleBackground()
    if &background == "light"
        set background=dark
    else
        set background=light
    endif
endfunction

" Toggle showing softwarpped continuing line
nnoremap <silent> <Leader>k :call ToggleShowbreak()<CR>
function! ToggleShowbreak()
    if &showbreak == ""
        set showbreak=+++
    else
        set showbreak=
    endif
endfunction

" Toggle showing colorcolumn over the textwidth
nnoremap <silent> <Leader>c :call ToggleColorcolumn()<CR>
function! ToggleColorcolumn()
    if &colorcolumn == ""
        if &textwidth == 0
            let &colorcolumn = 80
        else
            let &colorcolumn = &textwidth
        endif
    else
        let &colorcolumn = ""
    endif
endfunction

" Toggle showing linenumber
nnoremap <silent> <Leader>n :call ToggleNumberline()<CR>
function! ToggleNumberline()
    if !exists('g:noshowlinenumber')
        set nonumber norelativenumber
        let g:noshowlinenumber = 1
    else
        set number relativenumber
        unlet g:noshowlinenumber
    endif
endfunction

nnoremap <silent> <Leader>m :call ToggleFoldcolumn()<CR>
function! ToggleFoldcolumn()
    if &foldcolumn == 1
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=1
    endif
endfunction

nnoremap <silent> <Leader>f :call ToggleFileformat()<CR>
function! ToggleFileformat()
    if (&fileformat == "dos")
        set fileformat=mac
        echo "Fileformat: mac"
    elseif (&fileformat == "mac")
        set fileformat=unix
        echo "Fileformat: unix"
    else
        set fileformat=dos
        echo "Fileformat: dos"
    endif
endfunction

autocmd FileType python setlocal foldmethod=indent textwidth=80
autocmd BufNewFile,BufRead *.org setlocal filetype=org commentstring=#%s
autocmd BufNewFile,BufRead *.tex setlocal filetype=tex
autocmd FileType markdown,rst,org :silent TableModeEnable

" Strip Trailing spaces and blank lines of EOF when saving files
if !exists('g:noautostripspaces')
    autocmd FileType html,javascript,css,python,markdown,rst autocmd BufWritePre <buffer> :call StripWSBL()
end

nnoremap <silent> <Leader>s :call StripWSBL()<CR>
function! StripWSBL()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//ge
    %s/\(\n^$\)\+\%$//ge
    call cursor(l, c)
endfunction

" YankOnce from unimpaired.vim
nnoremap <silent> yo :call YankOnce()<CR>o
function! YankOnce()
    let b:pastemode = &paste
    set paste
    autocmd InsertLeave *
                \ if exists('b:pastemode') |
                \     let &paste = b:pastemode |
                \     unlet b:pastemode |
                \ endif
endfunction

nnoremap <silent> <Leader>t :call ToggleTabSpace()<CR>
function! ToggleTabSpace()
    setlocal list
    if !exists('b:retabbed')
        setlocal noexpandtab
        retab!
        let b:retabbed = 1
    else
        setlocal expandtab
        retab
        unlet b:retabbed
    endif
endfunction

nnoremap <silent> <Leader>x :setlocal modifiable!<CR>
nnoremap <silent> <Leader>l :setlocal list!<CR>
nnoremap <silent> <Leader>w :setlocal wrap!<CR>
nnoremap <silent> <Leader>d :setlocal expandtab!<CR>
nnoremap <silent> <Leader>v :setlocal cursorline!<CR>

" Make TOhtml behavior better
let g:html_dynamic_folds = 1
let g:html_prevent_copy = "fntd"

" Make search results can be foldable
nnoremap <silent> <Leader>z :call ToggleSearchFold()<CR>
function! ToggleSearchFold()
    if !exists('b:fmstatus')
        let b:fmstatus = &foldmethod
        setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2
        setlocal foldmethod=expr
        setlocal foldlevel=0
        setlocal foldmethod=manual
    else
        setlocal foldlevel=100
        let &foldmethod = b:fmstatus
        unlet b:fmstatus
    endif
endfunction

" Toggle foldmethod
nnoremap <silent> <Leader><Space> :call ToggleFoldMethod()<CR>
function! ToggleFoldMethod()
    if (&foldmethod == "indent")
        setlocal foldmethod=manual
        echo "Foldmethod: manual"
    elseif (&foldmethod == "manual")
        setlocal foldmethod=syntax
        echo "Foldmethod: syntax"
    elseif (&foldmethod == "syntax")
        setlocal foldmethod=marker
        echo "Foldmethod: marker"
    elseif (&foldmethod == "marker")
        setlocal foldmethod=expr
        echo "Foldmethod: expr"
    elseif (&foldmethod == "expr")
        setlocal foldmethod=diff
        echo "Foldmethod: diff"
    else
        setlocal foldmethod=indent
        echo "Foldmethod: indent"
    endif
endfunction

" Toggle tmux statusline automatically
if exists('$TMUX')
    autocmd VimEnter,VimLeave * :silent !tmux set status
endif

" Better cursorshape handling under iterm2 and tmux. WARNING: need more test.
" if exists('$ITERM_SESSION_ID') && !exists('$TMUX')
    " let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    " let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    " let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" else
    " let &t_SI = "\<Esc>[6 q"
    " let &t_SR = "\<Esc>[4 q"
    " let &t_EI = "\<Esc>[2 q"
" endif

" }}} Misc "

" }}} General "

" Plugins List & Config {{{ "

" Plugin List {{{ "
if !exists('g:nouseplugmanager') " use plug.vim by default
    if filereadable(expand("~/.vim/autoload/plug.vim"))
        call plug#begin('~/.vim/plugged')

        Plug 'bling/vim-airline'
        if version >= 704 || version ==703 && has('patch005')
            Plug 'mbbill/undotree'
        endif
        Plug 'mattn/emmet-vim'
        Plug 'scrooloose/nerdtree'
        Plug 'dhruvasagar/vim-table-mode'
        if executable('node')
            Plug 'maksimr/vim-jsbeautify'
        endif
        if executable('ag')
            Plug 'gabesoft/vim-ags'
        end
        Plug 'tpope/vim-surround'
        Plug 'Lokaltog/vim-easymotion'
        Plug 'terryma/vim-multiple-cursors'
        Plug 'kshenoy/vim-signature'
        Plug 'scrooloose/nerdcommenter'
        Plug 'Raimondi/delimitMate'
        if version >= 704
            Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
        endif
        Plug 'ashfinal/vim-align'
        Plug 'junegunn/goyo.vim'
        Plug 'junegunn/limelight.vim'
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'vim-scripts/YankRing.vim'
        if version >= 704
            Plug 'airblade/vim-gitgutter'
        endif
        if executable('latexmk')
            Plug 'lervag/vimtex'
        end
        Plug 'metakirby5/codi.vim'
        Plug 'reedes/vim-colors-pencil'
        Plug 'ashfinal/vim-colors-paper'
        Plug 'ashfinal/vim-colors-violet'
        if has('nvim')
            if has('python3')
                Plug 'roxma/nvim-completion-manager'
                if executable('npm')
                    Plug 'roxma/nvim-cm-tern',  {'do': 'npm install'}
                end
            end
        else
            if version >= 703 && has('lua')
                Plug 'Shougo/neocomplete.vim'
            endif
            if executable('npm')
                Plug 'ternjs/tern_for_vim', {'do': 'npm install'}
            end
        endif
        if filereadable(expand("~/.vimrc.plug"))
            source $HOME/.vimrc.plug
        endif
        call plug#end()
    else
        if executable('git')
            if !isdirectory(expand("~/.vim/autoload"))
                call mkdir($HOME . "/.vim/autoload", "p")
            endif
            if has('python')
                exe 'py import os,urllib2; f = urllib2.urlopen("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"); g = open(os.path.join(os.path.expanduser("~"), ".vim/autoload/plug.vim"), "wb"); g.write(f.read())'
            else
                if has('python3')
                    exe 'py3 import os,urllib.request; f = urllib.request.urlopen("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"); g = open(os.path.join(os.path.expanduser("~"), ".vim/autoload/plug.vim"), "wb"); g.write(f.read())'
                else
                    exe "silent !echo 'let g:nouseplugmanager = 1' > ~/.vimrc.before"
                    echo "WARNING: plug.vim has been disabled due to the absence of 'python' or 'python3' features.\nIf you solve the problem and want to use it, you should delete the line with 'let g:nouseplugmanager = 1' in '.vimrc.before' file.\nIf you don't take any action, that's OK. This message won't appear again. For more infomation feel free to contact me."
                endif
            endif
            if filereadable(expand("~/.vim/autoload/plug.vim"))
                echo "PluginManager - plug.vim just installed! vim will quit now.\nYou should relaunch vim, use PlugInstall to install plugins OR do nothing just use the basic one."
                exe 'qall!'
            endif
        else
            exe "silent !echo 'let g:nouseplugmanager = 1' > ~/.vimrc.before"
            echo "WARNING: plug.vim has been disabled due to the absence of 'git'.\nIf you solve the problem and want to use it, you should delete the line with 'let g:nouseplugmanager = 1' in '.vimrc.before' file.\nIf you don't take any action, that's OK. This message won't appear again. For more infomation feel free to contact me."
        endif
    endif
endif

" }}} Plugin List "

" Plugin Config {{{ "

if !exists('g:nouseplugmanager') && filereadable(expand("~/.vim/autoload/plug.vim"))

    " Plugin Config - papercolorscheme {{{ "

    if filereadable(expand("~/.vim/plugged/vim-colors-paper/colors/paper.vim"))
        colorscheme paper
    endif

    " }}} Plugin Config - papercolorscheme "

    " Plugin Config - undotree {{{ "

    if filereadable(expand("~/.vim/plugged/undotree/plugin/undotree.vim"))
        let g:undotree_SplitWidth = 40
        let g:undotree_SetFocusWhenToggle = 1
        nmap <silent> <Leader>u :UndotreeToggle<CR>
    endif

    " }}} Plugin Config - undotree "

    " Plugin Config - vim-easymotion {{{ "

    if filereadable(expand("~/.vim/plugged/vim-easymotion/plugin/EasyMotion.vim"))
        let g:EasyMotion_smartcase = 1
        let g:EasyMotion_use_smartsign_us = 1
        map <Leader> <Plug>(easymotion-prefix)
        nmap <Space> <Plug>(easymotion-s)
    endif

    " }}} Plugin Config - vim-easymotion "

    " Plugin Config - vim-multiple-cursors {{{ "

    if filereadable(expand("~/.vim/plugged/vim-multiple-cursors/autoload/multiple_cursors.vim"))
        let g:multi_cursor_use_default_mapping = 0
        let g:multi_cursor_next_key = '+'
        let g:multi_cursor_prev_key = '_'
        let g:multi_cursor_skip_key = '-'
        let g:multi_cursor_quit_key = '<Esc>'
        function! Multiple_cursors_before()
            if exists(':NeoCompleteLock') == 2
                exe 'NeoCompleteLock'
            endif
        endfunction
        function! Multiple_cursors_after()
            if exists(':NeoCompleteUnlock') == 2
                exe 'NeoCompleteUnlock'
            endif
        endfunction
    endif

    " }}} Plugin Config - vim-multiple-cursors "

    " Plugin Config - ultisnips {{{ "

    if filereadable(expand("~/.vim/plugged/ultisnips/plugin/UltiSnips.vim"))
        let g:UltiSnipsExpandTrigger = "<Tab>"
        let g:UltiSnipsJumpForwardTrigger = "<Tab>"
        let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
        let g:UltiSnipsEditSplit = "context"
        if !isdirectory(expand("~/.vim/UltiSnips"))
            call mkdir($HOME . "/.vim/UltiSnips", "p")
        endif
        let g:UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
    endif

    " }}} Plugin Config - ultisnips "

    " Plugin Config - emmet-vim {{{ "

    if filereadable(expand("~/.vim/plugged/emmet-vim/plugin/emmet.vim"))
        let g:user_emmet_install_global = 0
        autocmd FileType html,css,markdown,php,javascript EmmetInstall
        let g:user_emmet_leader_key = ','
        let g:user_emmet_mode = 'iv'
    endif

    " }}} Plugin Config - emmet-vim "

    " Plugin Config - nerdtree {{{ "

    if filereadable(expand("~/.vim/plugged/nerdtree/autoload/nerdtree.vim"))
        nnoremap <silent> <Leader>e :NERDTree <C-r>=expand("%:p:h")<CR><CR>
    endif

    " }}} Plugin Config - nerdtree "

    " Plugin Config - vim-table-mode {{{ "

    if filereadable(expand("~/.vim/plugged/vim-table-mode/autoload/tablemode.vim"))

        let g:table_mode_auto_align = 0

        autocmd FileType markdown
                    \ let g:table_mode_corner = "|" |
                    \ let g:table_mode_corner_corner = "|" |
                    \ let g:table_mode_header_fillchar = "-" |
                    \ let g:table_mode_align_char = ":"
        autocmd FileType rst
                    \ let g:table_mode_corner = "+" |
                    \ let g:table_mode_corner_corner = "+" |
                    \ let g:table_mode_header_fillchar = "="
        autocmd FileType org
                    \ let g:table_mode_corner = "+" |
                    \ let g:table_mode_corner_corner = "|" |
                    \ let g:table_mode_header_fillchar = "-"
    endif

    " }}} Plugin Config - vim-table-mode "

    " Plugin Config - neocomplete {{{ "

    if filereadable(expand("~/.vim/plugged/neocomplete.vim/plugin/neocomplete.vim"))
        let g:neocomplete#enable_at_startup = 1
    else
        set omnifunc=syntaxcomplete#Complete
    endif

    " }}} Plugin Config - neocomplete "

    " Plugin Config - nerdcommenter {{{ "

    if filereadable(expand("~/.vim/plugged/nerdcommenter/plugin/NERD_commenter.vim"))
        " Always leave a space between the comment character and the comment
        let NERDSpaceDelims = 1
        map <Bslash> <plug>NERDCommenterInvert
        vmap <C-Bslash> <plug>NERDCommenterSexy
    endif

    " }}} Plugin Config - nerdcommenter "

    " Plugin Config - Goyo {{{ "

    if filereadable(expand("~/.vim/plugged/goyo.vim/plugin/goyo.vim"))
        nmap <silent> <C-w><Space> :Goyo<CR>
        function! s:goyo_enter()
            let b:fcstatus = &foldcolumn
            setlocal foldcolumn=0
        endfunction

        function! s:goyo_leave()
            let &foldcolumn = b:fcstatus
        endfunction

        autocmd! User GoyoEnter nested call <SID>goyo_enter()
        autocmd! User GoyoLeave nested call <SID>goyo_leave()
    endif

    " }}} Plugin Config - Goyo "

    " Plugin Config - Limelight {{{ "

    if filereadable(expand("~/.vim/plugged/limelight.vim/plugin/limelight.vim"))
        nmap <silent> <C-w><Enter> :Limelight!!<CR>
        let g:limelight_conceal_ctermfg = 250
        let g:limelight_default_coefficient = 0.8
    endif

    " }}} Plugin Config - Limelight "

    " Plugin Config - JsBeautify {{{ "

    if filereadable(expand("~/.vim/plugged/vim-jsbeautify/plugin/beautifier.vim"))
        autocmd FileType javascript noremap <buffer> <Leader>js :call JsBeautify()<CR>
        autocmd FileType html noremap <buffer> <Leader>js :call HtmlBeautify()<CR>
        autocmd FileType css noremap <buffer> <Leader>js :call CSSBeautify()<CR>
    endif

    " }}} Plugin Config - JsBeautify "

    " Plugin Config - CtrlP {{{ "

    if filereadable(expand("~/.vim/plugged/ctrlp.vim/plugin/ctrlp.vim"))
        let g:ctrlp_map = '<Leader>o'
        let g:ctrlp_cmd = 'CtrlPBuffer'
    endif

    " }}} Plugin Config - CtrlP "

    " Plugin Config - YankRing {{{ "

    if !isdirectory(expand("~/.vim/yankring"))
        call mkdir($HOME . "/.vim/yankring", "p")
    endif
    let g:yankring_history_dir = '~/.vim/yankring/'
    if filereadable(expand("~/.vim/plugged/YankRing.vim/plugin/yankring.vim"))
        nmap <silent> <Leader>y :YRShow<CR>
        let g:yankring_min_element_length = 3
        let g:yankring_replace_n_pkey = '<C-p>'
        let g:yankring_replace_n_nkey = '<C-n>'
    endif

    " }}} Plugin Config - YankRing "

    " Plugin Config - vim-align {{{ "

    if filereadable(expand("~/.vim/plugged/vim-align/plugin/AlignPlugin.vim"))
        map <Leader>g :Align<Space>
    endif

    " }}} Plugin Config - vim-align "

    " Plugin Config - airline {{{ "

    if filereadable(expand("~/.vim/plugged/vim-airline/plugin/airline.vim"))
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#fnamemod = ':t'
    endif

    " }}} Plugin Config - airline "

    " Plugin Config - vimtex {{{ "

    if filereadable(expand("~/.vim/plugged/vimtex/autoload/vimtex.vim"))
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif
        let g:neocomplete#sources#omni#input_patterns.tex =
            \ '\v\\%('
            \ . '\a*cite\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
            \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
            \ . '|hyperref\s*\[[^]]*'
            \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
            \ . '|%(include%(only)?|input)\s*\{[^}]*'
            \ . '|\a*(gls|Gls|GLS)(pl)?\a*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
            \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
            \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
            \ . '|usepackage%(\s*\[[^]]*\])?\s*\{[^}]*'
            \ . '|documentclass%(\s*\[[^]]*\])?\s*\{[^}]*'
            \ . '|\a*'
            \ . ')'
    endif

    " }}} Plugin Config - vimtex "

endif

" }}} Plugin Config "

" }}} Plugins List & Config "

" Use ~/.vimrc.after if exists
if filereadable(expand("~/.vimrc.after"))
    source $HOME/.vimrc.after
endif

" vim:set et sw=4 ts=4 fdm=marker fdl=1:
