"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#exception#log(...)
    let l:error = "v:exception: ".v:exception
    let l:msg = empty(a:000) ? l:error : a:1." | ".l:error

    call vtbox#vital#lib('Vim.Message').error('[vtbox] '.l:msg)
endfunction


function vtbox#exception#rethrow(msg) abort
    call vtbox#exception#throw("| rethrown: ".v:exception)
endfunction


function vtbox#exception#throw(msg)
    throw "[vtbox] ".a:msg
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
