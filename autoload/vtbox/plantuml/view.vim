"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#view#file(file)
    call s:job.command(
                \ s:command(a:file))

    call s:job.launch({ 'on_done_function' : function('s:on_done', [a:file]) })
endfunction

"
" impl
"

function s:on_done(file, ...)
    if a:1 == 0
        execute 'vsplit '.s:output_file(a:file)
        return
    endif

    call vtbox#utils#vim#make_qflist(a:3)
    call vtbox#utils#unite#copen()

    return vtbox#plantuml#warn("cannot generate uml for ".a:file)
endfunction


function s:output_file(file)
    return s:output_path()
         \ .vtbox#utils#filesystem#fileroot(
         \      vtbox#utils#filesystem#filename(a:file)).'.utxt'
endfunction

function s:output_path()
    return vtbox#cache_path().'/plantuml/'
endfunction

function s:command(file)
    return vtbox#plantuml#save#command(a:file, 'utxt').' -o '.s:output_path()
endfunction


let s:job = vtbox#job#async#create()

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
