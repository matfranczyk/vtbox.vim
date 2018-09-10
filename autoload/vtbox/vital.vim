"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#vital#lib(library)
    return s:manager().library(a:library)
endfunction

function vtbox#vital#update()
    execute 'Vitalize --name=vtbox '.s:paths.install.' '.s:manager().list()
endfunction


function s:create_manager()
    return {
        \ "_libraries" : {
        \    'Text.TOML' : {},
        \    'Vim.Buffer' : {},
        \    'Vim.Message' : {},
        \    'Prelude' : {},
        \    'OptionParser' : {},
        \    'Data.String' : {},
        \    'Data.List' : {},
        \    'System.Cache.SingleFile' : {},
        \    'System.Filepath' : {},
        \    'System.Job' : {},
        \    'Vim.Console' : {},
        \ },
        \
        \ "has"               : function("s:has"),
        \ "is_not_configured" : function("s:is_not_configured"),
        \ "configure"         : function("s:configure"),
        \ "list"              : function("s:list"),
        \
        \ "library"           : function("s:library")
        \ }
endfunction

"
" public::api
"
function s:library(library) dict
    if ! self.has(a:library)
        throw "lack of vital library: ".a:library
    endif

    if self.is_not_configured(a:library)
        call self.configure(a:library)
    endif

    return self._libraries[a:library]
endfunction


function s:has(library) dict
    return has_key(self._libraries, a:library)
endfunction

function s:is_not_configured(library) dict
    return empty(self._libraries[a:library])
endfunction

function s:configure(library) dict
    let self._libraries[a:library] = vital#vtbox#import(a:library)
endfunction

function s:list() dict
    return join(keys(self._libraries), ' ')
endfunction

"
" impl
"
let s:paths = {"install" : fnamemodify(expand('<sfile>'), ":p:h")."/../.." }

function s:manager()
    if empty(s:_manager_instance_)
        let s:_manager_instance_ = s:create_manager()
    endif
    return s:_manager_instance_
endfunction
let s:_manager_instance_ = {}

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
