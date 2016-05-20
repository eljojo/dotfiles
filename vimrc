"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible
filetype off " required for Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-sensible'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-rails'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-endwise'
Plugin 'vim-scripts/delimitMate.vim'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-bundler'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-commentary'
Plugin 'mustache/vim-mustache-handlebars'
Plugin 'elixir-lang/vim-elixir'
Plugin 'tpope/vim-surround'
Plugin 'bkad/CamelCaseMotion'
Plugin 'derekwyatt/vim-scala'
Plugin 'ngmy/vim-rubocop'
Plugin 'eapache/rainbow_parentheses.vim'
Plugin 'maxbrunsfeld/vim-yankstack'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

call vundle#end()
filetype plugin indent on

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set number      "show line numbers

"display tabs and trailing spaces
set list
set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

set wrap        "dont wrap lines
set linebreak   "wrap lines at convenient points

" using bash as shell so the PATH is set correctly
set shell=/bin/bash

" remap leader to ,
let mapleader = ","

if v:version >= 703
    "undo settings
    set undodir=~/.vim/undofiles
    set undofile

    set colorcolumn=+1 "mark the ideal max text width
endif

"default indent settings
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set autoindent

"turn on syntax highlighting
syntax on

"tell the term has 256 colors
set t_Co=256

"hide buffers when not displayed
set hidden

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" split windows
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>W :split<CR><C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"spell check when writing commit logs
autocmd filetype svn,*commit* setlocal spell

" red column at 80 characters
set colorcolumn=80

set wildignore+=tmp,storage

set encoding=utf-8
set ttyfast

set backupdir=~/.vim/backup
set directory=~/.vim/backup

" load NERDTree with ctrl+n
map <C-n> :NERDTreeToggle<CR>

" fixes editing the crontab
au BufEnter /private/tmp/crontab.* setl backupcopy=yes

" Run Rubocop with Leader+r
let g:vimrubocop_keymap = 0
nmap <Leader>r :RuboCop<CR>

" Enable RainbowParentheses
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Enable CamelCaseMotion
call camelcasemotion#CreateMotionMappings('<Leader>')

" load JSX in .js files
let g:jsx_ext_required = 0

" ignore node_modules with ctrl+p
set wildignore+=*/node_modules/*

" F13 for CtrlP
nnoremap <silent> <F13> :CtrlP<CR>
