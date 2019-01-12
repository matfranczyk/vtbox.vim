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
    let l:tasks = s:collect_tasks(
            \ a:context.items[vtbox#tasks#toml#label()],
            \ "[task]",
            \ ":: tasks from file: ")

    if empty(vtbox#tasks#history#api().list())
        return l:tasks
    endif

    return s:collect_tasks(vtbox#tasks#history#api().list(), "")
       \ + s:comments("")
       \ + l:tasks
endfunction


function s:collect_tasks(items, label, ...)
    let l:tasks = map(a:items, printf('s:task_candidate(v:val, %s)', string(a:label)))

    if !empty(a:000)
        return extend(s:comments(a:000), l:tasks)
    endif

    return l:tasks
endfunction

let s:label = '[task]'
let s:label_width = len(s:label)

function s:task_candidate(item, label)
    return {
        \ "word" : join([vtbox#utils#string#pad_right(a:label, s:label_width),
        \                vtbox#utils#string#format(a:item.description, s:spacing),
        \                "[command]",
        \                a:item.command]),
        \
        \ "action__command" : printf(
        \                       'call vtbox#tasks#async(%s, %s)',
        \                       string(a:item.description),
        \                       string(a:item.command))
        \ }
endfunction


function s:comment_candidate(text)
    return { "word" : a:text, "action__command" : '' }
endfunction

function s:comments(txt)
    return map(type(a:txt) == type([]) ? copy(a:txt) : [a:txt],
            \ 's:comment_candidate(v:val)')
endfunction


function s:create_context(buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = vtbox#utils#unite#wipe_buffer()
    let l:context.items = vtbox#tasks#toml#handler().parse()

    return l:context
endfunction

"
" impl
"
let s:spacing = 50

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
