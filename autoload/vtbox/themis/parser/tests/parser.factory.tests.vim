"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../factory.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite('ThemisParserTs')

    function! s:suite.before()
        let s:sut = vtbox#themis#parser#factory#create()
    endfunction

    function! s:suite.construction()
        call s:assert.has_key(s:sut.options, 'current_buffer')

        call s:assert.has_key(s:sut.options, 'recursively')
        call s:assert.has_key(s:sut.options.recursively, 'completion')
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
