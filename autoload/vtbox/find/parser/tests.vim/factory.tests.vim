"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../factory.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite('FindParserTs')

    function! s:suite.construction()
        let l:sut = vtbox#find#parser#factory#create()

        call s:assert.is_function(l:sut.parse)

        call s:assert.has_key(l:sut.options, 'names')
        call s:assert.has_key(l:sut.options, 'inames')
        call s:assert.has_key(l:sut.options, 'exclude_file_names')
        call s:assert.has_key(l:sut.options, 'exclude_file_inames')
        call s:assert.has_key(l:sut.options, 'exclude_dir_names')
        call s:assert.has_key(l:sut.options, 'exclude_dir_inames')

        call s:assert.equals(l:sut.unknown_options_completion, "file")
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
