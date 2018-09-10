"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../command.vim"
let s:impl_script = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite('ThemisExecutionTs')
let s:dummy_file_1 = s:tests_path."/dummy.test.file"
let s:dummy_file_2 = s:tests_path."/dummy.test.file"

function s:stub_result(error_code)
    return  \ {
            \ 'stdout'    : ["stub"],
            \ 'exit_code' : v:shell_error,
            \ 'file'      : fnamemodify(a:file, ":p")
            \ }
endfunction

function s:dummy_positive_result()
    return s:stub_result(0)
endfunction

function s:dummy_negative_result()
    return s:stub_result(-1)
endfunction


function! s:suite.before()
    for file in [s:dummy_file_1, s:dummy_file_2]
        if ! filereadable(file)
            call system('echo dummy txt > '.file)
        endif
    endfor
endfunction

function! s:suite.after()
    for file in [s:dummy_file_1, s:dummy_file_2]
        if filereadable(file)
            call system('rm -f '.file)
        endif
    endfor
endfunction


    function! s:suite.result_format_assertion()
        let l:result = s:impl_script.execute(s:dummy_file_1)

        call s:assert.is_dictionary(l:result)
        call s:assert.is_number(l:result.exit_code)
        call s:assert.is_list(l:result.stdout)
    endfunction


    function! s:suite.collecting_files_recursively()
        let l:files = s:impl_script.collect_files(s:tests_path)
        call s:assert.not_empty(l:files)

        for file in s:impl_script.collect_files(s:tests_path)
            call s:assert.true(filereadable(file))
        endfor
    endfunction


    function! s:suite.single_task_execution()
        let l:results = s:impl_script.run_tests([s:dummy_file_1, s:dummy_file_2])

        call s:assert.length_of(l:results, 2)
        for result in l:results
            call s:assert.true(result.exit_code)
        endfor
    endfunction


    function! s:suite.report_filler()
        let l:input = [{'file' : '/stub/filename', 'stdout' : ['stub']}]
        let l:outcome = s:impl_script.create_failed_report(l:input)

        let l:header_lines_amount = 3
        call s:assert.is_list(l:outcome)
        call s:assert.length_of(l:outcome, l:header_lines_amount + 1)
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
