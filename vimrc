filetype detect

set nocompatible
call pathogen#infect()
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

syntax enable
set background=dark "this must come before colors are set up
color grb256 
hi Visual cterm=none ctermfg=black ctermbg=cyan
hi StatusLine cterm=none ctermfg=black ctermbg=cyan
hi StatusLineNC cterm=none ctermfg=black ctermbg=gray
hi SpellBad cterm=none ctermbg=19 
"hi OverLength ctermbg=black ctermfg=white 
"au bufread *.py match OverLength /\%81v.*/
"hi SpellBad cterm=underline
"hi SpellBad ctermfg=white ctermbg=444444 cterm=none
 
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

au BufRead *.txt set spell
au BufRead Makefile,makefile,*.mk set noexpandtab nosmarttab
au BufRead CMake* set nospell
au BufRead *.htm* set textwidth=160
au BufRead *.py set nocindent
au BufRead *.batch set nowrap
au BufRead *.log set nowrap
au BufWritePre *.py :%s/\s\+$//e
au BufWritePre *.cfg :%s/\s\+$//e
au BufWritePre *.rst :%s/\s\+$//e
au BufWritePre *.scala :%s/\s\+$//e

map <silent> !s :!sudo vi %<cr>
map <silent> ,w :w<cr>
map <silent> ,/ :s/^/\/\//<CR>:noh<CR>
map <silent> ./ :s/\/\{1,\}\///<CR>:noh<CR>
map <silent> ,# :s/^/#/<CR>:noh<CR>
map <silent> .# :s/#//<CR>:noh<CR>
map <silent> ,; :s/^/;/<CR>:noh<CR>
map <silent> .; :s/;//<CR>:noh<CR>
map <silent> <C-n> :bn<CR>
map <silent> <C-p> :bp<CR>
map <silent> ,xt <ESC>:%!xmllint --format -<CR>
map <silent> ,jt <ESC>:%!python -m simplejson.tool<CR>
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-u>Hexmode<CR>
map <F7> :w !xclip<CR><CR>
map <S-F7> :r !xclip -o<CR>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
map ,r :w<cr>:!python %<cr>
map ,t :w<cr>:!trial -e %<cr>
"map <C-]> :RopeGotoDefinition<cr>
map <silent> <S-j> <C-w>+
map <silent> <S-k> <C-w>-
map <silent> <S-h> <C-w><
map <silent> <S-l> <C-w>>

let g:jedi#pydoc = "<C-k>"

command -bar Hexmode call ToggleHex()

filetype plugin indent on

let g:python_highlight_builtins=1
let g:python_highlight_exceptions=1

"python from powerline.ext.vim import source_plugin; source_plugin()

let g:Powerline_symbols='fancy'
set encoding=utf-8

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
nnoremap <Leader>? :PythonLocation<CR>

"let g:CommandTMaxFiles=100000
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let g:jedi#auto_initialization = 1
let g:jedi#auto_vim_configuration = 1

vmap <Leader>h :<C-U>!hg blame -fu <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
