"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../cpp.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("ToggleFilenameCppUtilsTs")


function! s:suite.toggle_c_extension()
    call s:assert.equals(
                \ vtbox#utils#cpp#flip('filename.c'),
                \ 'filename.h*'
                \ )
endfunction

function! s:suite.toggle_h_extension()
    call s:assert.equals(
                \ vtbox#utils#cpp#flip('filename.h'),
                \ 'filename.c*'
                \ )
endfunction


function! s:suite.toggle_cpp_extension()
    call s:assert.equals(
                \ vtbox#utils#cpp#flip('filename.cpp'),
                \ 'filename.h*'
                \ )
endfunction

function! s:suite.toggle_hpp_extension()
    call s:assert.equals(
                \ vtbox#utils#cpp#flip('filename.hpp'),
                \ 'filename.c*'
                \ )
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
