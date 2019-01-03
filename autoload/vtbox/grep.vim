"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#grep#execute(object, ...)
    try
        let l:stdout = vtbox#grep#system_call(a:object)
    catch
        return vtbox#show_exception(s:label, "problem with system execution")
    endtry

    if empty(l:stdout)
        return vtbox#echo(s:label, "pattern has not been found: [".a:object.pattern()."]")
    endif

    return vtbox#utils#unite#grep#create_buffer(
                \ l:stdout,
                \ empty(a:000) ? 'grep' : a:1)
endfunction


function vtbox#grep#system_call(object)
    let l:stdout =  vtbox#utils#vim#systemlist(
                        \s:command(a:object))

    if v:shell_error > 1
        call vtbox#throw(s:label, "v:shell_error: ".v:shell_error)
    endif

    return l:stdout
endfunction


"
" impl
"
let s:label = 'grep'

function s:command(object)
    return join(a:object.commands(), " ; ")
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
