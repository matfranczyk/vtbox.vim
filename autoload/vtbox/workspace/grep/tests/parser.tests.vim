"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../parser.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("ProjectGrepParserScriptTs")

    function! s:suite.valid_with_regex_only()
        call s:assert.true(s:impl_func.is_input_valid({"regex" : 1}))
    endfunction

    function! s:suite.valid_with_fixed_only()
        call s:assert.true(s:impl_func.is_input_valid({"fixed" : 1}))
    endfunction


    function! s:suite.invalid_for_both_fixed_and_regex()
        call s:assert.false(s:impl_func.is_input_valid({"fixed" : 1, "regex" : 1}))
    endfunction


    function! s:suite.invalid_with_nor_fixed_nor_regex()
        call s:assert.false(s:impl_func.is_input_valid({"invalid" : 1}))
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
