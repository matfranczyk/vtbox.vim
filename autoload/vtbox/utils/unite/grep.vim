"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#unite#grep#create_buffer(grep_output, buffer_name)
    return s:unite().create_buffer(
                \ a:grep_output,
                \ a:buffer_name)
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
        \   'name' : vtbox#utils#unite#source('grep'),
        \   'default_kind' : ["file", "jump_list"],
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
function s:create_buffer(grep_output, buffer_name) dict
    return unite#start(
        \   [self.source.name],
        \   s:create_context(copy(a:grep_output), a:buffer_name))
endfunction

"
" impl
"
let s:strings = vtbox#vital#lib('Data.String')

function s:candidate(item, text_width)
    return {
        \ "action__path" : a:item.file,
        \ "action__line" : a:item.line,
        \ "source__info" : [a:item.file, a:item.line, a:item.text],
        \
        \ "word"         : s:strings.pad_right(a:item.text, a:text_width)
        \                 ."\t"
        \                 .a:item.file,
        \ }
endfunction

function s:shorten_candidate(item)
    return {
        \ "word"         : s:strings.truncate_skipping(
        \                       a:item.text,
        \                       g:vtbox_buffer_width + len(g:__vtbox_buffer_shortner_sign), 0, g:__vtbox_buffer_shortner_sign)
        \                  ."\t".a:item.file,
        \ "action__path" : a:item.file,
        \ "action__line" : a:item.line,
        \ "source__info" : [a:item.file, a:item.line, a:item.text]
        \ }
endfunction


function s:get_max_width(items)
    let l:width = 1
    for item in a:items
        if item.text_width > l:width | let l:width = item.text_width | endif
    endfor

    return l:width
endfunction


function s:gather_candidates(args, context)
    let l:width = s:get_max_width(a:context.items)

    if l:width <= g:vtbox_buffer_width
        return map(a:context.items, "s:candidate(v:val, ".l:width.")")
    endif

    return map(a:context.items, "s:shorten_candidate(v:val)")
endfunction


function s:create_context(grep_output, buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = 0
    let l:context.items = map(a:grep_output, "s:parse_grep(v:val)")

    return l:context
endfunction


function s:parse_grep(line)
    let l:parsed = matchlist(a:line,
                            \ '^\(.*\):\(\d\+\)\%(:\(\d\+\)\)\?:\(.*\)$')

    if empty(l:parsed) || empty(l:parsed[1]) || empty(l:parsed[4])
        return []
    endif

    if l:parsed[1] =~ ':\d\+$'
        let l:parsed = matchlist(a:line,
                                \ '^\(.*\):\(\d\+\):\(\d\+\):\(.*\)$')
    endif

    let l:text = substitute(s:strings.trim(l:parsed[4]), '\t', ' ', 'g')
    return {
        \ "file"       : fnamemodify(l:parsed[1], ':.'),
        \ "line"       : l:parsed[2] == '' ? '1' : l:parsed[2],
        \ 'column'     : l:parsed[3] == '' ? '0' : l:parsed[3],
        \ 'text'       : l:text,
        \ 'text_width' : len(l:text)
        \ }
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
