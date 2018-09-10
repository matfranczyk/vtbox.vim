"---------------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../vital.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)


"
" TestSuite
"
let s:suite = themis#suite("VtboxVitalManagerTs")

function! s:suite.before_each()
    let s:sut = s:impl_func.create_manager()
endfunction

function! s:suite.has_library()
    call s:assert.false(s:sut.has('Invalid.Library'))
    call s:assert.true(s:sut.has('Vim.Message'))
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
