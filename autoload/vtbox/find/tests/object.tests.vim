"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:impl_file = fnamemodify(expand('<sfile>'), ":p:h")."/../object.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("FindObjectInterface")
let s:suite.pattern = "new_pattern"
let s:suite.input = [ {'paths' : './'}, {'paths' : './'} ]

    function! s:suite.before_each()
        let s:sut = vtbox#find#object#new(deepcopy(self.input))
    endfunction

    function! s:suite.interface()
        call s:assert.is_function(s:sut.names)
        call s:assert.is_function(s:sut.inames)

        call s:assert.is_function(s:sut.pattern)

        call s:assert.is_function(s:sut.commands)
    endfunction

    function! s:suite.pattern_will_be_empty_be_default()
        call s:assert.empty(s:sut.pattern())
    endfunction


    function! s:suite.commands_returns_list_of_string()
        call s:sut.names(self.pattern)
        call vtbox#utils#themis#assert_list_of_string(
                    \ s:sut.commands())
    endfunction


    function! s:suite.factory_throws_if_data_is_invalid()
        Throws :call vtbox#find#object#new( [{}, 1] )
        Throws :call vtbox#find#object#new( "value" )
    endfunction

    function! s:suite.set_names()
        call s:sut.names(self.pattern)

        call s:assert.equals(
                    \ s:sut._data,
                    \ [
                    \   {'names': ['new_pattern'], 'paths': ['./']},
                    \   {'names': ['new_pattern'], 'paths': ['./']}
                    \ ])
    endfunction

    function! s:suite.names_method_update_pattern()
        call s:sut.names(self.pattern)
        call s:assert.equals(s:sut.pattern(), self.pattern)
    endfunction


    function! s:suite.set_inames()
        call s:sut.inames(self.pattern)

        call s:assert.equals(
                    \ s:sut._data,
                    \ [
                    \   {'inames': ['new_pattern'], 'paths': ['./']},
                    \   {'inames': ['new_pattern'], 'paths': ['./']}
                    \ ])
    endfunction

    function! s:suite.inames_method_update_pattern()
        call s:sut.inames(self.pattern)
        call s:assert.equals(s:sut.pattern(), self.pattern)
    endfunction


    function! s:suite.commands_composition_will_not_change_internal_data()
        call s:sut.names(self.pattern)
        call s:sut.commands()

        call s:assert.equals(
                \ s:sut._data,
                \ [
                \  {'names': ['new_pattern'], 'paths': ['./']},
                \  {'names': ['new_pattern'], 'paths': ['./']}
                \ ])
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
