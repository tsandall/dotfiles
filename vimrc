filetype detect
filetype plugin indent on

set nocompatible

call pathogen#infect()
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Misc. Settings
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable
set background=dark "this must come before colors are set up
color grb256 
hi Visual cterm=none ctermfg=black ctermbg=cyan
hi StatusLine cterm=none ctermfg=black ctermbg=cyan
hi StatusLineNC cterm=none ctermfg=black ctermbg=gray
hi SpellBad cterm=none ctermbg=19 
set textwidth=78
set formatoptions=tcroq
set wildmode=list:longest,list:full
set wildignore=*.o,*.r,*.so,*.sl,*.tar,*.tgz,*.pyc
set wildignore+=deb_dist
set wildignore+=app_dist
set wildignore+=*.egg-info
set wildignore+=*charm-build
set wildignore+=*.deb
set wildignore+=_trial_temp
set wildignore+=usr
set wildignore+=target
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
set statusline=%t%m%r%h%w\ %p%%\ line=%l\ char=%v\ max=%L\ %{TagInStatusLine()}
set ignorecase
set smartcase
set hlsearch
set incsearch
set completeopt-=preview
set encoding=utf-8
au BufNewFile,BufRead *.tosca set filetype=hocon
au BufRead *.txt set spell
au BufRead Makefile,makefile,*.mk set noexpandtab nosmarttab
au BufRead CMake* set nospell
au BufRead *.htm* set textwidth=160
au BufRead *.py set nocindent
au BufRead *.batch set nowrap
au BufRead *.log set nowrap
au BufRead *.py set textwidth=120
au BufWritePre *.py :%s/\s\+$//e
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
let g:Powerline_symbols='fancy'
let g:UltiSnipsExpandTrigger="<c-c>"
let g:UltiSnipsEditSplit="vertical"
let g:ctrlp_custom_ignore="env"

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Python
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:get_last_python_class()
    let l:retval = ""
    let l:last_line_declaring_a_class = search('^\s*class', 'bnW')
    let l:last_line_starting_with_a_word_other_than_class = search('^\ \(\<\)\@=\(class\)\@!', 'bnW')
    if l:last_line_starting_with_a_word_other_than_class < l:last_line_declaring_a_class
        let l:nameline = getline(l:last_line_declaring_a_class)
        let l:classend = matchend(l:nameline, '\s*class\s\+')
        let l:classnameend = matchend(l:nameline, '\s*class\s\+[A-Za-z0-9_]\+')
        let l:retval = strpart(l:nameline, l:classend, l:classnameend-l:classend)
    endif
    return l:retval
endfunction
 
function! s:get_last_python_def()
    let l:retval = ""
    let l:last_line_declaring_a_def = search('^\s*def', 'bnW')
    let l:last_line_starting_with_a_word_other_than_def = search('^\ \(\<\)\@=\(def\)\@!', 'bnW')
    if l:last_line_starting_with_a_word_other_than_def < l:last_line_declaring_a_def
        let l:nameline = getline(l:last_line_declaring_a_def)
        let l:defend = matchend(l:nameline, '\s*def\s\+')
        let l:defnameend = matchend(l:nameline, '\s*def\s\+[A-Za-z0-9_]\+')
        let l:retval = strpart(l:nameline, l:defend, l:defnameend-l:defend)
    endif
    return l:retval
endfunction
 
function! s:compose_python_location()
    let l:pyloc = s:get_last_python_class()
    if !empty(pyloc)
        let pyloc = pyloc . "."
    endif
    let pyloc = pyloc . s:get_last_python_def()
    return pyloc
endfunction
 
function! <SID>EchoPythonLocation()
    echo s:compose_python_location()
endfunction
 
command! PythonLocation :call <SID>EchoPythonLocation()

let g:khuno_max_line_length=120
let g:python_highlight_builtins=1
let g:python_highlight_exceptions=1

autocmd FileType python nnoremap <Leader>? :PythonLocation<CR>
autocmd FileType python map ,r :w<cr>:!python %<cr>
autocmd FileType python map ,t :w<cr>:!trial -e %<cr>

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
autocmd FileType go nmap ,dt <Plug>(go-def-tab)
autocmd FileType go nmap ,gb <Plug>(go-doc-browser)
autocmd FileType go nmap ,s <Plug>(go-implements)

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
