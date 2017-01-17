set nocompatible

call plug#begin("~/.vim/plugged")

Plug 'SirVer/ultisnips'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'davidhalter/jedi-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tsandall/vim-rego'
Plug 'quanganhdo/grb256'

call plug#end()

filetype detect
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Misc. Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
set background=dark "this must come before colors are set up
color grb256 
hi Visual cterm=none ctermfg=black ctermbg=green
hi SpellBad cterm=none ctermbg=19 
set textwidth=78
set formatoptions=tcroq
set wildmode=list:longest,list:full
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.pyc
set wildignore+=*.egg-info
set wildignore+=*charm-build
set wildignore+=vendor
set suffixes=.bak,~,*.o,.info,.swp,.obj
set history=1000
set hidden
set nobackup
set nowritebackup
set noswapfile
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set expandtab
set autoindent
set backspace=2
set laststatus=2
set number
set ignorecase
set smartcase
set hlsearch
set incsearch
set completeopt-=preview
set encoding=utf-8
au BufNewFile,BufRead *.yml set filetype=yaml
au BufRead *.txt set spell
au BufRead *.peg set filetype=go
au BufRead Makefile,makefile,*.mk set noexpandtab nosmarttab
au BufRead CMake* set nospell
au BufRead *.htm* set textwidth=160
au BufRead *.py set nocindent
au BufRead *.batch set nowrap
au BufRead *.log set nowrap
au BufRead *.py set textwidth=120
au BufWritePre *.rego :%s/\s\+$//e
au BufWritePre *.peg :%s/\s\+$//e
au BufWritePre *.py :%s/\s\+$//e
au BufWritePre *.go :%s/\s\+$//e
au BufWritePre *.mk :%s/\s\+$//e
au BufWritePre *.cfg :%s/\s\+$//e
au BufWritePre *.rst,*.md :%s/\s\+$//e
au BufWritePre *.scala :%s/\s\+$//e
au BufWritePre *.sbt :%s/\s\+$//e
au BufWritePre *.conf :%s/\s\+$//e
au BufWritePre *.sh :%s/\s\+$//e
au BufWritePre *.yaml :%s/\s\+$//e
autocmd FileType yaml set sw=2
autocmd FileType html set sw=2
autocmd FileType js set sw=2
let g:UltiSnipsExpandTrigger="<c-c>"
let g:UltiSnipsEditSplit="vertical"
let g:ctrlp_custom_ignore="env"
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Aliases 
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <silent> ,w :w<cr>
map <silent> ,/ :s/^/\/\//<CR>:noh<CR>
map <silent> ./ :s/\/\{1,\}\///<CR>:noh<CR>
map <silent> ,# :s/^/#/<CR>:noh<CR>
map <silent> .# :s/#//<CR>:noh<CR>
map <silent> ,; :s/^/;/<CR>:noh<CR>
map <silent> .; :s/;//<CR>:noh<CR>
map <silent> <C-n> :bp<CR>
map <silent> <C-m> :bn<CR>
map <silent> <S-j> <C-w>+
map <silent> <S-k> <C-w>-
map <silent> <S-h> <C-w><
map <silent> <S-l> <C-w>>
map <silent> <C-k> :lne<cr>
map <silent> <C-l> :lp<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Python
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType python map ,r :w<cr>:!python %<cr>
autocmd FileType python map ,dt :call jedi#goto()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Golang 
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType go nmap ,r :w<cr>:GoRun %<cr>
autocmd FileType go nmap ,b <Plug>(go-build)
autocmd FileType go nmap ,t <Plug>(go-test)
autocmd FileType go nmap ,ds <Plug>(go-def-split)
autocmd FileType go nmap ,dv <Plug>(go-def-vertical)
autocmd FileType go nmap ,dt :GoDef<cr>
autocmd FileType go nmap ,gb <Plug>(go-doc-browser)
autocmd FileType go nmap ,s <Plug>(go-implements)

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

