"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../factory.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("ProjectGrepParserTs")

function! s:suite.before_each()
    let s:sut = vtbox#workspace#grep#parser#factory#create()
endfunction

    function! s:suite.configuration()
        call s:assert.has_key(s:sut.options, "configuration")
        call s:assert.has_key(s:sut.options, "regex")
        call s:assert.has_key(s:sut.options, "fixed")
        call s:assert.has_key(s:sut.options, "insensitive")
    endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
