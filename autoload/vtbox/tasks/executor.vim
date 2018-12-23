"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#executor#create(name)
    return {
        \ '_job' : vtbox#job#async#create(),
        \ '_current_context'  : vtbox#utils#optional#create('task:executor:current_context'),
        \ '_previous_context' : vtbox#utils#optional#create('task:executor:_previous_context'),
        \
        \ "start" : function('s:start')
        \ }
endfunction

"
" impl
"
function s:start(command, name) dict
    call self._job.command(a:command)

    call self._current_context.value(
        \ self._job.launch( {'on_done_function' : function('s:on_done_job', [self])} ))
endfunction


function s:on_done_job(context, exit_status, stdout, stderr, time_start, time_stop) dict
    if a:exit_status == 0
        echomsg 'OK: '.a:name
    endif

    echomsg 'failed: '.a:name

    call context._previous_context.value( context._current_context.value() )
endfunction

"---------------------------------------
let &cpo = s:cpo_ave | unlet s:cpo_save
"---------------------------------------
