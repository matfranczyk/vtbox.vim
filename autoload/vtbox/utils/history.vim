"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#history#container(size)
    return {
    \ '_size' : a:size, '_buffer' : [],
    \
    \ 'save'     : function('s:save'),
    \ 'get_lifo' : function('s:get_lifo'),
    \ 'get_fifo' : function('s:get_fifo')
    \ }
endfunction

"
" public :: api
"
function s:save(value) dict
    call insert(self._buffer, a:value, 0)
    let self._buffer = s:lib.uniq(self._buffer)

    if len(self._buffer) > self._size
        call remove(self._buffer, self._size, -1)
    endif
endfunction

function s:get_lifo() dict
    return copy(self._buffer)
endfunction

function s:get_fifo() dict
    return copy(reverse(self._buffer))
endfunction

"
" impl
"
let s:lib = vtbox#vital#lib("Data.List")

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
