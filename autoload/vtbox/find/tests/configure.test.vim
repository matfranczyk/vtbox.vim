"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)


"
" TestSuite
"
let s:suite = themis#suite('FindFileCommandSetupTs')

    function! s:suite.setup()
        call s:assert.cmd_exists("FindFile")
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
