"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#snapshot#save(task_title, exit_status, stdout, stderr, time_start, time_stop)
    return s:snapshot().save(a:task_title, a:exit_status, a:stdout, a:stderr, a:time_start, a:time_stop)
endfunction


function vtbox#tasks#snapshot#output(buffer_name)
    call vtbox#utils#unite#qflist#create_buffer(
                \ a:buffer_name,
                \ s:snapshot()._stdout,
                \ s:snapshot()._stderr)

    call vtbox#log#echo(s:snapshot().info())
endfunction

" function vtbox#tasks#snapshot#stdout(buffer_name)
"     call vtbox#utils#unite#qflist#create_buffer(
"                 \ a:buffer_name,
"                 \ s:snapshot()._stdout)

"     call vtbox#log#echo(s:snapshot().info())
" endfunction

" function vtbox#tasks#snapshot#stderr(buffer_name)
"     call vtbox#utils#unite#qflist#create_buffer(
"                 \ a:buffer_name,
"                 \ s:snapshot()._stderr)

"     call vtbox#log#echo(s:snapshot().info())
" endfunction

"
" impl
"
function s:snapshot()
"{{{
    if empty(s:__snapshot__)
        let s:__snapshot__ = s:create()
    endif
    retur s:__snapshot__
endfunction
let s:__snapshot__ = {}
"}}}

function s:create()
    return {
        \ '_title'      : {},
        \ '_exit_status': {},
        \ '_stdout'     : {},
        \ '_stderr'     : {},
        \ '_time_start' : {},
        \ '_time_stop'  : {},
        \
        \  'save' : function('s:save'),
        \  'info' : function('s:info'),
        \ }
endfunction

"
" obj::api
"
function s:save(task_title, exit_status, stdout, stderr, time_start, time_stop) dict
    let self._title = a:task_title
    let self._exit_status = a:exit_status
    let self._stdout = copy(a:stdout)
    let self._stderr = copy(a:stderr)
    let self._time_start = a:time_start
    let self._time_stop = a:time_stop
endfunction


function s:info() dict
    return join(
                \ [
                \ "[Tasks] tittle :".self._title,
                \ "status : ".self._exit_status,
                \ "{started, stopped} : {".self._time_start.", ".self._time_stop."}"
                \ ], " | ")
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
