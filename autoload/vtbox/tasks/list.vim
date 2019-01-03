"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#list#show()
    return s:tasks().create_buffer()
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
        \   'name' : vtbox#stamp(vtbox#tasks#stamp(), 'list'),
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

    let l:items = [] | let i = 0

    while i < len(a:context.items)
        call add(l:items, s:candidate(l:tittles[i], l:cmds[i]))
    let i += 1 | endwhile

    return l:items
endfunction

function s:candidate(task_title, command)
    return {
        \ "word"            : a:task_title.' =>  '.a:command,
        \ "action__command" : printf(
        \                       'call vtbox#tasks#async(%s, %s)',
        \                       string(a:task_title),
        \                       string(a:command))
        \ }

endfunction


function s:create_context(buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = vtbox#utils#unite#wipe_buffer()
    let l:context.items = vtbox#tasks#toml#handler().parse()

    return l:context
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------