"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#vimfiler#single_file()
    let l:item = s:single_item(b:vimfiler)
    if filereadable(l:item)
        return l:item
    endif

    call vtbox#exception#throw("there's no readable file")
endfunction


function vtbox#vimfiler#get_items()
    return s:get_items(b:vimfiler)
endfunction


function vtbox#vimfiler#close_buffer()
    call vimfiler#util#delete_buffer(b:vimfiler.bufnr)
endfunction

"
" impl
"
function s:single_item(vimfiler_instance) abort
    let l:marked = vimfiler#get_marked_files(a:vimfiler_instance)
    if ! empty(l:marked)
        if len(l:marked) == 1
            return l:marked[0].action__path
        endif

        call vtbox#exception#throw('more than one item')
    endif

    try
        return vimfiler#get_file(a:vimfiler_instance, line('.')).action__path
    catch
        call vtbox#exception#throw('not action__path existed')
    endtry
endfunction


function s:get_items(vimfiler_instance) abort
    let l:marked = vimfiler#get_marked_files(a:vimfiler_instance)
    if !empty(l:marked)
        return map(l:marked, 'v:val.action__path')
    endif

    try
        return [ vimfiler#get_file(a:vimfiler_instance, line('.')).action__path ]
    catch
        call vtbox#exception#throw('not action__path existed')
    endtry
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
