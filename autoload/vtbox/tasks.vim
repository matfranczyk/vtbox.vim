"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#async(task_title, command)
    if s:job.is_running()
        return vtbox#warning(vtbox#tasks#stamp(), "previous task's running, please wait or kill working job :: ".s:job.command())
    endif

    try
        call s:running_task.value(a:task_title)

        call s:job.command(a:command)
        call s:job.launch(s:properties(a:task_title))
    catch
        call s:running_task.reset()
        call vtbox#rethrow(
                    \ vtbox#stamp(vtbox#tasks#stamp(), 'fire up problem'))
    endtry
endfunction


function vtbox#tasks#running()
    return s:running_task
endfunction


function vtbox#tasks#stamp()
    return 'tasks'
endfunction

"
" impl :: async::jobs
"
let s:job = vtbox#job#async#create()

let s:running_task = vtbox#utils#optional#create(
            \ vtbox#stamp(vtbox#tasks#stamp(), 'running task'))

function s:properties(task_title)
    return {
        \ 'on_done_function' : function('s:on_done', [a:task_title])
        \ }
endfunction


function s:on_done(task_title, exit_status, stdout, stderr, time_start, time_stop)
    try
        if a:exit_status == 0
            call vtbox#message(vtbox#tasks#stamp(), 'done :: '.a:task_title)
        else
            call s:report_failed(a:stderr, 'failed :: '.a:task_title)
        endif

        call vtbox#tasks#executed#snapshot#api().save(
                    \ a:task_title,
                    \ a:exit_status,
                    \ a:stdout,
                    \ a:stderr,
                    \ a:time_start,
                    \ a:time_stop)
    finally
        call s:running_task.reset()
    endtry
endfunction


function s:report_failed(stderr, msg)
    call vtbox#utils#unite#qflist#create_buffer(
                \ vtbox#stamp(vtbox#tasks#stamp(),' last failed'),
                \ a:stderr)

    call vtbox#warning(vtbox#tasks#stamp(), a:msg)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
