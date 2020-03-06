
" general settings
noremap <ESC><ESC> :q<CR>
set clipboard+=unnamed
set backspace=indent,eol,start

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8

set laststatus=2

" cursor
set cursorline
set cursorcolumn
set number

"set showmatch
source $VIMRUNTIME/macros/matchit.vim

" tab
set expandtab
set tabstop=2
set shiftwidth=2

" search
nnoremap <silent><C-h> :<C-u>set nohlsearch!<CR>

" vim booting script and dein settings
if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if dein#load_state('~/.cache/dein')
  call dein#begin(expand('~/.cache/dein'))

  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/vimproc.vim', {'build': 'make'})
  call dein#add('Shougo/neomru.vim')
  call dein#add('tomasr/molokai')
  call dein#add('Shougo/unite.vim')
  call dein#add('preservim/nerdtree')
  call dein#add('Yggdroot/indentLine')
  call dein#add('itchyny/lightline.vim')

  if has('lua')
    call dein#add('Shougo/neocomplete.vim')
    call dein#add('Shougo/neosnippet')
    call dein#add('Shougo/neosnippet-snippets')
  endif

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on

" color schema
colorscheme molokai
set t_Co=256
syntax enable

" NERDTree
autocmd VimEnter * execute 'NERDTree'
let g:NERDTreeNodeDelimiter = "\u00a0"


" indentLine
let g:indentLine_color_term = 102
let g:indentLine_char_list = ['|', '¦']
noremap <C-o> :IndentLinesToggle<CR>




" NeoComplcache, NeoSnippet

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#auto_completion_start_length = 1
inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"
imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"


""" let g:neosnippet#snippets_directory = '$HOME/.vim/snippets/'


" map

"" plugins
noremap ,l :NERDTreeToggle<CR>

"" split
noremap <C-s> :split<CR>
noremap <C-n> :vsplit<CR>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h

" terminal
noremap <C-w>t :bo term ++rows=18<CR>
tnoremap <C-w><ESC><ESC> <C-W>:q!<CR>

