"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#constants()
    let g:vtbox_buffer_width = 120

    let g:__vtbox_buffer_shortner_sign = '.....'
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
