setlocal shiftwidth=2
setlocal tabstop=2
autocmd BufWritePre <buffer> :%s/\s\+$//e
