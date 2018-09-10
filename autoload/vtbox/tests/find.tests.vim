"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../find.vim"

let s:impl_script = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" helper
"
let s:file_1 = s:tests_path."/file_1"
let s:file_2 = s:tests_path."/file_2"

function! s:create_stub_files()
    for file in [s:file_1, s:file_2]
        if !filereadable(file)
            call system("echo stub > ".file)
        endif
    endfor
endfunction

function! s:remove_stub_files()
    for file in [s:file_1, s:file_2]
        if filereadable(file)
            call system("rm -f ".file)
        endif
    endfor
endfunction


function! s:find_file_1_cmd()
    return [ 'find ./ -type f -name file_1' ]
endfunction

function! s:find_two_files_cmd()
    return [ 'find ./ -type f -name file_1 -or -type f -name file_2' ]
endfunction

function! s:find_no_files_cmd()
    return [ 'find ./ -type f -name  not_existed_stub_filename' ]
endfunction

function! s:invalid_find_command_cmd()
    return [ 'find ./ -type --Name  dummy' ]
endfunction


function! s:find_object_stub(command_functor)
    let l:obj = {'_command_functor' : a:command_functor}

    function l:obj.names()
    endfunction

    function l:obj.inames()
    endfunction

    function l:obj.pattern()
    endfunction

    function l:obj.commands()
        return self._command_functor()
    endfunction

    return l:obj
endfunction


"
" TestSuite
"
let s:suite = themis#suite("FindExecutionTs")

let s:suite.before = function("s:create_stub_files")
let s:suite.after  = function("s:remove_stub_files")


    function! s:suite.no_action_when_no_files_found()
        let l:object = s:find_object_stub(function('s:find_no_files_cmd'))

        call vtbox#find#execute(l:object, 'edit')
    endfunction


    function! s:suite.no_action_when_invalid_command()
        let l:object = s:find_object_stub(function('s:invalid_find_command_cmd'))

        call vtbox#find#unite(l:object)
    endfunction


    function! s:suite.should_open_file_in_mode_split()
        let l:object = s:find_object_stub(function('s:find_file_1_cmd'))

        call vtbox#find#execute(l:object, "split")
        call s:assert.equals(expand("%:p"), s:file_1)
    endfunction


    function! s:suite.should_open_file_in_mode_vplist()
        let l:object = s:find_object_stub(function('s:find_file_1_cmd'))

        call vtbox#find#execute(l:object, "vsplit")
        call s:assert.equals(expand("%:p"), s:file_1)
    endfunction


    function! s:suite.should_open_file_in_mode_tabnew()
        let l:object = s:find_object_stub(function('s:find_file_1_cmd'))

        call vtbox#find#execute(l:object, "tabnew")
        call s:assert.equals(expand("%:p"), s:file_1)
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindExecutionSystemCallsTs")

let s:suite.before = function("s:create_stub_files")
let s:suite.after  = function("s:remove_stub_files")


    function! s:suite.two_files_found()
        let l:object = s:find_object_stub(function('s:find_two_files_cmd'))

        let l:stdout =  vtbox#find#system_call(l:object)
        call s:assert.equals(len(l:stdout), 2)

        for file in l:stdout
            call s:assert.true(filereadable(file))
        endfor
    endfunction


    function! s:suite.no_files_found()
        let l:object = s:find_object_stub(function('s:find_no_files_cmd'))

        call s:assert.true(
                    \ empty(vtbox#find#system_call(l:object)))
    endfunction


    function! s:suite.exception_for_shell_error()
        let l:object = s:find_object_stub(function('s:invalid_find_command_cmd'))

        Throws :call vtbox#find#system_call(l:object)
    endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
