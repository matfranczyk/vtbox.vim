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
function s:execute(fixed_pattern)
    try
        let l:object = vtbox#workspace#grep#settings#get().object()
        call l:object.fixed(a:fixed_pattern)
    catch
        return vtbox#exception#log("[workspace:grep:object]")
    endtry

    call vtbox#grep#execute(l:object)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
