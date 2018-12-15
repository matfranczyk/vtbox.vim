"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#list()
    return s:tasks().create_buffer()
endfunction

"
" impl :: logging
"
function s:log(text)
    call vtbox#log#echo(s:msg(a:text))
endfunction

function s:warn(text)
    call vtbox#log#error(s:msg(a:text))
endfunction

function s:msg(text)
    return "[Tasks] ".a:text
endfunction

function s:buffer(msg)
    return "tasks::".a:msg
endfunction

let s:buffer_outcome = s:buffer('outcome')

"
" impl :: async::jobs
"
let s:job = vtbox#job#async#create()

function vtbox#tasks#async(task_title, command)
    if s:job.is_running()
        return s:warn("previous task's running, please wait oj kill working job :: ".s:job.command())
    endif

    call s:job.command(a:command)
    call s:job.launch( {'on_done_function' : function('s:on_done_job', [a:task_title])} )
endfunction


function s:on_done_job(task_title, exit_status, stdout, stderr, time_start, time_stop)
    if a:exit_status == 0
        call s:log('done :: '.a:task_title)
    else
        call s:show_error(a:stderr, 'failed :: '.a:task_title)
    endif

    return vtbox#tasks#snapshot#save(a:task_title, a:exit_status, a:stdout, a:stderr, a:time_start, a:time_stop)
endfunction


function s:show_error(stderr, msg)
    call vtbox#utils#unite#list#create_buffer(
                \ vtbox#utils#unite#source('task '),
                \ a:stderr,
                \ a:stdout)
    call s:warn(a:msg)
endfunction


"
" impl :: tasks
"
function s:tasks()
"{{{
   if empty(s:__tasks__)
       let s:__tasks__ = s:create_tasks()
   endif

   return s:__tasks__
endfunction
let s:__tasks__ = {}
"}}}

function s:create_tasks()
    let l:unite =  {
        \ 'source' : {
        \   'name' : vtbox#utils#unite#source('tasks execution stderr'),
        \   'default_kind' : 'command',
        \
        \   'gather_candidates' : function('s:gather_candidates'),
        \ },
        \ 'create_buffer' : function('s:create_buffer')
        \ }

    call unite#define_source(l:unite.source)

    return l:unite
endfunction


function s:create_buffer() dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(self.source.name))
endfunction


function s:gather_candidates(args, context)
    let l:tittles = keys(a:context.items)
    let l:cmds    = values(a:context.items)

    let l:items = []
    let i = 0
    let l:size = len(a:context.items)

    while i < l:size
        call add(l:items, s:candidate(l:tittles[i], l:cmds[i]))
    let i += 1 | endwhile

    return l:items
endfunction


function s:action(task_title, command)
    return 'call vtbox#tasks#async('.string(a:task_title).', '.string(a:command).')'
endfunction

function s:candidate(task_title, command)
    return {
        \ "word"            : a:task_title.' :: '.a:command,
        \ "action__command" : s:action(a:task_title, a:command),
        \ "action__histadd" : 1,
        \ }
endfunction


function s:create_context(buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = 0
    let l:context.items = vtbox#tasks#toml#handler().parse()

    return l:context
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
