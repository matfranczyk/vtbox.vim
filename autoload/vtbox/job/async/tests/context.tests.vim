"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../context.vim"

let s:impl_script = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("ApiTs")

    function s:suite.api()
        call s:assert.is_dictionary(vtbox#job#async#context#create({}))
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("AttributesCreationTs")

    function s:suite.empty()
        call s:assert.equals(
                    \ s:impl_script.create_attributes({}),
                    \ {
                    \   'stdout_file': {},
                    \   'on_done_function': {},
                    \   'on_done_job': {},
                    \   'stderr_file': {}}
                    \ )
    endfunction

    function s:suite.attributes_creation()
        call s:assert.equals(
                    \ s:impl_script.create_attributes({'stdout_file' : 'file'}),
                    \ {
                    \   'stdout_file': 'file',
                    \   'on_done_function': {},
                    \   'on_done_job': {},
                    \   'stderr_file': {}}
                    \ )
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("CreateHandlersTs")

    function s:suite.default()
        let l:handlers = s:impl_script.create_framework()

        call s:assert.is_function(l:handlers.on_stdout)
        call s:assert.is_function(l:handlers.on_stderr)
        call s:assert.is_function(l:handlers.on_exit)
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("CreateContextDataTs")

    function s:suite.default()
        let l:data = s:impl_script.create_framework()

        call s:assert.equals([''], l:data.stdout)
        call s:assert.equals([''], l:data.stderr)

        call s:assert.false(l:data.exit_status.has_value())

        call s:assert.true(l:data.time_start.has_value())
        call s:assert.false(l:data.time_stop.has_value())
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
