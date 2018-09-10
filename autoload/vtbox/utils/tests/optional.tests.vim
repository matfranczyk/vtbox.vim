"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

    "
    " [test suite]
    "
    let s:suite = themis#suite('UtilsOptionalTs')

    function! s:suite.before_each()
        let s:sut = vtbox#utils#optional#create("name of optional")
    endfunction


    function! s:suite.shall_be_empty_after_createion()
        call s:assert.false(s:sut.is_initialized())
    endfunction


    function! s:suite.shoul_be_initialized_if_value_was_set()
        call s:sut.value(1)
        call s:assert.true(s:sut.is_initialized())
    endfunction


    function! s:suite.shall_throw_if_not_initialized()
        Throws :call s:sut.value()
    endfunction


    function! s:suite.shall_return_value_if_initialized()
        call s:sut.value("text")
        call s:assert.equals(
                    \ s:sut.value(),
                    \ "text")
    endfunction


    function! s:suite.reset_value()
        call s:sut.value(1) | call s:sut.reset()

        call s:assert.false(s:sut.is_initialized())
    endfunction



    "
    " [test suite]
    "
    let s:suite = themis#suite('UtilsOptionalTs_defaultParameters')


    function! s:suite.set_default_on_creation()
        let l:sut = vtbox#utils#optional#create('name', 0)

        call s:assert.equals(0, l:sut.value())

        call l:sut.value([1, 2])
        call s:assert.equals([1, 2], l:sut.value())

        call l:sut.reset()
        call s:assert.false(s:sut.is_initialized())
    endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
