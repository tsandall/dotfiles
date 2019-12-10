set nocompatible

call plug#begin("~/.vim/plugged")

Plug 'nelstrom/vim-markdown-folding'
Plug 'quanganhdo/grb256'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'SirVer/ultisnips'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'davidhalter/jedi-vim'
Plug 'fatih/vim-go'
Plug 'tsandall/vim-rego'
Plug 'Chiel92/vim-autoformat'
Plug 'qpkorr/vim-bufkill'
Plug 'rhysd/vim-wasm'

call plug#end()

colorscheme grb256
filetype plugin indent on

hi Visual cterm=none ctermfg=black ctermbg=green
hi SpellBad cterm=none ctermbg=blue
"hi QuickFixLine term=reverse ctermbg=red

set wildmode=list:longest,list:full
set wildignore=*.o,*.so,*.pyc,vendor,node_modules
set suffixes=.bak,~,*.o,.info,.swp,.obj
set expandtab
set autoindent
set hidden
set nobackup
set nowritebackup
set noswapfile
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set backspace=2
set laststatus=2
set number
set ignorecase
set smartcase
set hlsearch
set incsearch
set completeopt-=preview
set clipboard=unnamed
set fillchars="fold: "

fun! TrimWhitespace()
    let l:save = winsaveview()
    %s/\s\+$//e
    call winrestview(l:save)
endfun

au BufWritePre * :call TrimWhitespace()

au BufRead *.txt set spell
au BufRead *.log set nowrap
au BufRead *.peg set filetype=go
au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead kubeconfig set filetype=yaml
au BufRead ~/.kube/config set filetype=yaml

au FileType c set sw=4
au FileType yaml set sw=2
au FileType yaml set expandtab
au FileType html set sw=2
au FileType js set sw=2
au FileType python set nocindent
au FileType python map ,r :w<cr>:!python %<cr>
au FileType python map ,dt :call jedi#goto()<cr>
au FileType go nmap ,r :w<cr>:GoRun %<cr>
au FileType go nmap ,b <Plug>(go-build)
au FileType go nmap ,t <Plug>(go-test)
au FileType go nmap ,f <Plug>(go-test-func)
au FileType go nmap ,ds <Plug>(go-def-split)
au FileType go nmap ,dv <Plug>(go-def-vertical)
au FileType go nmap ,dt :GoDef<cr>
au FileType go nmap ,gb <Plug>(go-doc-browser)
au FileType go nmap ,s <Plug>(go-implements)

map <silent> ,w :w<cr>
map <silent> ,/ :s/^/\/\//<CR>:noh<CR>
map <silent> ./ :s/\/\{1,\}\///<CR>:noh<CR>
map <silent> ,# :s/^/#/<CR>:noh<CR>
map <silent> .# :s/#//<CR>:noh<CR>
map <silent> ,; :s/^/;;/<CR>:noh<CR>
map <silent> .; :s/;;//<CR>:noh<CR>
map <silent> <C-n> :bp<CR>
map <silent> <C-m> :bn<CR>
map <silent> <C-c> :BD<cr>
map <silent> <S-j> <C-w>+
map <silent> <S-k> <C-w>-
map <silent> <S-h> <C-w><
map <silent> <S-l> <C-w>>
map <silent> <C-k> :lne<cr>
map <silent> <C-l> :lp<cr>

let g:UltiSnipsExpandTrigger="<c-c>"
let g:UltiSnipsEditSplit="vertical"

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

"let g:formatdef_rego = '"opa fmt"'
"let g:formatters_rego = ['rego']
"let g:autoformat_retab = 0
"let g:autoformat_autoindent = 0
"let g:autoformat_verbosemode=1
"au BufWritePre *.rego Autoformat
"au BufWritePre *.py Autoformat
"
"let g:formatter_yapf_style = 'pep8'
