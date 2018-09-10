"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#find#unite(object)
    call vtbox#find#execute(a:object, 'unite')
endfunction


function vtbox#find#execute(object, opening_mode)
    try
        let l:stdout = vtbox#find#system_call(a:object)
    catch
        return vtbox#exception#log(s:log("problem with system execution"))
    endtry

    if empty(l:stdout)
        return vtbox#log#echo(s:log("file has not been found: [".a:object.pattern()."]"))
    endif

    if (a:opening_mode == "unite") || (len(l:stdout) > 1)
        return s:unite().create_buffer(l:stdout)
    endif

    return vtbox#utils#vim#open_file(l:stdout[0], a:opening_mode)
endfunction


function vtbox#find#system_call(object)
    let l:stdout =  vtbox#utils#vim#systemlist(s:command(a:object))

    if v:shell_error
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


function s:log(...)
    let l:txt = empty(a:000) ? "" : a:1
    return "[find] ".l:txt
endfunction


function s:unite()
    if empty(s:_unite_instance_)
        let s:_unite_instance_ = vtbox#utils#unite#find#factory("find_files")
    endif
    return s:_unite_instance_
endfunction
let s:_unite_instance_ = {}

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
