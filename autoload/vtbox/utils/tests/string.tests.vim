"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')


    "
    " [test suite]
    "
    let s:suite = themis#suite('utils#string()')

    function! s:suite.trim()
        let l:text = " text "

        call s:assert.equal(vtbox#utils#string#trim(l:text), "text")
    endfunction


    function! s:suite.truncate_skipping()
        let l:text = "<first----------------"

        call s:assert.equal(
                    \ vtbox#utils#string#truncate_skipping(l:text, 7, 2, "..."),
                    \ "<f...--")
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('HasTs')

    function s:suite.contains()
        call s:assert.true(
                    \ vtbox#utils#string#has('value', 'a'))

        call s:assert.true(
                    \ vtbox#utils#string#has('~/falder/has', '~'))
    endfunction


    function s:suite.doesnt_contain()
        call s:assert.false(
                    \ vtbox#utils#string#has('value', 'A'))

        call s:assert.false(
                    \ vtbox#utils#string#has('/falder/has', '~'))
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
