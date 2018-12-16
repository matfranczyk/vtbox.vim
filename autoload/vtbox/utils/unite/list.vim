"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function! vtbox#utils#unite#list#create_buffer(name, ...)
    return s:unite().create_buffer(
                \ a:name,
                \ vtbox#vital#lib('Data.List').flatten(a:000)
                \ )
endfunction

"
" impl
"
function s:unite()
"{{{
    if empty(s:__unite__)
        let s:__unite__ = s:create()
    endif
    return s:__unite__
endfunction
let s:__unite__ = {}
"}}}

function! s:create()
    let l:unite =  {
        \ 'source' : {
        \   'name' : vtbox#utils#unite#source(),
        \   'default_kind' : 'common',
        \
        \   'gather_candidates' : function('s:gather_candidates'),
        \ },
        \
        \ 'create_buffer' : function('s:create_buffer')
        \ }

    call unite#define_source(l:unite.source)

    return l:unite
endfunction

"
" obj::api
"
function s:create_buffer(buffer_name, data_list) dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(a:buffer_name, a:data_list))
endfunction


function s:gather_candidates(args, context)
    return map(a:context.items, "{'word' : v:val}")
endfunction


function s:create_context(buffer_name, data_list)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = 0
    let l:context.items = a:data_list

    return l:context
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
