"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function! vtbox#grep#attributes#new()
    return {
    \ 'fixed'        : [],
    \ 'regex'        : [],
    \ 'paths'        : [],
    \ 'insensitive'  : [],
    \ 'include'      : [],
    \ 'exclude'      : [],
    \ 'exclude_dir'  : [],
    \}
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
