"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function! vtbox#utils#unite#loc_list#create(source_name)
    let l:unite =  {
        \ 'source' : {
        \   'name' : "vtbox::".a:source_name,
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

function s:create_buffer() dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(self.source.name))
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
    let l:context.items = map(getloclist(winnr()), "s:parse_loclist(v:val)")

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
