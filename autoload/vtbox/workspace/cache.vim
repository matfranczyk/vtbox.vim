"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" usr:api
"
function vtbox#workspace#cache#local()
"{{{
    if empty(s:_instance_)
        let s:_instance_ = s:factory()
    endif
    return s:_instance_
endfunction
let s:_instance_ = {}
"}}}

function vtbox#workspace#cache#dirname()
    return s:dirname
endfunction

"
" ipml
"
let s:dirname = get(g:, 'vimrc_cache_dirname', '.vim.cache')


function s:factory()
    let l:cache = {
        \ '_settings' : {
        \       'local'   : get(g:, 'vimrc_cache_local_path',  getcwd()."/".s:dirname),
        \       'hybrid'  : get(g:, 'vimrc_cache_hybrid_path', expand("$HOME")."/".s:dirname."/hybrid/".substitute(getcwd(), '/', '_', 'g'))
        \ },
        \ '_select_path' : function('s:_select_path'),
        \ '_path'        : vtbox#utils#optional#create('vtbox:workspace:cache:path'),
        \
        \ 'is_available' : function('s:is_available'),
        \ 'create'       : function('s:create'),
        \ 'path'         : function('s:path'),
        \ }

    call l:cache._select_path() | return l:cache
endfunction

"
" obj:public
"
function s:path() dict
    return self._path.value()
endfunction


function s:is_available() dict
    return self._path.has_value()
endfunction


function s:create() dict
    try
        call vtbox#utils#filesystem#ensure_directory(self._settings.local)
    catch
        call vtbox#utils#filesystem#ensure_directory(self._settings.hybrid)
    endtry

    call self._select_path()
endfunction

"
" obj:private
"
function s:_select_path() dict
    if isdirectory(self._settings.local)
        return self._path.value(self._settings.local)
    endif

    if isdirectory(self._settings.hybrid)
        return self._path.value(self._settings.hybrid)
    endif
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
