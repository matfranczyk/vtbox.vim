"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../history.vim"

let s:impl_script = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("History container :: API")

function s:suite.before_each()
    let s:size = 3
    let s:sut = vtbox#utils#history#container(s:size)
endfunction


function s:suite.test_1()
    call s:assert.equal(s:sut.get_lifo(), [])
endfunction


function s:suite.test_3()
    call s:sut.save(1)
    call s:sut.save(1)
    call s:sut.save(2)

    call s:assert.equal(s:sut.get_lifo(), [2, 1])
    call s:assert.equal(s:sut.get_fifo(), [1, 2])
endfunction


function s:suite.test_4()
    call s:sut.save(1)
    call s:sut.save(2)
    call s:sut.save(3)
    call s:sut.save(4)

    call s:assert.equal( s:sut.get_lifo(), [4, 3, 2] )
    call s:assert.equal( s:sut.get_fifo(), [2, 3, 4] )
endfunction


function s:suite.test_5()
    call s:sut.save(1)
    call s:sut.save(1)
    call s:sut.save(2)
    call s:sut.save(1)

    call s:assert.equal( s:sut.get_lifo(), [1, 2] )
    call s:assert.equal( s:sut.get_fifo(), [2, 1] )
endfunction


function s:suite.test_with_dictionaries()
    let l:item_a = {'a' : 1}
    let l:item_b = {'b' : 2}

    call s:sut.save(l:item_a)
    call s:sut.save(l:item_b)
    call s:sut.save(l:item_a)

    call s:assert.equal( s:sut.get_lifo(), [l:item_a, l:item_b] )
    call s:assert.equal( s:sut.get_fifo(), [l:item_b, l:item_a] )
endfunction


function s:suite.test_with_strings()
    call s:sut.save('first')
    call s:sut.save('second')
    call s:sut.save('second')

    call s:assert.equal(
                \ s:sut.get_lifo(),
                \ ["second", "first"]
                \ )
    call s:assert.equal(
                \ s:sut.get_fifo(),
                \ ["first", "second"]
                \ )

endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
