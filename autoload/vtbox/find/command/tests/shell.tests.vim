"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')
let s:impl_file = fnamemodify(expand('<sfile>'), ":p:h")."/../shell.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:impl_func = themis#helper('scope').funcs(s:impl_file)
call themis#helper('command').with(s:assert)

"
" helpers
"
let s:path = getcwd()."/"

let s:valid_input = {
    \ "names" : ["filename"],
    \ "paths" : ["./"],
    \ "exclude_file_inames" : ["*.vim"]
    \ }
let s:valid_input_second = {
    \ "names" : ["filename"],
    \ "paths" : ["./"],
    \ "exclude_dir_inames" : [".svn", ".git"]
    \ }
let s:invalid_input = {
    \ "names" : ["filename"],
    \ }

function s:compose(input)
    return vtbox#find#command#shell#compose(a:input)
endfunction

"
" TestSuite
"
let s:common_excludes_dirs = '-not \( -type d -name ''.svn'' -prune \) -not \( -type d -name ''.git'' -prune \) -not \( -type d -name ''.vim.cache'' -prune \)'

let s:suite = themis#suite("FindShellComposingCommonExcludes")

    function! s:suite.assert_common_ignoring_dirs()
        call s:assert.equals(
                    \ s:impl_func.exclude_common_dirs(),
                    \ s:common_excludes_dirs
                    \ )
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellComposingUsingSingleComposer")

    function! s:suite.test()
        let l:cmds_list = s:compose([s:valid_input, s:valid_input])

        call s:assert.equals(
                    \ vtbox#find#command#shell#compose([s:valid_input, s:valid_input_second]),
                    \ [
                    \   vtbox#find#command#shell#single_command(s:valid_input),
                    \   vtbox#find#command#shell#single_command(s:valid_input_second),
                    \ ])
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellComposerTs")

    function! s:suite.composing_list_of_commands()
        let l:cmds_list = s:compose([s:valid_input, s:valid_input])

        call s:assert.is_list(l:cmds_list)
        call s:assert.equals(len(l:cmds_list), 2)
    endfunction


    function! s:suite.single_command_will_be_erased_from_the_outcome()
        let l:cmds_list = s:compose([s:valid_input, s:invalid_input])

        call s:assert.is_list(l:cmds_list)
        call s:assert.equals(len(l:cmds_list), 1)
    endfunction


    function! s:suite.will_throw_for_invalid_data()
        Throws :call  s:compose([s:invalid_input, s:invalid_input])
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellComposerSingleCommandTs")

    function! s:suite.base_test()
        let l:attrs = {
                    \ "names" : ['vim.vim', 'file.vim'],
                    \ 'paths' : ['./', '/home']}

        let l:expected_cmd = 'find '.s:path.' /home/ '
                    \ .s:common_excludes_dirs
                    \ .' -type f -name ''vim.vim'' -or -type f -name ''file.vim'''

        call s:assert.equals(
                    \ vtbox#find#command#shell#single_command(l:attrs),
                    \ l:expected_cmd)
    endfunction


    function! s:suite.returns_empty_string_when_no_paths()
        call s:assert.equals(
                    \ vtbox#find#command#shell#single_command({"names" : ['vim.vim']}),
                    \ "")
    endfunction


    function! s:suite.returns_empty_string_when_no_names()
        call s:assert.equals(
                    \ vtbox#find#command#shell#single_command({"paths" : ['./']}),
                    \ "")
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellNamesComposition")

    function! s:suite.names_extraction()
        let l:attributes = {"names" : ["file", "ifile"]}
        let l:expected   = '-type f -name ''file'' -or -type f -name ''ifile'''

        call s:assert.equals(
                    \ vtbox#find#command#shell#compose_names(l:attributes),
                    \ l:expected)
    endfunction

    function! s:suite.inames_extraction()
        let l:attributes = {"inames" : ["file", "ifile"]}
        let l:expected   = '-type f -iname ''file'' -or -type f -iname ''ifile'''

        call s:assert.equals(
                    \ vtbox#find#command#shell#compose_names(l:attributes),
                    \ l:expected)
    endfunction

    function! s:suite.both_extraction()
        let l:attributes = {"names" : ["file"], "inames" : ["ifile"]}
        let l:expected   = '-type f -name ''file'' -or -type f -iname ''ifile'''

        call s:assert.equals(
                    \ vtbox#find#command#shell#compose_names(l:attributes),
                    \ l:expected)
    endfunction


    function! s:suite.throw_if_no_items_to_extract()
        Throws :call vtbox#find#command#shell#compose_names({'invalid' : ['null']})
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellPathsComposition")

    function! s:suite.base_test()
        let l:attributes = {"paths" : ["./", "/home"]}
        let l:expected   = vtbox#utils#filesystem#full_path("./")." /home/"

        call s:assert.equals(
                    \ vtbox#find#command#shell#compose_paths(l:attributes),
                    \ l:expected)
    endfunction


    function! s:suite.will_removes_invalid_paths()
        let l:attributes = {"paths" : ["./", "/invalid/paths"]}
        let l:expected   = vtbox#utils#filesystem#full_path("./")

        call s:assert.equals(
                    \ vtbox#find#command#shell#compose_paths(l:attributes),
                    \ l:expected)
    endfunction


    function! s:suite.will_throws_for_invalid_input()
        Throws :call vtbox#find#command#shell#compose_paths("invalid")
        Throws :call vtbox#find#command#shell#compose_paths[])
    endfunction

    function! s:suite.will_throw_if_no_valid_paths_left()
        let l:attributes = {"paths" : ["/only/invalid"]}
        Throws :call vtbox#find#command#shell#compose_paths(l:attributes)
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("FindShellPathsDirName")

    function! s:suite.base_test()
        let l:attr = {"exclude_dir_names" : [".git"]}

        call s:assert.equals(
                    \ s:impl_script.extract_exclude_dir_names(l:attr),
                    \ '-not \( -type d -name ''.git'' -prune \)')
    endfunction

    function! s:suite.return_empty_string_if_no_attribute()
        call s:assert.equals(
                    \ s:impl_script.extract_exclude_dir_names({}),
                    \ "")
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellPathsDirIName")

    function! s:suite.base_test()
        let l:attr = {"exclude_dir_inames" : [".svn"]}

        call s:assert.equals(
                    \ s:impl_script.extract_exclude_dir_inames(l:attr),
                    \ '-not \( -type d -iname ''.svn'' -prune \)')
    endfunction

    function! s:suite.return_empty_string_if_no_attribute()
        call s:assert.equals(
                    \ s:impl_script.extract_exclude_dir_inames({}),
                    \ "")
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellPathsFilesName")

    function! s:suite.base_test()
        let l:attr = {"exclude_file_names" : ["temp"]}

        call s:assert.equals(
                    \ s:impl_script.extract_exclude_file_names(l:attr),
                    \ '-not \( -type f -name ''temp'' -prune \)')
    endfunction

    function! s:suite.return_empty_string_if_no_attribute()
        call s:assert.equals(
                    \ s:impl_script.extract_exclude_file_names({}),
                    \ "")
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("FindShellPathsFilesIName")

    function! s:suite.base_test()
        let l:attr = {"exclude_file_inames" : ["file"]}

        call s:assert.equals(
                    \ s:impl_script.extract_exclude_file_inames(l:attr),
                    \ '-not \( -type f -iname ''file'' -prune \)')
    endfunction

    function! s:suite.return_empty_string_if_no_attribute()
        call s:assert.equals(
                    \ s:impl_script.extract_exclude_file_inames({}),
                    \ "")
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
