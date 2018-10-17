"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#compile#file(file)
    call s:job.command(
                \ s:command(a:file))

    call s:job.launch( {'on_done_function' : function('s:on_done')} )
endfunction


"
" impl
"
function s:command(file)
    return join(['cat', a:file, '|', 'java', '-jar', vtbox#plantuml#bin(), '-pipe', '-syntax'])
endfunction


function s:on_done(...)
    if a:1 == 0
        return vtbox#plantuml#log("syntax ok")
    endif

    call vtbox#utils#vim#make_qflist(a:3)
    call vtbox#utils#unite#copen()

    return vtbox#plantuml#warn("syntax failed")
endfunction


let s:job = vtbox#job#async#create()

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
