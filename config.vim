" config.vim

" {{{ Behaviour
let mapleader=","
set nocompatible
set number                " Show numbers on the left
set relativenumber        " Its better if you use motions like 10j or
set hlsearch              " Highlight search results
set ignorecase            " Search ignoring case
set smartcase             " Do not ignore case if the search patter has uppercase
set noerrorbells          " I hate bells when an error occurs
set belloff=esc           " Disable bell if type <esc> multiple times
set tabstop=4             " Tab size of 4 spaces
set softtabstop=4         " On insert use 4 spaces for tab
set shiftwidth=0
" set expandtab             " Use appropriate number of spaces
set nowrap                " Wrapping sucks (except on markdown)
set noswapfile            " Do not leave any backup files
set mouse=i               " Enable mouse on insert mode
"set clipboard=unnamed,unnamedplus     " Use the OS clipboard
set showmatch             " Highlights the matching parenthesis
set termguicolors         " Required for some themes
set splitright splitbelow " Changes the behaviour of vertical and horizontal splits
set foldlevel=1           " Better for markdown and PHP classes
set cursorline            " Highlight the current cursor line
filetype plugin indent on " Enable file type detection.
let &t_EI = "\e[2 q"      " Make cursor a line in insert on Vim
let &t_SI = "\e[6 q"      " Make cursor a line in insert on Vim

" Keep Visual Mode after indenting a block with > or <
vmap < <gv
vmap > >gv

" Move Visual blocks up or down with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" YY/XX Copy/Cut into the system clipboard
noremap YY "+y<CR>
noremap XX "+x<CR>

" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Enable native markdown folding (hopefully will be integrated in nvim)
let g:markdown_folding = 1
" }}}

" {{{ Auto Commands
" Enable wrap on Markdown and Text files
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    setlocal wrap
    setlocal noshowmatch
    nnoremap <buffer> j gj
    nnoremap <buffer> k gk
  endfunction
endif
augroup vimrc-enable-wrap-on-text-files
  autocmd!
  autocmd BufRead,BufNewFile *.txt,*.md call s:setupWrapping()
augroup END

" Auto command to remember last editing position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

" {{{ Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'                               " Makes vim work as you'd expect

Plug 'drewtempelmeyer/palenight.vim'                    " Soothing color scheme based on material palenight
Plug 'sainnhe/gruvbox-material'                         " The gruvbox theme but with Material-UI colors
Plug 'patstockwell/vim-monokai-tasty'                   " Theme that is '74% tastier than competitors'
Plug 'haishanh/night-owl.vim'

Plug 'sheerun/vim-polyglot'                             " Metapackage with a bunch of syntax highlight libs

Plug 'neoclide/coc.nvim', {'branch': 'release'}         " Make Vim like Visual Studio Code
Plug 'liuchengxu/vista.vim'                             " Like Ctags but for LSP (CoC)
Plug 'dense-analysis/ale'                               " Code sniffing using external tools
Plug 'tpope/vim-fugitive'                               " Like :!git but better

Plug 'itchyny/lightline.vim'                            " Beautify status line
" Plug 'maximbaz/lightline-ale'
Plug 'josa42/vim-lightline-coc'                         " Show CoC diagnostics in LightLine

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' } " File navigator with <C-k><C-k>
Plug 'Xuyuanp/nerdtree-git-plugin'                      " Show git status on NERDTree
Plug 'ryanoasis/vim-devicons'                           " Icons on NERDtree and Vista
Plug 'airblade/vim-gitgutter'                           " Show which lines changed on gutter
Plug 'editorconfig/editorconfig-vim'                    " Configure tab or spaces per project
Plug 'bogado/file-line'                                 " Enable opening vim like - vim my_file.php:8
Plug 'roman/golden-ratio'                               " Resize (make bigger) the focused window

Plug 'terryma/vim-multiple-cursors'                     " Multiple cursors like Sublime with <C-n>
Plug 'preservim/nerdcommenter'                          " Language sensitive comments with <leader>c<space>
Plug 'junegunn/vim-easy-align'                          " Align text by characters or reguex
Plug 'mattn/emmet-vim'                                  " Emmet support with <C-y>,
" Plug 'jiangmiao/auto-pairs'                             " Auto close quotes, parens, brakets, etc
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }     " Install fuzzy finder binary
Plug 'junegunn/fzf.vim'                                 " Enable fuzzy finder in Vim with <C-p>
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

call plug#end()
" }}}

" {{{ Theme(s) settings
if !has('nvim')
    " Enable italics in Vim 8
    let &t_ZH="\e[3m"
    let &t_ZR="\e[23m"
endif
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_palette = 'mix'
let g:palenight_terminal_italics = 1
let g:vim_monokai_tasty_italic = 1

