" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

" Set terminal title
set title

" Allow backspacing over everything in insert mode
set bs=indent,eol,start	

"Set backup		" keep a backup file

" Read/write a .viminfo file, don't store morethan 50 lines of registers
set viminfo='20,\"50

" Keep 500 lines of command line history
set history=500

" Status line/command line stuff
set ruler
set number
highlight LineNr ctermfg=7
set showcmd
set lazyredraw
set laststatus=2
" Must edit these two together if %f is removed
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
let g:smartusline_string_to_highlight = '%f'

" Color scheme stuff (solarized)
" workaround for work terminal colors:
let g:solarized_termcolors=256 
set background=light
colorscheme solarized

" Search modifications
set ignorecase
set smartcase
set incsearch

" Set <leader> to comma for faster extra commands
let mapleader = ","
let g:mapleader = ","

" Fast Saving
nnoremap <leader>w :w!<CR>

" Fast unhighlighting of searches
nnoremap <leader>n :noh<CR>
nnoremap <leader>m :noh<CR>

" Quick escape from insert mode
inoremap kj <Esc>
inoremap KJ <Esc>

" No more "entering ex mode, type 'visual' to continue
noremap Q <Nop>

" Auto read when file is changed from outside
set autoread

" Enable filetype plugins
filetype plugin on
filetype indent on

" Enable mouse
set mouse=a

" Make tabs spaces and use smart tabs
set expandtab
set shiftwidth=4
set tabstop=4
set modeline

" Smart/Auto Indents
set ai
set smartindent
set wrap

" Wildmenu makes command line completion have a pop up
set wildmenu

" Buffers become hidden when abandoned
set hidden

"Scroll the page before cursor hits top/bottom
"set scrolloff=3

"Set listchars for when 'list' is set on
set listchars=eol:$,tab:>-,trail:_

"Turn off Error Bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" Python specific indentation
autocmd Filetype python setlocal ts=8 et sw=4 sts=4
" Make * and # searches work on selections in visual mode
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Set font for gvim
if has("gui_running")
  set guifont=Monospace\ Bold\ 12
endif

if &term=="xterm"
     set t_Co=256
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Helper Functions

function! CmdLine(str)
    .x. "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "" 
    elseif a:direction == 'gv' 
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/') 
    elseif a:direction == 'f' 
        execute "normal /" . l:pattern . ""
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

