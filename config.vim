" config.vim

let mapleader = ","
set nocompatible
set number                " Show numbers on the left
set hlsearch              " Highlight search results
set ignorecase            " Search ingnoring case
set smartcase             " Do not ignore case if the search patter has uppercase
set noerrorbells          " I hate bells
set tabstop=4             " Tab size of 4 spaces
set softtabstop=0         " On insert use 4 spaces for tab
set shiftwidth=4
set expandtab             " Use apropiate number of spaces
set nowrap                " Wrapping sucks (except on markdown)
set noswapfile            " Do not leve any backup files
set mouse=a               " Enable mouse on all modes
set clipboard=unnamed,unnamedplus     " Use the OS keyboard
set showmatch
set background=dark

if (has('termguicolors'))
  set termguicolors
endif

" Keep VisualMode after indent with > or <
vmap < <gv
vmap > >gv

" Move Visual blocks with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Functions to convert spaces to tabs and show invisible characters
if !exists('*s:setTabConvert')
  function s:setTabConvert()
    set list
    setlocal noexpandtab
    setlocal listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    %retab
  endfunction
endif
command! TabConvert call s:setTabConvert()

" Function to enable wrapping and have arrows navigate inside wraps
if !exists('*s:wrapToggle')
    function s:wrapToggle()
        if &wrap
            echo "Wrap OFF"
            setlocal nowrap
            set virtualedit=all
            silent! nunmap <buffer> <Up>
            silent! nunmap <buffer> <Down>
            silent! nunmap <buffer> <Home>
            silent! nunmap <buffer> <End>
            silent! iunmap <buffer> <Up>
            silent! iunmap <buffer> <Down>
            silent! iunmap <buffer> <Home>
            silent! iunmap <buffer> <End>
        else
            echo "Wrap ON"
            setlocal wrap linebreak nolist
            set virtualedit=
            setlocal display+=lastline
            noremap  <buffer> <silent> <Up>   gk
            noremap  <buffer> <silent> <Down> gj
            noremap  <buffer> <silent> <Home> g<Home>
            noremap  <buffer> <silent> <End>  g<End>
            inoremap <buffer> <silent> <Up>   <C-o>gk
            inoremap <buffer> <silent> <Down> <C-o>gj
            inoremap <buffer> <silent> <Home> <C-o>g<Home>
            inoremap <buffer> <silent> <End>  <C-o>g<End>
        endif
    endfunction
endif
command! WrapToggle call s:wrapToggle()

" Autocomand to remember las editing position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Autocomand to enable wrapping on txt an md files
augroup vimrc-wrap-text-and-md-files
  autocmd!
  autocmd BufRead,BufNewFile *.md call s:wrapToggle()
  autocmd BufRead,BufNewFile *.txt call s:wrapToggle()
augroup END

" Install vim-plug for vim and neovim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "silent !mkdir -p ~/.config/nvim/autoload/ && ln -s ~/.vim/autoload/plug.vim ~/.config/nvim/autoload/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                                         " Sensible defaults

" Themes (I usually switch between them)
Plug 'kaicataldo/material.vim'                                    " Material Themes
Plug 'morhetz/gruvbox'                                            " Retro cool theme
Plug 'haishanh/night-owl.vim'                                     " A 'Night Time' cool theme
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'drewtempelmeyer/palenight.vim'
Plug 'joshdick/onedark.vim'

" Make it work like a Code Editor
Plug 'itchyny/lightline.vim'                                      " Simple status line
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }           " File navigator with <C-k><C-b>
Plug 'preservim/nerdcommenter'                                    " Use <leader>c<space> for comments
Plug 'Xuyuanp/nerdtree-git-plugin'                                " Git status on NERDTree
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'                                           " <C-P> (find files) o
Plug 'junegunn/vim-easy-align'                                    " Align text by characters or reguex
Plug 'jiangmiao/auto-pairs'                                       " Insert/delete brackets, parens, quotes in pair
Plug 'mattn/emmet-vim'                                            " Emmet support with <C-y>,

" Make Vim work like an IDE (requires node)
Plug 'dense-analysis/ale'                                         " Use different linters to fix code (Coc config required)
Plug 'neoclide/coc.nvim', {'branch': 'release'}                   " This gives you VSCode inside Vim!!!
Plug 'liuchengxu/vista.vim'                                       " Like ctags but for Coc
call plug#end()

" Italics in NeoVim only
if has('nvim')
  let g:gruvbox_italic=0                      " Gruvbox Theme
  let g:material_terminal_italics = 1         " Material  Theme
endif

let g:material_theme_style =  'palenight'     " 'default' | 'palenight' | 'ocean' | 'lighter' | 'darker'

" Change the color scheme
colorscheme palenight

                                              " Lightline
let g:lightline = { 'colorscheme': 'wombat' } " material_vim | wombat

" NERDTree
noremap <C-k><C-p> :NERDTreeToggle<cr>
inoremap <C-k><C-p> <esc>:NERDTreeToggle<cr>
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1

" FZF
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'vendor/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
nnoremap <C-p> :Files<cr>
inoremap <C-p> <esc>:Files<cr>
nnoremap <C-k><C-g> :GFiles<cr>
inoremap <C-k><C-g> <esc>:GFiles<cr>
nnoremap <leader>y :History<cr>
nnoremap <leader>b :Buffers<cr>

" ALE
"let g:ale_lint_delay=1000
"let g:ale_lint_on_text_changed='never'

let g:ale_set_loclist = 0
let g:ale_set_quickfix=1
"let g:ale_open_list = 1

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '▲'
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'php': ['phpcbf']
\}
nmap <silent> <C-e>j <Plug>(ale_previous_wrap)
nmap <silent> <C-e>k <Plug>(ale_next_wrap)

" Vista.Vim
nnoremap <leader>t :Vista!!<cr>
let g:vista_default_executive = 'coc'
let g:vista_fzf_preview = ['right:50%'] " This is very cool Ctrl-P preview!!!

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

" CoC
" - Enable 'wordpress' in ~/.config/coc/extensions/node_modules/coc-phpls/package.json
source coc.vim
