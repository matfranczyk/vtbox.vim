"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#save#file(file, format)
    call s:job.command(
                \ vtbox#plantuml#save#command(a:file, a:format))

    call s:job.launch( {'on_done_function' : function('s:on_done', [a:file, a:format])} )
endfunction


function vtbox#plantuml#save#command(file, format)
    return join(['java', '-jar', vtbox#plantuml#bin(), '-'.s:format(a:format), '-failfast2', a:file])
endfunction

"
" impl
"
function s:on_done(file, format, ...)
    if a:1 == 0
        return vtbox#plantuml#log("file saved: ".s:out_file(a:file, a:format))
    endif

    call vtbox#utils#vim#make_qflist(a:3)
    call vtbox#utils#unite#copen()

    return vtbox#plantuml#warn("cannot save file: ".a:file)
endfunction


function s:out_file(file, format)
    return vtbox#utils#filesystem#fileroot(a:file).".".a:format
endfunction


function s:format(format)
    if a:format == 'txt'
        return 'utxt'
    else
        return 't'.a:format
    endif
endfunction


let s:job = vtbox#job#async#create()

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
