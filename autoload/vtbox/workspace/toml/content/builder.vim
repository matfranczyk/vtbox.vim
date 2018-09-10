"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#workspace#toml#content#builder#create(header_file)
    return {
        \ "_header_file" : a:header_file,
        \
        \ "_product" : [],
        \
        \ "_header_content" : function("s:_header_content"),
        \ "_convert"        : function("s:_convert"),
        \ "_convert_item"   : function("s:_convert_item"),
        \
        \ "add"     : function("s:add"),
        \ "content" : function("s:content"),
        \ }
endfunction

"
" obj::api
"
function s:add(arg) dict
    call add(self._product, [a:arg])
endfunction


function s:content() dict
    return extend(self._header_content(),
                \ vtbox#vital#lib('Data.List').flatten(
                \       self._convert(deepcopy(self._product))))
endfunction

"
" obj::impl
"
function s:_header_content() dict
    return vtbox#utils#filesystem#get_file_content(self._header_file)
endfunction


function s:_convert(arg) dict
    return map(a:arg, 'self._convert_item(v:val[0])')
endfunction


function s:_convert_item(dictionary) dict
    let l:outcome = ["", "[[".vtbox#workspace#toml#content#attributes#key()."]]"]

    for key in keys(a:dictionary)
        call add(l:outcome, " ".key." = ".string(a:dictionary[key]))
    endfor

    return l:outcome
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
