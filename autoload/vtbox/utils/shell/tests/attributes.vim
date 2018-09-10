"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../attributes.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("ShellHandlerDataConverterApi")


    function! s:suite.api()
        let l:data = {"data" : "value", "value" : "first,second"}

        call s:assert.equals(
                    \ vtbox#utils#shell#attributes#unify(l:data),
                    \ [{'data': ['value'], 'value': ['first', 'second']}])
    endfunction


    function! s:suite.throw_for_invalid_input_find()
        Throws :call vtbox#utils#shell#attributes#unify([])
        Throws :call vtbox#utils#shell#attributes#unify({})
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("ShellDataConverterImplTs")


    function! s:suite.empty_list_is_not_valid_input()
        call s:assert.false(s:impl_func.is_input_valid([]))
    endfunction


    function! s:suite.empty_dictionary_is_not_valid_input()
        call s:assert.false(s:impl_func.is_input_valid({}))
    endfunction


    function! s:suite.dictionary_is_valid()
        call s:assert.true(s:impl_func.is_input_valid({"value" : 1}))
    endfunction


    function! s:suite.list_of_dictionary_is_valid()
        call s:assert.true(s:impl_func.is_input_valid(
                    \ [{"value" : 1}, {1 : "value"}]))
    endfunction

    function! s:suite.only_list_of_dictionaries_is_valid()
        call s:assert.false(s:impl_func.is_input_valid(
                    \ [{"value" : 1}, 1, {1 : "value"}]))
    endfunction


    function! s:suite.format_attributes()
        let l:input = {
            \ "key1" : "first,second",
            \ "key2" : [],
            \ "key3" : ["value"]
            \ }

        let l:expected = {
            \ "key1" : ["first", "second"],
            \ "key3" : ["value"]
            \ }

        call s:assert.equals(
                    \ s:impl_func.format_attributes(l:input), l:expected)
    endfunction

    function! s:suite.split_string()
        call s:assert.equals(
                    \ s:impl_func.split_items({1 : "f,s", 2 : "f,s,t"}),
                    \ {1 : ["f", "s"], 2 : ["f", "s", "t"]}
                    \ )
    endfunction


    function! s:suite.remove_keys_with_empty_list()
        call s:assert.equals(
                    \ s:impl_func.remove_empty_lists({1 : "value", "key" : []}),
                    \ {1 : "value"}
                    \ )
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
