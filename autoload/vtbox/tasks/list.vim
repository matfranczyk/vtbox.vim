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

function s:create_context(buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = vtbox#utils#unite#wipe_buffer()
    let l:context.items = vtbox#tasks#toml#handler().parse()

    return l:context
endfunction

"
" impl::obj
"
function s:gather_candidates(args, context)
    let l:candidates = []

    if ! empty(vtbox#tasks#history#api().list())
        call s:fill_mru_tasks(l:candidates)
    endif

    call s:fill_files_tasks(l:candidates, a:context)

    return l:candidates
endfunction



function s:fill_mru_tasks(candidates)
    call extend(a:candidates,
                \ s:collect_tasks(vtbox#tasks#history#api().list(), s:labels.mru))
    call s:add_empty_line(a:candidates)
endfunction


function s:add_empty_line(candidates)
    call extend(a:candidates, [{ "word" : "",  "is_dummy" : 1 }])
endfunction


function s:fill_files_tasks(candidates, context)
    call extend(a:candidates,
        \ [{
        \  'word' : s:labels.open,
        \
        \ 'kind' : 'jump_list',
        \ 'action__path' : s:toml_file, 'action__line' : 0,
        \ }])

    call extend(a:candidates,
                \ s:collect_tasks(a:context.items[vtbox#tasks#toml#label()], s:labels.file))
endfunction


function s:collect_tasks(items, label)
    return map(a:items, printf('s:task_candidate(v:val, %s)', string(a:label)))
endfunction


function s:task_candidate(item, label)
    return {
        \ 'word' : join([vtbox#utils#string#pad_right(a:label, s:label_width),
        \                vtbox#utils#string#format(a:item.description, s:spacing),
        \                "[cmd]",
        \                a:item.command]),
        \
        \ 'kind' : 'command',
        \ 'action__command' : printf(
        \                       'call vtbox#tasks#async(%s, %s)',
        \                       string(a:item.description),
        \                       string(a:item.command)),
        \ }
endfunction





"
" impl
"
let s:spacing = 50

let s:labels = {'file' : "[task]", 'mru' : "[mru]", 'open' : '[open::file]'}
let s:label_width = max( map(values(s:labels), 'len(v:val)') )
let s:toml_file = vtbox#utils#filesystem#substitute_path_separator(
            \ vtbox#tasks#toml#file())

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
