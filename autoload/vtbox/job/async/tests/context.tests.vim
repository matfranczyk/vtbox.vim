"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../context.vim"

let s:impl_script = themis#helper('scope').funcs(s:impl_file)
let s:impl_vars   = themis#helper('scope').vars(s:impl_file)

let s:assert = themis#helper('assert')
let s:expect = themis#helper('expect')

call themis#helper('command').with(s:assert)

"
" TestSuite
"
let s:suite = themis#suite("ApiTs")

    function s:suite.api()
        call s:assert.is_dictionary(vtbox#job#async#context#create("cmd", {}))
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("AttributesCreationTs")

    function s:suite.empty()
        let l:properties = {}
        let l:cmd = "empty cmd"

        call s:assert.equals(
                    \ s:impl_script.create_attributes(l:cmd, l:properties),
                    \ {
                    \   'command': l:cmd,
                    \   'on_done_function': {},
                    \}
                    \ )
    endfunction

    function s:suite.attributes_creation()
        let l:cmd = "empty cmd"

        let l:on_done_fct = 'item_2'

        call s:assert.equals(
                    \ s:impl_script.create_attributes(
                    \   l:cmd,
                    \   {
                    \       'on_done_function' : l:on_done_fct,
                    \   }),
                    \ {
                    \   'command': l:cmd,
                    \   'on_done_function' : l:on_done_fct,
                    \ }
                    \)
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

        call s:assert.equals(l:data.exit_status, -1)

        call s:expect(l:data.time_start).to_be_greater_than(0)
        call s:assert.equals(l:data.time_stop, -1)
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
