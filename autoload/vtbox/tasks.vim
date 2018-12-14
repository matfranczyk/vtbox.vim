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
    call vtbox#log#warning(s:msg(a:text))
endfunction

function s:msg(text)
    return "[Tasks] ".a:text
endfunction

function s:buffer(msg)
    return "tasks::".a:msg
endfunction

let s:buffer_outcome = s:buffer('outcome')
let s:buffer_list    = s:buffer('list')

"
" impl :: async::jobs
"
let s:job = vtbox#job#async#create()

function vtbox#tasks#async(name, command)
    if s:job.is_running()
        return s:warn("previous task's running, please wait oj kill working job :: ".s:job.command())
    endif

    call s:job.command(a:command)
    call s:job.launch( {'on_done_function' : function('s:on_done_job', [a:name])} )
endfunction


function s:on_done_job(name, exit_status, stdout, stderr, time_start, time_stop)
    if a:exit_status == 0
        return s:log('done :: '.a:name)
    endif

    call s:error(a:stderr, 'failed :: '.a:name)
endfunction


function s:output()
"{{{
    if empty(s:__output__)
        let s:__output__ = vtbox#utils#unite#qflist#new(s:buffer_outcome)
    endif
    return s:__output__
endfunction
let s:__output__ = {}
"}}}


function s:error(stderr, msg)
    call vtbox#utils#vim#populate_qflist(a:stderr)
    call s:output().create_buffer(s:buffer_outcome)

    return s:warn(a:msg)
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
        \   'name' : s:buffer_list,
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
        \   s:create_context(s:buffer_list))
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


function s:action(name, command)
    return 'call vtbox#tasks#async('.string(a:name).', '.string(a:command).')'
endfunction

function s:candidate(name, command)
    return {
        \ "word"            : a:name.' :: '.a:command,
        \ "action__command" : s:action(a:name, a:command),
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
