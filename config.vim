" config.vim

let mapleader=","
set nocompatible
set number                " Show numbers on the left
set hlsearch              " Highlight search results
set ignorecase            " Search ingnoring case
set smartcase             " Do not ignore case if the search patter has uppercase
set noerrorbells          " I hate bells
set belloff=esc           " Disable bell if type <esc> multiple times
set tabstop=4             " Tab size of 4 spaces
set softtabstop=4         " On insert use 4 spaces for tab
set shiftwidth=0
" set expandtab             " Use apropiate number of spaces
set nowrap                " Wrapping sucks (except on markdown)
set noswapfile            " Do not leve any backup files
set mouse=i               " Enable mouse on all modes
"set clipboard=unnamed,unnamedplus     " Use the OS clipboard
set showmatch             " Highlights the mathcin parentesis
set termguicolors         " Required for some themes
set splitright splitbelow " Changes the behaviour of vertical and horizontal splits
set foldlevel=1           " Better for markdown and PHP classes
set cursorline            " Highlight the current cursor line
let &t_EI = "\e[2 q"      " Make cursor a line in insert on Vim
let &t_SI = "\e[6 q"      " Make cursor a line in insert on Vim

" Keep VisualMode after indent with > or <
vmap < <gv
vmap > >gv
"
" Move Visual blocks up or down with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" YY: Copy and Cut into the system clipboard
noremap YY "+y<CR>
noremap XX "+x<CR>

" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Enable wrap on Markdown and Text files
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    setlocal wrap
    "setlocal wrapmargin=2
    "setlocal textwidth=79
    setlocal noshowmatch
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
  endfunction
endif
augroup vimrc-enable-wrap-on-text-files
  autocmd!
  autocmd BufRead,BufNewFile *.txt,*.md call s:setupWrapping()
augroup END

" Autocomand to remember las editing position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                               " Sensible defaults
"Plug 'neoclide/coc.nvim', {'branch': 'release'}         " Make Vim like Visual Studio Code
Plug 'itchyny/lightline.vim'                            " Beautify status line
Plug 'josa42/vim-lightline-coc'                         " Show CoC diagnostics in LightLine
Plug 'sheerun/vim-polyglot'                             " Metapackage with a bunch of syntax highlight libs
Plug 'flazz/vim-colorschemes'                           " Metapackage with a lot of colorschemes
Plug 'drewtempelmeyer/palenight.vim'                    " Soothing color scheme not on vim-colorschemes
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " File navigator with <C-k><C-k>
Plug 'Xuyuanp/nerdtree-git-plugin'                      " Show git status on NERDTree
Plug 'tpope/vim-fugitive'                               " Like :!git but better
Plug 'airblade/vim-gitgutter'                           " Show which lines changed on gutter
Plug 'tpope/vim-commentary'                             " Comment using motions
Plug 'editorconfig/editorconfig-vim'                    " Configure tab or spaces per project
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'                                 " Enable fuzzy finder in Vim with <C-p>
Plug 'junegunn/vim-easy-align'                          " Align text by characters or reguex
Plug 'mattn/emmet-vim'                                  " Emmet support with <C-y>,
Plug 'terryma/vim-multiple-cursors'                     " Multiple cursors like Sublime with <C-n>
Plug 'liuchengxu/vista.vim'                             " Like Ctags but for LSP (CoC)
Plug 'jiangmiao/auto-pairs'                             " Auto close qutoes, parens, brakets, etc
Plug 'plasticboy/vim-markdown'                          " Fold on markdown and syntax highlighting 
call plug#end()

" CoC extensions to be auto installed
let g:coc_global_extensions = [
    \ 'coc-css',
    "\ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-marketplace',
    \ 'coc-phpls',
    "\ 'coc-prettier',
    \ 'coc-python',
    \ 'coc-tsserver'
    \]


" Vista
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
let g:vista#renderer#enable_icon = 0
let g:vista_default_executive = 'coc'
nnoremap <C-k><C-o> :Vista!!<cr>
inoremap <C-k><C-o> <esc>:Vista!!<cr>

" VimWorkspace
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
let g:workspace_autosave_always = 1
let g:workspace_undodir=$HOME.'/.vim/undodir'

" LightLine
let g:lightline = {
  \   'colorscheme': 'nord',
  \   'active': {
  \     'left': [[ 'coc_errors', 'coc_warnings', 'coc_ok' ], [ 'coc_status' ] , [ 'gitbranch', 'readonly', 'filename', 'tagbar', 'modified', 'method' ]]
  \   },
  \   'component_function': {
  \     'gitbranch': 'fugitive#head',
  \     'method': 'NearestMethodOrFunction'
  \   }
  \ }
call lightline#coc#register()

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
map <C-k><C-k> :NERDTreeToggle<cr>
map <C-k><C-f> :NERDTreeFind<cr>

" FzF
map <C-p> :GFiles<cr>
map <C-k><C-l> :Buffers<cr>

" EasyAlign. Start interactive modes in visual and motion/text objects
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Theme(s) settings
if has('nvim')
  let g:gruvbox_italic=0               " Gruvbox Theme
  let g:material_terminal_italics = 1  " Material  Theme
  let g:palenight_terminal_italics = 1 " Palenight
endif
silent! colorscheme palenight
