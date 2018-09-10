"---------------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../object.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)


"
" TestSuite
"
let s:suite = themis#suite("GrepHandlerApi")
let s:suite.pattern = "new_pattern"
let s:suite.input = [ {'paths' : './'}, {'paths' : './'} ]

    function! s:suite.before_each()
        let s:sut = vtbox#grep#object#new(deepcopy(self.input))
    endfunction


    function! s:suite.interface()
        call s:assert.is_function(s:sut.fixed)
        call s:assert.is_function(s:sut.regex)
        call s:assert.is_function(s:sut.icase)

        call s:assert.is_function(s:sut.pattern)

        call s:assert.is_function(s:sut.commands)
    endfunction


    function! s:suite.pattern_will_be_empty_be_default()
        call s:assert.empty(s:sut.pattern())
    endfunction


    function! s:suite.commands_returns_list_of_string()
        call s:sut.regex(self.pattern)
        call vtbox#utils#themis#assert_list_of_string(
                    \ s:sut.commands())
    endfunction


    function! s:suite.creation_throws_if_data_is_invalid()
        Throws :call vtbox#grep#object#new( [{}, 1] )
        Throws :call vtbox#grep#object#new( "value" )
    endfunction


    function! s:suite.set_fixed()
        call s:sut.fixed(self.pattern)

        call s:assert.equals(
                \ s:sut._data,
                \ [
                \  {'fixed': ['new_pattern'], 'paths': ['./']},
                \  {'fixed': ['new_pattern'], 'paths': ['./']}
                \ ])
    endfunction


    function! s:suite.set_fixed_will_update_current_pattern()
        call s:sut.fixed(self.pattern)
        call s:assert.equals(s:sut.pattern(), self.pattern)
    endfunction


    function! s:suite.set_regex()
        call s:sut.regex(self.pattern)

        call s:assert.equals(
                \ s:sut._data,
                \ [
                \  {'regex': ['new_pattern'], 'paths': ['./']},
                \  {'regex': ['new_pattern'], 'paths': ['./']}
                \ ])
    endfunction


    function! s:suite.set_regex_will_update_current_pattern()
        call s:sut.regex(self.pattern)
        call s:assert.equals(s:sut.pattern(), self.pattern)
    endfunction

    function! s:suite.set_icase()
        call s:sut.icase()

        call s:assert.equals(
                \ s:sut._data,
                \ [
                \  {'insensitive': 1, 'paths': ['./']},
                \  {'insensitive': 1, 'paths': ['./']}
                \ ])
    endfunction


    function! s:suite.commands_composition_will_not_change_internal_data()
        call s:sut.fixed(self.pattern)
        call s:sut.commands()

        call s:assert.equals(
                \ s:sut._data,
                \ [
                \  {'fixed': ['new_pattern'], 'paths': ['./']},
                \  {'fixed': ['new_pattern'], 'paths': ['./']}
                \ ])
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
