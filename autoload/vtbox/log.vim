"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#log#echo(msg)
    call vtbox#vital#lib('Vim.Message').echo('MoreMsg', a:msg)
endfunction


function vtbox#log#message(msg)
    call vtbox#vital#lib('Vim.Message').echomsg('MoreMsg', a:msg)
endfunction


function vtbox#log#warning(msg)
    call vtbox#vital#lib('Vim.Message').warn(a:msg)
endfunction


function vtbox#log#error(msg)
    call vtbox#vital#lib('Vim.Message').error(a:msg)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
