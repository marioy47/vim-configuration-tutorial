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
set termguicolors

" Keep VisualMode after indent with > or <
vmap < <gv
vmap > >gv
"
" Move Visual blocks with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'            " Sensible defaults
Plug 'drewtempelmeyer/palenight.vim'  " Soothing color scheme for your favorite [best] text editor
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " File navigator
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'               " Enable fuzzy finder in Vim
Plug 'editorconfig/editorconfig-vim'  " Tab/Space trough projects
Plug 'dense-analysis/ale'             " Check syntax in Vim asynchronously and fix files
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

colorscheme palenight                 " Activate the Palenight theme

" Use Ctrl-k Ctrl-p to open a sidebar with the list of files
map <C-k><C-p> :NERDTreeToggle<cr>
" Use Ctrl-P to open the fuzzy file opener
nnoremap <C-p> :Files<cr>

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

