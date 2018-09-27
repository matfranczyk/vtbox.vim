"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function unite#filters#vtbox_gtags_filter#define()
    return s:converter
endfunction

"
" api::impl
"
let s:strings = vtbox#vital#lib('Data.String')

let s:converter = {
    \ 'name'        : 'vtbox_gtags_filter',
    \ 'description' : 'gtags: output format',
    \}


function s:converter.filter(candidates, context) abort "{{{
    let l:width = s:get_max_width(map(a:candidates, 's:clean_text(v:val)'))

    if l:width <= g:vtbox_buffer_width
        return map(a:candidates, "s:candidate(v:val, ".l:width.")")
    endif

    return map(a:candidates, "s:shorten_candidate(v:val)")
endfunction


function s:candidate(item, text_width)
    let a:item.word = s:strings.pad_right(a:item.word, a:text_width)
                    \ ."\t"
                    \ .a:item.action__path

    return a:item
endfunction

function s:shorten_candidate(item)
    let a:item.word = s:strings.truncate_skipping(
                \           a:item.word,
                \           g:vtbox_buffer_width + len(g:__vtbox_buffer_shortner_sign), 0, g:__vtbox_buffer_shortner_sign)
                \     ."\t"
                \     .a:item.action__path

    return a:item
endfunction


function s:clean_text(line)
    let a:line.word = s:strings.trim(
                        \  substitute(
                        \       a:line.word,
                        \       a:line.action__path." |".a:line.action__line."|",
                        \       "",
                        \       ""))
    let a:line["text_width"] = len(a:line.word)

    return a:line
endfunction


function s:get_max_width(items)
    let l:width = 1
    for item in a:items
        if item.text_width > l:width | let l:width = item.text_width | endif
    endfor

    return l:width
endfunction



"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
