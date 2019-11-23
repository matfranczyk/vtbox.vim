"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')
let s:impl_file = fnamemodify(expand('<sfile>'), ":p:h")."/../utils.vim"

let s:method = themis#helper('scope').funcs(s:impl_file)

    "
    " [test suite]
    "
    let s:suite = themis#suite('has_line_number')

    function! s:suite.simple()
        call s:assert.true(
            \ s:method.hasLineNumber('file:23')
            \ )
    endfunction

    function! s:suite.whitespace_in_the_end()
        call s:assert.true(
            \ s:method.hasLineNumber('file:23 ')
            \ )
    endfunction

    function! s:suite.whitespace_before_line_number()
        call s:assert.true(
            \ s:method.hasLineNumber('file :23')
            \ )
    endfunction

    function! s:suite.whitespace_before_and_end_line_number()
        call s:assert.true(
            \ s:method.hasLineNumber('file text :23 ')
            \ )
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('has_no_line_number')

    function! s:suite.no_lin_number()
        call s:assert.false(
            \ s:method.hasLineNumber('filename')
            \ )
    endfunction

    function! s:suite.no_filename()
        call s:assert.false(
            \ s:method.hasLineNumber(':23')
            \ )
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('pick_filename')

    function! s:suite.no_whitespaces()
        call s:assert.equal(
            \ s:method.filepath("file:123"),  "file")
    endfunction

    function! s:suite.whitespace_after_filename()
        call s:assert.equal(
            \ s:method.filepath("file :123"),  "file")
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('pick_lineNumber')

    function! s:suite.no_whitespace()
        call s:assert.equal(
            \ s:method.lineNumber("file:123"),  ":123")
    endfunction

    function! s:suite.whitespace_after_filename()
        call s:assert.equal(
            \ s:method.lineNumber("file :124"),  ":124")
    endfunction

    function! s:suite.whitespace_after_fileNumber()
        call s:assert.equal(
            \ s:method.lineNumber("file :124  "),  ":124")
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('parser')


    function! s:suite.whitespace_after_fileNumber()
        let l:obj = s:method.parse('file:124')

        call s:assert.equal(l:obj.filepath, "file")
        call s:assert.true(l:obj.lineNumber.has_value())
        call s:assert.equal(l:obj.lineNumber.value(), ":124")
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
