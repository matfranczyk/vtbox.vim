"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#utils#optional#create(name, ...)
    let l:obj = {
        \ "__name"  : a:name,
        \
        \ "is_initialized" : function("s:is_initialized"),
        \ "reset"          : function("s:reset"),
        \ "value"          : function("s:value"),
        \ }

    if !empty(a:000)
        let l:obj.__value = a:1
    endif

    return l:obj
endfunction


function s:is_initialized() dict
    return has_key(self, "__value")
endfunction


function s:reset() dict
    if self.is_initialized()
        unlet self.__value
    endif
endfunction


function s:value(...) dict
    if !empty(a:000) | let self.__value = deepcopy(a:1) | return | endif

    if self.is_initialized()
        return self.__value
    endif

    throw "parameter '".self.__name."' has not been initialized"
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
