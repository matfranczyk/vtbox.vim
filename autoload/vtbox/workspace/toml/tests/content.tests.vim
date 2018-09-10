"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")

let s:impl_file = s:tests_path."/../content.vim"
let s:impl_functions = themis#helper('scope').funcs(s:impl_file)
let s:impl_variables = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" helper
"
function! s:assert_content(content)
    call s:assert.is_list(a:content)

    for item in a:content
        call s:assert.is_string(item)
    endfor
endfunction


"
" TestSuite
"
let s:suite = themis#suite("TomlContentScriptAssertions")

    function! s:suite.headers()
        call s:assert.true(
                    \ isdirectory(s:impl_variables.header_paths))

        call s:assert.true(
                    \ filereadable(s:impl_variables.find_header))
        call s:assert.true(
                    \ filereadable(s:impl_variables.tags_header))
        call s:assert.true(
                    \ filereadable(s:impl_variables.grep_header))
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("TomlContentFind")

    function! s:suite.regression()
        call s:assert_content(
                    \ vtbox#workspace#toml#content#find())
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("TomlContentTags")

    function! s:suite.regression()
        call s:assert_content(
                    \ vtbox#workspace#toml#content#tags())
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("TomlContentGrep")

    function! s:suite.regression()
        call s:assert_content(
                    \ vtbox#workspace#toml#content#grep())
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
