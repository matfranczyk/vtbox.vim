"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')

"
" helpers
"
let s:header_file = fnamemodify(expand('<sfile>'), ":p:h")."/dummy.header"
let s:header_content = "dummy content"

let s:attributes = {
    \ "key_1" : "value_1",
    \ "key_2" : ["*.h", "*.cpp"],
    \}
let s:conversion_outcome = [
            \ "",
            \ "[[files]]",
            \ " key_1 = 'value_1'",
            \ " key_2 = ['*.h', '*.cpp']"
            \ ]

"
" TestSuite
"
let s:suite = themis#suite('sources:toml:find attributes content builder')

function! s:suite.before()
    if !filereadable(s:header_file)
        call system("echo ".s:header_content." > ".s:header_file)
    endif
endfunction

function! s:suite.after()
    if filereadable(s:header_file)
        return vtbox#utils#filesystem#delete(s:header_file)
    endif
endfunction


function! s:suite.before_each()
    let g:sut = vtbox#workspace#toml#content#builder#create(s:header_file)
endfunction


    function! s:suite.test_creation()
        call s:assert.equals(
                    \ g:sut._header_file,
                    \ s:header_file)

        call s:assert.equals(
                    \ g:sut._product,
                    \ [])
    endfunction


    function! s:suite.header_content()
        call s:assert.equals(
                    \ g:sut._header_content(),
                    \ [s:header_content])
    endfunction


    function! s:suite.test_adding()
        let l:first = ["value"] | let l:second = {"key" : 1}

        call g:sut.add(l:first) | call g:sut.add(l:second)
        call s:assert.equals(
                    \ g:sut._product,
                    \ [[l:first], [l:second]])
    endfunction


    function! s:suite.test_single_conversion()
        call g:sut.add(s:attributes)

        call vtbox#utils#themis#assert_list_combination(
                    \ g:sut._convert_item(s:attributes),
                    \ s:conversion_outcome)
    endfunction


    function! s:suite.test_full_conversion()
        call g:sut.add(s:attributes) | call g:sut.add(s:attributes)

        let l:outcome = g:sut._convert(deepcopy(g:sut._product))

        call s:assert.is_list(l:outcome)
        call s:assert.equals(len(l:outcome), 2)

        call vtbox#utils#themis#assert_list_combination(
                    \ l:outcome[0], s:conversion_outcome)

        call vtbox#utils#themis#assert_list_combination(
                    \ l:outcome[1], s:conversion_outcome)
    endfunction


    function! s:suite.content_test()
        call g:sut.add(s:attributes)

        call vtbox#utils#themis#assert_list_combination(
                    \ g:sut.content(),
                    \ extend([s:header_content],
                    \        s:conversion_outcome))
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
