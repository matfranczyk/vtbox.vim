"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../parser.vim"

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("GrepParserImpl")

    function! s:suite.configuration()
            let l:sut = vtbox#grep#parser#factory#create()

            call s:assert.is_function(l:sut.parse)

            call s:assert.has_key(l:sut.options, 'fixed')
            call s:assert.equals(l:sut.options.fixed.short_option_definition, '-F')
            call s:assert.has_key(l:sut.options, 'regex')
            call s:assert.equals(l:sut.options.regex.short_option_definition, '-E')
            call s:assert.has_key(l:sut.options, 'insensitive')
            call s:assert.equals(l:sut.options.insensitive.short_option_definition, '-i')
            call s:assert.has_key(l:sut.options, 'include')
            call s:assert.has_key(l:sut.options, 'exclude')
            call s:assert.has_key(l:sut.options, 'exclude_dir')

            call s:assert.equals(l:sut.unknown_options_completion, "file")
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
