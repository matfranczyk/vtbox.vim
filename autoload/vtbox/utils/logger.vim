"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#logger#create()
    return {
        \ "_buffer"  : [],
        \
        \ "empty"    : function("s:empty"),
        \ "append"   : function("s:append"),
        \ "clear"    : function("s:clear"),
        \ "withdraw" : function("s:withdraw"),
        \ }
endfunction

"
" object:api
"
function s:empty() dict
    return empty(self._buffer)
endfunction


function s:append(arg) dict
    call add(self._buffer, a:arg)
endfunction


function s:clear() dict
    let self._buffer = []
endfunction


function s:withdraw() dict
    let l:buffer = join(self._buffer, "\n")

    call self.clear() | return l:buffer
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
