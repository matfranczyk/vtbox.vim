"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../OptionParser.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" helpsers
"
function! s:stub_help()
    return "stub"
endfunction

let s:stub_parser = {"help" : function("s:stub_help")}

"
" TestSuite
"
let s:suite = themis#suite('OptionParserUtilsTs')

    function! s:suite.howto()
        let s:msg = s:impl_script.howto()

        call s:assert.is_string(s:msg)
        call s:assert.not_empty(s:msg)
    endfunction


    function! s:suite.help()
        let s:msg = s:impl_script.information(s:stub_parser)

        call s:assert.is_string(s:msg)
        call s:assert.not_empty(s:msg)
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