" silent! colorscheme gruvbox-material
" silent! colorscheme gruvbox8
" silent! colorscheme night-owl
silent! colorscheme palenight
" silent! colorscheme vim-monokai-tasty
 " }}}

" {{{ CoC extensions to be auto installed
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
" }}}

" {{{ CoC (taken from github.com/neoclide/coc.nvim with comments removed)
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=400
set shortmess+=c
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" {{{ Vista
let g:vista#renderer#enable_icon = 1
let g:vista_default_executive = 'coc'
nnoremap <C-k><C-o> :Vista finder<cr>
inoremap <C-k><C-o> <esc>:Vista finder<cr>
" }}}

" {{{ ALE
let g:ale_disable_lsp = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
  \ 'python': ['pylint']
  \ }
let g:ale_fixers = {
  \ 'php': ['phpcbf'],
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \}
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
"}}}

" {{{ LightLine
function! LightLineFilename()
  return expand('%')
endfunction
set statusline+=%h
" Configure the sections of the statusline
" Path to file: https://github.com/itchyny/lightline.vim/issues/87#issuecomment-119130738
let g:lightline = { 'active': {  } }
let g:lightline.component = {
  \  'lineinfo': "[%{printf('%03d/%03d',line('.'),line('$'))}]"
  \}
let g:lightline.component_function = {
  \    'gitbranch': 'fugitive#head',
  \    'method': 'NearestMethodOrFunction',
  \    'filename': 'LightLineFilename'
  \  }
" When using ALE for diagnostics
" let g:lightline.component_expand = {
"       \  'linter_checking': 'lightline#ale#checking',
"       \  'linter_infos': 'lightline#ale#infos',
"       \  'linter_warnings': 'lightline#ale#warnings',
"       \  'linter_errors': 'lightline#ale#errors',
"       \  'linter_ok': 'lightline#ale#ok',
"       \ }
" " When using CoC's diagnostics-languageserver for diagnostics
let g:lightline.component_expand = {
  \   'linter_warnings': 'lightline#coc#warnings',
  \   'linter_errors': 'lightline#coc#errors',
  \   'linter_ok': 'lightline#coc#ok',
  \   'status': 'lightline#coc#status',
  \ }
let g:lightline.component_type = {
      \     'linter_checking': 'right',
      \     'linter_infos': 'right',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'right',
      \ }
let g:lightline.active.left = [
  \      [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok' ],
  \      [ 'coc_errors', 'coc_warnings', 'coc_ok' ], [ 'coc_status'  ],
  \      [ 'gitbranch', 'readonly', 'filename', 'tagbar', 'modified', 'method' ]
  \]
let g:lightline.active.right = [
  \      ['lineinfo'], ['fileformat', 'filetype']
  \]
" let g:lightline.colorscheme = 'ayu_mirage'
" let g:lightline.colorscheme = 'darcula'
" let g:lightline.colorscheme = 'gruvbox_material'
" let g:lightline.colorscheme = 'monokai_tasty'
" let g:lightline.colorscheme = 'nightowl'
let g:lightline.colorscheme = 'palenight'
" let g:lightline.colorscheme = 'selenized_dark' " Goes great with night owl
" }}}

" {{{ NERDTree
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let g:NERDTreeWinPos='right'
map <C-k><C-k> :NERDTreeToggle<cr>
map <C-k><C-f> :NERDTreeFind<cr>
" Open up nerdtree if started like 'vim .'
"augroup nerdtree-auto-open-if-param-is-dir
  "autocmd!
  "autocmd StdinReadPre * let s:std_in=1
  "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | exe 'NERDTreeCWD' | wincmd p | ene | exe 'cd '.argv()[0] | endif
  "autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"augroup END
" Do not show lightline on NERDTree
augroup nerdtree-normal-statusline
    autocmd!
    autocmd BufEnter,FileType nerdtree setlocal statusline=%#Normal#
augroup END
" }}}

" {{{ EasyAlign. Start interactive modes in visual and motion/text objects
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}

" {{{ Vim commentary
autocmd FileType php setlocal commentstring=//\ %s
" }}}

" {{{ FzF
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git/*"'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
map <C-p> :Files<cr>
map <C-k><C-p> :GFiles<cr>
map <C-k><C-l> :Buffers<cr>
nmap ?? :Rg!!<cr>
" }}}

" {{{ Markdown Preview. Do not autoclose on change buffer and refresh only on normal
let g:mkdp_auto_close = 0
let g:mkdp_refresh_slow = 1
let g:mkdp_preview_options = {
  \ 'sync_scroll_type': 'top',
  \ }
" }}}

" vim: ts=2 sw=2 et fdm=marker
