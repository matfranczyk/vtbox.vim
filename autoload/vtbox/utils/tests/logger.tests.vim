"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../logger.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)


"
" TestSuite
"
let s:suite = themis#suite('LoggerTs')

let s:item = "item"
let s:item_2 = "second_itmem"

function! s:suite.before_each()
    let s:sut = vtbox#utils#logger#create()
endfunction


    function! s:suite.interace_regression()
        call s:assert.is_list(s:sut._buffer)

        call s:assert.is_function(s:sut.empty)
        call s:assert.is_function(s:sut.append)
        call s:assert.is_function(s:sut.clear)
        call s:assert.is_function(s:sut.withdraw)
    endfunction


    function! s:suite.test_empty_method()
        call s:assert.true(s:sut.empty())
        call s:sut.append(s:item)
        call s:assert.false(s:sut.empty())
    endfunction


    function! s:suite.test_clear_method()
        call s:sut.append(s:item)
        call s:sut.clear()

        call s:assert.true(s:sut.empty())
    endfunction


    function! s:suite.append_method()
        call s:sut.append(s:item)
        call s:assert.equals(s:sut._buffer, [s:item])

        call s:sut.append(s:item_2)
        call s:assert.equals(s:sut._buffer, [s:item, s:item_2])
    endfunction


    function! s:suite.withdraw()
        call self.append_method()
        call s:assert.false(s:sut.empty())

        call s:assert.equals(
                    \ s:sut.withdraw(),
                    \ s:item."\n".s:item_2)
        call s:assert.true(s:sut.empty())
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
