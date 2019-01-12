"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#history#api()
"{{{
    if empty(s:__instance__)
        let s:__instance__ = s:create(3)
    endif

    return s:__instance__
endfunction
let s:__instance__ = {}
"}}}

function s:create(size)
    return {
        \ '_history' : vtbox#utils#history#container(a:size),
        \
        \ 'save' : function('s:save'),
        \ 'list' : function('s:list'),
        \ }
endfunction

"
" object :: api
"
function s:save(command, description) dict
    call self._history.save(
                \ {'command' : a:command, 'description' : a:description})
endfunction

function s:list() dict
    return self._history.get_lifo()
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
