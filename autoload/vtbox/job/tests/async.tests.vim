"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../async.vim"

let s:impl_script = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" helper
"
let s:cmd = "ls -la"

"
" TestSuite
"
let s:suite = themis#suite("AsyncJobTs_DefaultProperties")

function s:suite.before_each()
    let s:job = vtbox#job#async#create(s:cmd, {})
endfunction

    function s:suite.api()
        call s:assert.is_function(s:job.launch)
        call s:assert.is_function(s:job.is_running)
        call s:assert.is_function(s:job.command)
    endfunction


    function s:suite.command_method()
        call s:assert.equals(s:job.command(), s:cmd)

        let l:cmd = "gcc --version"
        call s:job.command(l:cmd)
        call s:assert.equals(s:job.command(), l:cmd)
    endfunction


    function s:suite.checking_if_jobs_still_running()
        call s:job.launch()
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
