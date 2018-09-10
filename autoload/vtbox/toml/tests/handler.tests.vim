"---------------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../handler.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" helpers
"
let s:file = s:tests_path."/stub.toml"
let s:file_parse_outcome = {'key': {'value': 'name'}}

function! s:content_stub()
    return ["[key]", "value = 'name'"]
endfunction


"
" TestSuite
"
let s:suite = themis#suite("TomlHandlerInterfaceTs_withStubFile")

function! s:suite.before()
    call s:assert.true(filereadable(s:file))
endfunction

function! s:suite.before_each()
    let s:sut = vtbox#toml#handler#create(s:file, function('s:content_stub'))
endfunction

    function! s:suite.interface()
        call s:assert.is_function(s:sut.has_changed)
        call s:assert.is_function(s:sut.file)
        call s:assert.is_function(s:sut.parse)
    endfunction


    function! s:suite.file()
        call s:assert.equals(s:sut.file(), s:file)
    endfunction


    function! s:suite.parsing_and_timestamp()
        call s:assert.true(s:sut.has_changed())

        call s:assert.equals(s:sut.parse(), s:file_parse_outcome)
        call s:assert.false(s:sut.has_changed())
    endfunction


    function! s:suite.api_has_changed()
        call s:sut.parse()
        call s:assert.false(s:sut.has_changed())

        call system("touch ".s:file)
        call s:assert.true(s:sut.has_changed())
    endfunction


"function! s:valid_content_provider()
"    return [ '[['.vtbox#workspace#toml#content#attributes#key().']]', 'value = 1' ]
"endfunction

"function! s:invalid_content_provider()
"    return ['value = 1']
"endfunction


"function! s:create_sut(...)
"    if empty(a:000)
"        return vtbox#workspace#toml#handler#create(s:file, function("s:valid_content_provider"))
"    endif

"    return vtbox#workspace#toml#handler#create(s:file, a:1)
"endfunction


"function! s:before_each(content_provider)
"    if !filereadable(s:file)
"        call vtbox#utils#filesystem#set_file_content(
"                    \ s:file,
"                    \ a:content_provider())
"    endif
"endfunction

"function! s:after_each()
"    if filereadable(s:file)
"        call vtbox#utils#filesystem#delete(s:file)
"    endif
"endfunction

""
"" Test Suite
""
"let s:suite = themis#suite('sources:toml:handler Valid data')

"let s:suite.before_each = function("s:before_each", [function("s:valid_content_provider")])
"let s:suite.after_each  = function("s:after_each")

"function! s:suite.before()
"    call self.before_each()
"    call s:assert.is_list(
"                \ vtbox#vital#lib('Text.TOML').parse_file(s:file)[vtbox#workspace#toml#content#attributes#key()])
"endfunction


"    function! s:suite.test_creation()
"        let l:sut = s:create_sut()
"    endfunction


"    function! s:suite.will_no_create_file_if_file_exist()
"        call s:assert.is_list(
"                    \ s:create_sut().parse())
"    endfunction


"    function! s:suite.test_parsing()
"        call s:assert.equals(
"                    \ s:create_sut().parse(),
"                    \ vtbox#vital#lib('Text.TOML').parse_file(s:file)[vtbox#workspace#toml#content#attributes#key()])
"    endfunction


"    function! s:suite.will_create_file_if_not_exist_and_parse_is_called()
"        call self.after_each()
"        call s:create_sut().parse()

"        call s:assert.true(
"                    \ filereadable(s:file))

"        call s:assert.equals(
"                    \ vtbox#utils#filesystem#get_file_content(s:file),
"                    \ s:valid_content_provider())
"    endfunction


"    function! s:suite.fetch_file_test()
"        call self.after_each()

"        call s:assert.false(filereadable(s:file))
"        call s:assert.equals(
"                    \ s:create_sut().fetch_file(),
"                    \ s:file)

"        call s:assert.true(filereadable(s:file))
"    endfunction


"    function! s:suite.pars_immutability()
"        let l:sut = s:create_sut()

"        let l:parsed_data = l:sut.parse()
"        let l:parsed_data["next_key"] = "next_value"

"        call s:assert.not_equals(
"                    \ l:sut.parse(),
"                    \ l:parsed_data)
"    endfunction


""
"" Test Suite
""
"let s:suite = themis#suite('sources:toml:handler Invalid data')

"let s:suite.before_each = function("s:before_each", [function("s:invalid_content_provider")])
"let s:suite.after_each  = function("s:after_each")


"    function! s:suite.should_throw_if_content_is_invalid()
"        Throws call s:create_sut(function('s:invalid_content_provider')).parse()
"    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
