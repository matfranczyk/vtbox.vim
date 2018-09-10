"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#shell#attributes#unify(data)
    if ! s:is_input_valid(a:data)
        throw "cannot convert! invalid input's format"
    endif

    return map(vtbox#utils#vim#is_list(a:data) ? copy(a:data) : [copy(a:data)],
            \ 's:format_attributes(v:val)')
endfunction

"
" impl
"
function s:is_input_valid(data)
    return !empty(a:data) && (
        \    vtbox#utils#vim#is_dictionary(a:data) ||
        \    vtbox#utils#vim#is_list_of_dictionaries(a:data))
endfunction


function s:format_attributes(dict)
    return s:split_items(s:remove_empty_lists(a:dict))
endfunction



function s:split_items(dict)
    for key in keys(a:dict)
        if vtbox#utils#vim#is_string(a:dict[key])
            let a:dict[key] = split(a:dict[key], ',')
        endif
    endfor

    return a:dict
endfunction


function s:remove_empty_lists(dict)
    for key in keys(a:dict)
        if vtbox#utils#vim#is_list(a:dict[key]) && a:dict[key] == []
            unlet a:dict[key]
        endif
    endfor

    return a:dict
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
