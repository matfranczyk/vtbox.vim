"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" API::user
"
function vtbox#workspace#grep#current_word() abort
    call s:execute(expand('<cword>'))
endfunction


function vtbox#workspace#grep#visual_word() abort
    call s:execute(vtbox#utils#vim#selected_string())
endfunction

"
" impl
"
let s:label = 'grep::workspace'

function s:execute(fixed_pattern)
    try
        let l:object = vtbox#workspace#grep#settings#get().object()
        call l:object.fixed(a:fixed_pattern)
    catch
        return vtbox#show_exception(s:label, "cannot set 'fixed' property")
    endtry

    call vtbox#grep#execute(l:object, "grep::workspace")
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
