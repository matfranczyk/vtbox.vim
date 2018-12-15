"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#unite#files_list#buffer(files_list, buffer_name)
    return s:unite().create_buffer(a:files_list, a:buffer_name)
endfunction


function vtbox#utils#unite#files_list#show(files)
    return s:unite().show_buffer(
                \ vtbox#utils#vim#is_list(a:files) ? a:files : [a:files])
endfunction

"
" impl
"
function s:unite()
"{{{
    if empty(s:__unite__)
        let s:__unite__ = vtbox#utils#unite#find#factory#create()
    endif
    return s:__unite__
endfunction
let s:__unite__ = {}
"}}}

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
