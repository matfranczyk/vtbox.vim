"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#workspace#configs#show(files_list, buffer_name)
    return s:unite().create_buffer(a:files_list, a:buffer_name)
endfunction

"
" impl
"
function s:unite()
    if empty(s:__unite__)
        let s:__unite__ = vtbox#utils#unite#find#factory("worksapce::files")
    endif
    return s:__unite__
endfunction
let s:__unite__ = {}

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
