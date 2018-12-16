"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function! vtbox#utils#unite#files_list#factory#create()
    let l:unite =  {
        \ 'source' : {
        \   'name' : vtbox#utils#unite#source('find::files'),
        \   'default_kind' : 'file',
        \
        \   'gather_candidates' : function('s:gather_candidates'),
        \ },
        \
        \ 'create_buffer' : function('s:create_buffer'),
        \ 'show_buffer'   : function('s:show_buffer')
        \ }

    call unite#define_source(l:unite.source)

    return l:unite
endfunction

"
" impl
"
let s:strings = vtbox#vital#lib('Data.String')

function s:create_buffer(files_list, buffer_name) dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(
        \       a:files_list,
        \       a:buffer_name,
        \       vtbox#utils#unite#persistent_buffer()))
endfunction

function s:show_buffer(files_list) dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(
        \       a:files_list,
        \       'files',
        \       vtbox#utils#unite#wipe_buffer()))
endfunction


function s:get_widths(items)
    let l:filename_width = 1 | let l:parent_width = 1
    for item in a:items

        if item.filename_width > l:filename_width | let l:filename_width = item.filename_width | endif
        if item.parent_width   > l:parent_width   | let l:parent_width   = item.parent_width   | endif
    endfor

    return {"filename" : l:filename_width, "parent" : l:parent_width}
endfunction

function s:candidate(item, widths_filename, widths_parent)
    return {
        \ "action__path" : vtbox#utils#filesystem#substitute_path_separator(a:item.file),
        \
        \ "word"         : s:strings.pad_right(a:item.filename, a:widths_filename)
        \                 ."\t"
        \                 .s:strings.pad_right(a:item.parent, a:widths_parent)
        \                 ."\t"
        \                 .fnamemodify(a:item.file, ':.'),
        \ }
endfunction


function s:gather_candidates(args, context)
    let l:widths = s:get_widths(a:context.items)

    return map(a:context.items, "s:candidate(v:val, ".l:widths.filename.", ".l:widths.parent.")")
endfunction


function s:create_context(files_list, buffer_name, wipe_buffer)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = a:wipe_buffer
    let l:context.items = map(copy(a:files_list), "s:parse_list(v:val)")

    return l:context
endfunction


function s:parse_list(line)
    let l:filename   = fnamemodify(a:line, ":t")
    let l:parent_dir = fnamemodify(a:line, ':p:h:t')

    return {
        \ "file"           : a:line,
        \ "filename"       : l:filename,
        \ "filename_width" : len(l:filename),
        \ "parent"         : l:parent_dir,
        \ "parent_width"   : len(parent_dir)
        \ }
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
