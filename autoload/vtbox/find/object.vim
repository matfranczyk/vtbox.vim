"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#find#object#new(data)
    return {
        \ "_data"    : vtbox#utils#shell#attributes#unify(a:data),
        \ "_pattern" : "",
        \
        \ "names"    : function("s:names"),
        \ "inames"   : function("s:inames"),
        \
        \ "pattern"  : function("s:pattern"),
        \ "commands" : function("s:commands")
        \ }
endfunction

"
" impl
"
function s:names(name) dict
    call map(self._data, 's:set_name(v:val, '.string(a:name).')')
    call self.pattern(a:name)
endfunction

function s:set_name(item, value)
    let a:item['names'] = [a:value] | return a:item
endfunction


function s:inames(name) dict
    call map(self._data, 's:set_iname(v:val, '.string(a:name).')')
    call self.pattern(a:name)
endfunction

function s:set_iname(item, value)
    let a:item['inames'] = [a:value] | return a:item
endfunction


function s:commands() dict
    return vtbox#find#command#shell#compose(deepcopy(self._data))
endfunction


function s:pattern(...) dict
    if empty(a:000) | return self._pattern | endif

    let self._pattern = a:1
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
