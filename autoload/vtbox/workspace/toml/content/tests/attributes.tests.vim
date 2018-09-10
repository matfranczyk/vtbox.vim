"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')

"
" helpers
"
let s:exclude_dirs  = []
let s:exclude_idirs = ['build']
let s:exclude_files = ['*.o', '*.obj', '*.pyc', '*.a', '*.so', '*.exe']

"
" TestSuit
"
let s:suite = themis#suite("TomlContentAttributesKey")

    function s:suite.assert_key()
        call s:assert.equals(
                    \ vtbox#workspace#toml#content#attributes#key(),
                    \ "files")
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("TomlContentAtrributesFindTs")

    function! s:suite.regression()
        let l:expected = {
                    \ 'paths': ['./'],
                    \ 'exclude_file_names': s:exclude_files,
                    \ 'exclude_dir_inames': s:exclude_idirs,
                    \ 'exclude_dir_names': s:exclude_dirs,
                    \ 'exclude_file_inames': []
                    \ }

        call s:assert.equals(
                    \ vtbox#workspace#toml#content#attributes#find(),
                    \ l:expected)
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("TomlContentAtrributesTagsTs")

    function! s:suite.regression()
        let l:expected = {
                    \ 'paths': ['./'],
                    \ 'inames': ['*'],
                    \ 'exclude_file_names': s:exclude_files,
                    \ 'exclude_dir_inames': s:exclude_idirs,
                    \ 'exclude_dir_names': s:exclude_dirs,
                    \ 'exclude_file_inames': []
                    \ }

        call s:assert.equals(
                    \ vtbox#workspace#toml#content#attributes#tags(),
                    \ l:expected)
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("TomlContentAtrributesGrepTs")

    function! s:suite.regression()
        let l:expected = {
                    \ 'paths': ['./'],
                    \ 'exclude_dir': extend(s:exclude_idirs, s:exclude_dirs),
                    \ 'include': [],
                    \ 'exclude': s:exclude_files,
                    \ }

        call s:assert.equals(
                    \ vtbox#workspace#toml#content#attributes#grep(),
                    \ l:expected)
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
