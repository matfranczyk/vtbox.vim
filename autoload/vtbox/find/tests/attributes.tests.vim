"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')

function! s:expected()
    return {
    \ 'paths'               : [],
    \ 'names'               : [],
    \ 'inames'              : [],
    \ 'exclude_file_names'  : [],
    \ 'exclude_file_inames' : [],
    \ 'exclude_dir_names'   : [],
    \ 'exclude_dir_inames'  : [],
    \}
endfunction

"
" TestSuite
"
let s:suite = themis#suite('FindAttributesTs')


    function! s:suite.label_regresssino()
        call s:assert.equals(
                    \ vtbox#find#attributes#new(),
                    \ s:expected())
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
