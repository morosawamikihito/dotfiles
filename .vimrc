" general settings
noremap <ESC><ESC> :q<CR>
set clipboard+=unnamed
set backspace=indent,eol,start

set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
let $LC_ALL = 'en'

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
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('tpope/vim-fugitive')
  " call dein#add('itchyny/vim-gitbranch')

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


" statusline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'gitbranch', 'absolutepath', 'command' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'GitBranch',
      \   'command': 'LatestExecCommand'
      \ },
      \ }

function! LatestExecCommand()
  let s:result = system("tail -n1 ~/.zsh_history | cut -f 2 -d\\;")[:-2]
  if s:result == v:null
    return "(empty)"
  endif
  return "Executed: ".s:result
endfunction

function! GitBranch()
  let s:result = fugitive#head()
  if empty(s:result)
    return ""
  endif
  return "Git(".s:result.")"
endfunction

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


" visual selection color
highlight Visual term=reverse cterm=bold ctermbg=240 ctermfg=None
highlight Comment ctermfg=244 cterm=bold

" map

"" plugins
noremap ,l :NERDTreeToggle<CR>
nnoremap <silent> sub :Unite buffer<CR>
nnoremap <silent> suf :Unite file<CR>

"" split
noremap <C-s> :split<CR>
noremap <C-n> :vsplit<CR>
nnoremap <silent> sj <C-w>j<CR>
nnoremap <silent> sk <C-w>k<CR>
nnoremap <silent> sl <C-w>l<CR>
nnoremap <silent> sh <C-w>h<CR>

" terminal
noremap <C-w>t :bo term ++rows=18<CR>
tnoremap <C-w><ESC><ESC> <C-W>:q!<CR>

