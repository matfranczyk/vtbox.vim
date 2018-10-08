"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#grep#object#new(data)
    return {
        \ "_data"    : vtbox#utils#shell#attributes#unify(a:data),
        \ "_pattern" : "",
        \
        \ "regex"       : function("s:regex"),
        \ "fixed"       : function("s:fixed"),
        \ "icase"       : function("s:icase"),
        \ "exclude_dir" : function("s:exclude_dir"),
        \
        \ "pattern"  : function("s:pattern"),
        \ "commands" : function("s:commands")
        \ }
endfunction

"
" impl
"
function s:regex(name) dict
    call map(self._data, 's:set_regex(v:val, '.string(a:name).')')
    call self.pattern(a:name)
endfunction

function s:set_regex(item, value)
    let a:item['regex'] = [a:value] | return a:item
endfunction


function s:fixed(name) dict
    call map(self._data, 's:set_fixed(v:val, '.string(a:name).')')
    call self.pattern(a:name)
endfunction

function s:set_fixed(item, value)
    let a:item['fixed'] = [a:value] | return a:item
endfunction


function s:icase() dict
    call map(self._data, 's:set_icase(v:val)')
endfunction

function s:set_icase(item)
    let a:item['insensitive'] = 1 | return a:item
endfunction


function s:exclude_dir() dict
    call map(self._data, 's:set_exclude_dir(v:val)')
endfunction

function s:set_exclude_dir(item)
    let a:item['exclude_dir'] = 1 | return a:item
endfunction


function s:commands() dict
    return vtbox#grep#command#shell#compose(deepcopy(self._data))
endfunction


function s:pattern(...) dict
    if empty(a:000) | return self._pattern | endif

    let self._pattern = a:1
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
