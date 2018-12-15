"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function! vtbox#utils#unite#qflist#create_buffer(name, ...)
    if ! empty(a:000)
        call vtbox#utils#vim#populate_qflist(a:000)
    endif

    return s:unite().create_buffer(a:name)
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
        \   'name' : "[vtbox] qflist",
        \   'default_kind' : 'jump_list',
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
function s:create_buffer(buffer_name) dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(a:buffer_name))
endfunction


function s:gather_candidates(args, context)
    return map(a:context.items, 's:candidate(v:val)')
endfunction

function s:candidate(item)
    return {
        \ "word"              : vtbox#utils#string#format(a:item.text, 100)
        \                       ."\t".vtbox#utils#filesystem#relative_path(a:item.file).":".a:item.line,
        \ "action__path"      : a:item.file,
        \ "action__buffer_nr" : a:item.bufnr,
        \ "action__line"      : a:item.line,
        \ }
endfunction


function s:create_context(buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = 0
    let l:context.items = map(getqflist(), "s:parse_loclist(v:val)")

    return l:context
endfunction

function s:parse_loclist(line)
    let l:bufnr = a:line.bufnr

    return {
        \ "bufnr" : l:bufnr,
        \ "file"  : l:bufnr == 0 ? "" : bufname(l:bufnr),
        \ "text"  : vtbox#utils#string#trim(a:line.text),
        \ "line"  : l:bufnr == 0 ? 0 : a:line.lnum
        \ }
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
