"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#find#execute(find_object, opening_mode, ...)
    try
        let l:stdout = vtbox#find#system_call(a:find_object)
    catch
        return vtbox#show_exception(s:label, "problem with system execution")
    endtry

    if empty(l:stdout)
        return vtbox#echo(s:label, "file has not been found: [".a:find_object.pattern()."]")
    endif

    if (a:opening_mode == "unite") || (len(l:stdout) > 1)
        return vtbox#utils#unite#files_list#buffer(
            \ l:stdout,
            \ empty(a:000) ? s:label : a:1)
    endif

    return vtbox#utils#vim#open_file(l:stdout[0], a:opening_mode)
endfunction


function vtbox#find#system_call(find_object)
    let l:stdout =  vtbox#utils#vim#systemlist(s:command(a:find_object))

    if v:shell_error
        call vtbox#throw(s:label, "v:shell_error: ".v:shell_error)
    endif

    return l:stdout
endfunction

"
" impl
"
let s:label = 'find'

function s:command(find_object)
    return join(a:find_object.commands(), " ; ")
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
