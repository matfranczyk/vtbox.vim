"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:assert = themis#helper('assert')


    "
    " [test suite]
    "
    let s:utils_suite = themis#suite('utils#vim')

    function! s:utils_suite.is_list()
        call s:assert.true(vtbox#utils#vim#is_list([]))
        call s:assert.false(vtbox#utils#vim#is_list({}))
    endfunction


    function! s:utils_suite.is_location_list()
        silent! lgrep -F "item" ~/.bashrc

        lopen | call s:assert.true(vtbox#utils#vim#is_llist())
        copen | call s:assert.false(vtbox#utils#vim#is_llist())
    endfunction


    function! s:utils_suite.shellescape_braces()
        let l:text = "a ()"

        call s:assert.equals(
                    \ vtbox#utils#vim#shellescape(l:text),
                    \ 'a \(\)')
    endfunction

    function! s:utils_suite.shellescape_asterisk()
        let l:text = "a *"

        call s:assert.equals(
                    \ vtbox#utils#vim#shellescape(l:text),
                    \ 'a \*')
    endfunction


    function! s:utils_suite.system_function()
        let l:outcome =  vtbox#utils#vim#system("ls -l")

        call s:assert.is_string(l:outcome)
        call s:assert.false(v:shell_error)
    endfunction


    function! s:utils_suite.systemlist_function()
        let l:outcome =  vtbox#utils#vim#systemlist("ls -l")

        call s:assert.is_list(l:outcome)
        call s:assert.false(v:shell_error)
    endfunction


    function! s:utils_suite.watchtime_function()
        call s:assert.is_string(
                    \ vtbox#utils#vim#watch_time())
    endfunction


    function! s:utils_suite.test_open_file()
        let l:file = tempname()
        call system("touch ".l:file)
    endfunction


    "
    " [test suite] | just regression
    "
    let s:dummy_suite = themis#suite('utils#vim')

    function! s:dummy_suite.before_each()
        let v:errmsg = ""
    endfunction


    function! s:dummy_suite.test_method_previous_error_list()
        call vtbox#utils#vim#previous_error_list()

        call s:assert.true(empty(v:errmsg))
    endfunction

    function! s:dummy_suite.test_method_next_error_list()
        call vtbox#utils#vim#next_error_list()

        call s:assert.true(empty(v:errmsg))
    endfunction


    function! s:dummy_suite.test_method_make_qflist()
        let l:stdout = system("ls -l")
        call vtbox#utils#vim#make_qflist(l:stdout)

        call s:assert.true(empty(v:errmsg))
    endfunction


    "
    " [test suite] | opening file
    "
    let s:open_file_suite = themis#suite('utils#open-file')

    function s:open_file_suite.before_each()
        let s:tempfile = tempname()
        let s:text = "file text"

        call vtbox#utils#filesystem#set_file_content(s:tempfile, [s:text])
    endfunction

    function! s:open_file_suite.after_each()
        if filereadable(s:tempfile)
            call system("rm ".s:tempfile)
        endif
    endfunction


    function! s:open_file_suite.file_opening()
        call vtbox#utils#vim#open_file(s:tempfile, "edit")
        call s:assert.equals(expand("%:p"), s:tempfile)

        call vtbox#utils#vim#open_file(s:tempfile, "vsplit")
        call s:assert.equals(expand("%:p"), s:tempfile)

        call vtbox#utils#vim#open_file(s:tempfile, "split")
        call s:assert.equals(expand("%:p"), s:tempfile)

        call vtbox#utils#vim#open_file(s:tempfile, "tabnew")
        call s:assert.equals(expand("%:p"), s:tempfile)
    endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
