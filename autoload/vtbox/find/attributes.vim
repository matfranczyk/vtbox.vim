"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function! vtbox#find#attributes#new()
    return {
    \ 'paths'               : [],
    \ 'names'               : [],
    \ 'inames'              : [],
    \ 'exclude_file_names'  : [],
    \ 'exclude_file_inames' : [],
    \ 'exclude_dir_names'   : [],
    \ 'exclude_dir_inames'  : [],
    \}
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
