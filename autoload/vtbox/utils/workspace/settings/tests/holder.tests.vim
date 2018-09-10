"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../holder.vim"

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)


let s:setting_stub = {"default" : "settings"}

function! s:settings_factory()
    return s:setting_stub
endfunction


let s:custom_settings_stub = {"custom" : "settings"}

"
" TestSuite
"
let s:suite = themis#suite("WorkspaceSettingsHolderTs")

    function! s:suite.before_each()
        let s:sut = vtbox#utils#workspace#settings#holder#create(function('s:settings_factory'))
    endfunction

    function! s:suite.api()
        call s:assert.has_key(s:sut, "_settings")
        call s:assert.has_key(s:sut, "_settings_factory")

        call s:assert.has_key(s:sut, "save")
        call s:assert.has_key(s:sut, "get")
    endfunction


    function! s:suite.default_settings_passing()
        call s:assert.equals(s:sut.get(), s:setting_stub)
    endfunction


    function! s:suite.saving_setting()
        call s:sut.save(s:custom_settings_stub)

        call s:assert.equals(s:sut.get(), s:custom_settings_stub)
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
