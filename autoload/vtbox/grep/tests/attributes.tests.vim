"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')

function! s:expected()
    return {
    \ 'fixed'        : [],
    \ 'regex'        : [],
    \ 'paths'        : [],
    \ 'insensitive'  : [],
    \ 'include'      : [],
    \ 'exclude'      : [],
    \ 'exclude_dir'  : [],
    \}
endfunction

"
" TestSuite
"
let s:suite = themis#suite('GrepAttributesTs')


    function! s:suite.label_regresssino()
        call s:assert.equals(
                    \ vtbox#grep#attributes#new(),
                    \ s:expected())
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
