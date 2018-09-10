"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../parser.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
function! s:assert_empty_logger()
    call s:assert.true(s:impl_script.logger().empty())
endfunction

"
" TestSuite
"
let s:suite = themis#suite('FindParserTs')

    function! s:suite.unify_input()
        let l:input = '--names=* ./'

        call s:assert.equals(
                    \ {'names' : '*', 'paths' : ['./']},
                    \ s:impl_script.parse(l:input))
    endfunction


    function! s:suite.will_remove_paths_when_empty()
        let l:input = '--names=*'

        call s:assert.equals(
                    \ s:impl_script.parse(l:input),
                    \ {'names' : '*'})
    endfunction


    function! s:suite.input_is_valid_1()
        let l:parsed = {'names' : '*', 'paths' : './'}

        call s:assert.true(
                    \ s:impl_script.is_input_valid(l:parsed))
    endfunction

    function! s:suite.input_is_valid_1()
        let l:parsed = {'inames' : '*', 'paths' : './'}

        call s:assert.true(
                    \ s:impl_script.is_input_valid(l:parsed))
    endfunction


    function! s:suite.input_is_invalid_when_no_paths()
        let l:parsed = {'names' : '*'}

        call s:assert.false(
                    \ s:impl_script.is_input_valid(l:parsed))
    endfunction

    function! s:suite.input_is_invalid_when_no_names()
        let l:parsed = {'paths' : '*'}

        call s:assert.false(
                    \ s:impl_script.is_input_valid(l:parsed))
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
