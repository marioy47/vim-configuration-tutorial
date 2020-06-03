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
autocmd BufRead,BufNewFile *.md,*.txt setlocal wrap " DO wrap on markdown files
set noswapfile            " Do not leve any backup files
set mouse=a               " Enable mouse on all modes
set clipboard=unnamed,unnamedplus     " Use the OS clipboard
set showmatch
set termguicolors
set splitright splitbelow
set list lcs=tab:\¦\      "(here is a space)
let &t_SI = "\e[6 q"      " Make cursor a line in insert
let &t_EI = "\e[2 q"      " Make cursor a line in insert


" Keep VisualMode after indent with > or <
vmap < <gv
vmap > >gv
"
" Move Visual blocks with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Open loclist
nnoremap <leader>lo :lopen<cr>
nnoremap <leader>lc :lclose<cr>

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
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " File navigator
Plug 'Xuyuanp/nerdtree-git-plugin'                      " Git status on NERDTree
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'                                 " Enable fuzzy finder in Vim
Plug 'editorconfig/editorconfig-vim'                    " Tab/Space trough projects
Plug 'preservim/nerdcommenter'                          " Use <leader>c<space> for comments
Plug 'junegunn/vim-easy-align'                          " Align text by characters or reguex
Plug 'neoclide/coc.nvim', {'branch': 'release'}         " Awesome autocoplete
Plug 'dense-analysis/ale'                               " The only linter that works everywhere
Plug 'itchyny/lightline.vim'                            " Lightweight status line
Plug 'maximbaz/lightline-ale'                           " Lightline ALE support
Plug 'airblade/vim-gitgutter'                           " Show which lines changed
Plug 'mattn/emmet-vim'                                  " Emmet support with <C-y>,
Plug 'drewtempelmeyer/palenight.vim'                    " Soothing color scheme for your favorite [best] text editor
call plug#end()


" NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
map <C-k><C-k> :NERDTreeToggle<cr>
map <C-k><C-f> :NERDTreeFind<cr>
" Except Ctrl-P  to make it work like VS
map <C-p> :Files<cr>
map <C-k><C-u> :Buffers<cr>

" ALE Shortcodes
nmap <leader>ap <Plug>(ale_previous_wrap)
nmap <leader>an <C-j> <Plug>(ale_next_wrap)
"let g:ale_sign_error = '✘'
"let g:ale_sign_warning = '▲'
let g:ale_fix_on_save = 1
let g:ale_fixers = {
            \ '*': ['remove_trailing_lines', 'trim_whitespace'],
            \ 'javascript': ['eslint'],
            \ 'php': ['phpcbf']
            \}

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_infos': 'lightline#ale#infos',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }
let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }
let g:lightline.active = { 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ]] }

" CoC
let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-marketplace',
    \ 'coc-phpls',
    \ 'coc-prettier',
    \ 'coc-python',
    \ 'coc-tsserver'
    \]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Theme(s) settings
if has('nvim')
  let g:gruvbox_italic=0               " Gruvbox Theme
  let g:material_terminal_italics = 1  " Material  Theme
  let g:palenight_terminal_italics = 1 " Palenight
endif
colorscheme palenight                  " Activate the Palenight theme
