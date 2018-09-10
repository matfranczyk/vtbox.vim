"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#utils#string#has(string, char)
    return stridx(a:string, a:char) != -1
endfunction

function vtbox#utils#string#trim(string)
    return s:string_lib.trim(a:string)
endfunction


function vtbox#utils#string#truncate_skipping(string, max_length, number_of_right_chars_to_left, separator)
    return s:string_lib.truncate_skipping(
                \ a:string,
                \ a:max_length,
                \ a:number_of_right_chars_to_left,
                \ a:separator)
endfunction


function vtbox#utils#string#pad_right(text, text_width)
    return s:string_lib.pad_right(a:text, a:text_width)
endfunction


function vtbox#utils#string#format(text, width)
    return s:string_lib.truncate_skipping(
                \   a:text,
                \   a:width,
                \   0,
                \   "....."
                \   )
endfunction


function vtbox#utils#string#extract(text)
    return substitute(s:string_lib.trim(a:text), '\t', ' ', 'g')
endfunction


let s:string_lib = vtbox#vital#lib('Data.String')

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
