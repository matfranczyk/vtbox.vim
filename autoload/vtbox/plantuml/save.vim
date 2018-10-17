"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#save#file(file, format)
    call s:job.command(
                \ s:command(a:file, a:format))

    call s:job.launch( {'on_done_function' : function('s:on_done', [a:file])} )
endfunction

"
" impl
"
function s:command(file, format)
    return join(['java', '-jar', vtbox#plantuml#bin(), '-'.a:format, '-failfast2', a:file])
endfunction


function s:on_done(file, ...)
    if a:1 == 0
        return vtbox#plantuml#log("file saved: ".a:file)
    endif

    call vtbox#utils#vim#make_qflist(a:3)
    call vtbox#utils#unite#copen()

    return vtbox#plantuml#warn("cannot save file: ".a:file)
endfunction


let s:job = vtbox#job#async#create()

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
