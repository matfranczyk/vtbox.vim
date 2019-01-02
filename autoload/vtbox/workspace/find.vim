"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" API::user
"
function vtbox#workspace#find#current_word(...)
    call vtbox#workspace#find#filename(
                \ vtbox#utils#vim#cfile(),
                \ empty(a:000) ? "edit" : a:1)
endfunction


function vtbox#workspace#find#visual_word(...)
    call vtbox#workspace#find#filename(
                \ vtbox#utils#vim#selected_string(),
                \ empty(a:000) ? "edit" : a:1)
endfunction


let s:label = 'find::workspace'

function vtbox#workspace#find#filename(filename_pattern, opening_mode)
    try
        let l:object = vtbox#workspace#find#settings#get().object()
        call l:object.names(a:filename_pattern)
    catch
        return vtbox#show_exception(s:label, "cannot set 'names' property")
    endtry

    call vtbox#find#execute(l:object, a:opening_mode)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
