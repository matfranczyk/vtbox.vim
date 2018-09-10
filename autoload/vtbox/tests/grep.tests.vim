"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../grep.vim"

let s:impl_script = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" helper
"
let s:test_file = s:tests_path."/stubs/test.file.txt"

function! s:assert_stub_files()
    call s:assert.true(filereadable(s:test_file))
endfunction


function! s:grep_invalid_command()
    return  "grep -F 'pattern' ./stubs"
endfunction


function! s:grep_fixed_unknown_pattern_cmd()
    return  "grep -F 'pattern_is_unknown' ".s:test_file
endfunction

function! s:grep_fixed_pattern_with_two_occurences()
    return  "grep -F fixed_pattern ".s:test_file
endfunction


function! s:grep_regex_unknown_pattern_cmd()
    return  "grep -E uknown.*pattern ".s:test_file
endfunction

function! s:grep_regex_pattern_with_two_occurences()
    return  "grep -E fixed.*ern ".s:test_file
endfunction


function! s:grep_object_stub(command_functor)
    let l:obj = {'_command_functor' : a:command_functor}

    function l:obj.fixed()
    endfunction

    function l:obj.regex()
    endfunction

    function l:obj.commands()
        return [self._command_functor()]
    endfunction

    return l:obj
endfunction


"
" TestSuite
"
let s:suite = themis#suite("GrepSystemCallTs")

let s:suite.before = function("s:assert_stub_files")

    function! s:suite.throw_if_sheel_error()
        let l:grep_object = s:grep_object_stub(function('s:grep_invalid_command'))

        Throws :call vtbox#grep#system_call(l:grep_object)
    endfunction


    function! s:suite.empty_output_if_fixed_pattern_is_unknown()
        let l:grep_object = s:grep_object_stub(function('s:grep_fixed_unknown_pattern_cmd'))

        call s:assert.equals(
                    \ vtbox#grep#system_call(l:grep_object),
                    \ [])
    endfunction


    function! s:suite.find_two_fixed_pattern()
        let l:grep_object = s:grep_object_stub(function('s:grep_fixed_pattern_with_two_occurences'))

        call s:assert.equals(
                    \ vtbox#grep#system_call(l:grep_object),
                    \ ["fixed_pattern", "fixed_pattern something else"])
    endfunction


    function! s:suite.empty_output_if_regex_pattern_is_unknown()
        let l:grep_object = s:grep_object_stub(function('s:grep_regex_unknown_pattern_cmd'))

        call s:assert.equals(
                    \ vtbox#grep#system_call(l:grep_object),
                    \ [])
    endfunction


    function! s:suite.find_two_regex_pattern()
        let l:grep_object = s:grep_object_stub(function('s:grep_regex_pattern_with_two_occurences'))

        call s:assert.equals(
                    \ vtbox#grep#system_call(l:grep_object),
                    \ ["fixed_pattern", "fixed_pattern something else"])
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
