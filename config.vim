" config.vim

let mapleader = ","

set nocompatible
set number                " Show numbers on the left
set hlsearch              " Highlight search results
set ignorecase            " Search ingnoring case
set smartcase             " Do not ignore case if the search patter has uppercase
set noerrorbells          " I hate bells
set tabstop=4             " Tab size of 4 spaces
set softtabstop=4         " On insert use 4 spaces for tab
set shiftwidth=4
set expandtab             " Use apropiate number of spaces
set nowrap                " Wrapping sucks (except on markdown)
autocmd BufRead,BufNewFile *.md setlocal wrap " DO wrap on markdown files
set noswapfile            " Do not leve any backup files
set mouse=a               " Enable mouse on all modes
set clipboard=unnamed     " Use the OS keyboard
set showmatch

" Keep VisualMode after indent with > or <
vmap < <gv 
vmap > >gv 

" Move Visual blocks with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Install vim-plug for vim and neovim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  silent !mkdir -p ~/.config/nvim/autoload/ && ln -s ~/.vim/autoload/plug.vim ~/.config/nvim/autoload/
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'         " Sensible defaults

Plug 'kaicataldo/material.vim'    " Material themes
Plug 'morhetz/gruvbox'            " Retro colors theme
Plug 'haishanh/night-owl.vim'     " A 'night friendly` theme
Plug 'drewtempelmeyer/palenight.vim'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }           " File navigator
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'           " Enable fuzzy finder in Vim
Plug 'jiangmiao/auto-pairs'       " Insert or delete brackets, parens, quotes, etc.

Plug 'neoclide/coc.nvim', { 'branch': 'release' } " Intelisense

Plug 'liuchengxu/vim-which-key'
call plug#end()

colorscheme material " Activate the Material theme

noremap <C-k><C-p> :NERDTreeToggle<cr> " Use Ctrl-K Ctrl-P to open a sidebar with the list of files

nnoremap <C-p> :Files<cr>              " Use Ctrl-P to open the fuzzy file opener


let g:coc_global_extensions = [
    \ 'coc-tsserver',
    \ 'coc-json',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-phpls',
    \ 'coc-python'
    \]

source ./coc.vim

" WhichKey
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

