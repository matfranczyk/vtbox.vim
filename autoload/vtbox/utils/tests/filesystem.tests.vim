"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')


    "
    " [test suite]
    "
    let s:suite = themis#suite('file()')


    function! s:suite.should_return_full_path()
        let l:path = "/home/temp/path"

        call s:assert.equal(
                    \ vtbox#utils#filesystem#full_path(l:path),
                    \ l:path)
    endfunction


    function! s:suite.will_expand_path_with_getcwd()
        let l:filename = "file"

        call s:assert.equal(
                    \ vtbox#utils#filesystem#full_path(l:filename),
                    \ getcwd()."/".l:filename)
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('parent_path()')


    function! s:suite.should_return_parent_directory()
        let l:parent = getcwd()."/parent"

        call s:assert.equal(
                    \ vtbox#utils#filesystem#parent_path(l:parent."/file"),
                    \ l:parent)
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('dirname()')

    function! s:suite.return_dirname_for_directory_path()
        let l:dirname = "directory"
        let l:path = getcwd()."/".l:dirname

        call s:assert.equal(
                    \ vtbox#utils#filesystem#dirname(l:path),
                    \ l:dirname)
    endfunction


    function! s:suite.substitute_path_separator()
        let l:path = getcwd()

        call s:assert.equal(
                    \ vtbox#utils#filesystem#substitute_path_separator(l:path),
                    \ l:path)
    endfunction


    function! s:suite.taking_filename_from_path()
        let l:filename = "file.extension"

        call s:assert.equal(
                    \ vtbox#utils#filesystem#filename(getcwd()."/".l:filename),
                    \ l:filename)
    endfunction


    "
    " [test suite]
    "
    let s:suite = themis#suite('FirstValidPathTs')
    let s:suite.valid_path = '/home'

    function! s:suite.no_valid()
        call s:assert.equals(
                    \ vtbox#utils#filesystem#return_first_valid_directory(
                    \   '/invalid/path/first',
                    \   '/home/invalid/path/stub/2'),
                    \ "")
    endfunction


    function! s:suite.first_valid_path()
        call s:assert.equals(
                    \ vtbox#utils#filesystem#return_first_valid_directory(
                    \   self.valid_path,
                    \   '/home/invalid/path/stub/2'),
                    \ self.valid_path)
    endfunction


    function! s:suite.second_valid_path()
        call s:assert.equals(
                    \ vtbox#utils#filesystem#return_first_valid_directory(
                    \   '/home/invalid/path/stub/2',
                    \   self.valid_path),
                    \ self.valid_path)
    endfunction

    "
    " [test suite]
    "
    let s:suite = themis#suite('windows::path')


    function! s:suite.is_windows_path()
        call s:assert.true(
                    \ vtbox#utils#filesystem#is_windows_path('c:\windows\path'))
        call s:assert.false(
                    \ vtbox#utils#filesystem#is_windows_path('/home/value'))
    endfunction


    function! s:suite.windows_path()
        let l:path = '/mnt/c/file.txt'
        call s:assert.equals(
                    \ vtbox#utils#filesystem#win_format(l:path),
                    \ '\mnt\c\file.txt'
                    \ )
    endfunction


    function! s:suite.convert_from_wsl()
        let l:path = '/mnt/c/file.txt'
        call s:assert.equals(
                    \ vtbox#utils#filesystem#win_path_from_wsl(l:path),
                    \ 'c:\file.txt'
                    \ )
    endfunction

    function! s:suite.convert_from_wsl_2()
        let l:path = '/mnt/c/SWX/Products/System1300/Text/English lang/Webserver.men'
        call s:assert.equals(
                    \ vtbox#utils#filesystem#win_path_from_wsl(l:path),
                    \ 'c:\SWX\Products\System1300\Text\English lang\Webserver.men'
                    \ )
    endfunction

    function! s:suite.convert_to_wsl_from_windows_1()
        let l:win_path = 'C:\Users\FRMA\storage.Mateusz\test folder\filename.txt'
        let l:expected_wsl_path = '/mnt/c/Users/FRMA/storage.Mateusz/test\ folder/filename.txt'

        call s:assert.equals(
                    \ vtbox#utils#filesystem#win_path_to_wsl(l:win_path),
                    \ l:expected_wsl_path
                    \ )
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
