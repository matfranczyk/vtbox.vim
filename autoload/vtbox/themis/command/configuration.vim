"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#themis#command#configuration#setup()
    augroup VtboxThemisBufferVim
        autocmd!
        autocmd Filetype vim
            \ command! -nargs=* -buffer -complete=customlist,vtbox#themis#command#complete
            \ Themis :call vtbox#themis#command#execute(<q-args>)
    augroup END
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
