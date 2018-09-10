"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#grep#execute(object)
    try
        let l:stdout = vtbox#grep#system_call(a:object)
    catch
        return vtbox#exception#log(s:log("problem with system execution"))
    endtry

    if empty(l:stdout)
        return vtbox#log#echo(s:log("pattern has not been found: [".a:object.pattern()."]"))
    endif

    return s:unite().create_buffer(l:stdout)
endfunction


function vtbox#grep#system_call(object)
    let l:stdout =  vtbox#utils#vim#systemlist(
                        \s:command(a:object))

    if v:shell_error > 1
        throw s:log("v:shell_error: ".v:shell_error)
    endif

    return l:stdout
endfunction


"
" impl
"
function s:command(object)
    return join(a:object.commands(), " ; ")
endfunction


function s:log(msg)
    return "[grep] ".a:msg
endfunction


function s:unite()
    if empty(s:_unite_instance_)
        let s:_unite_instance_ = vtbox#utils#unite#grep#factory("grep")
    endif
    return s:_unite_instance_
endfunction
let s:_unite_instance_ = {}

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
