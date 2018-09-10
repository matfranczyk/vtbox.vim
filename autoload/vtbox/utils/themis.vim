"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#utils#themis#assert_list_combination(got, expected)
    if len(a:got) != len(a:expected)
        return s:assert.fail(
            \ "list have different sizes\n".
            \ "expected size() = ".len(a:expected)."\n".
            \ "got      size() = ".len(a:got)."\n"
            \ )
    endif

    for item in a:got
        if index(a:expected, item) == -1
            call s:assert.fail(
                \ "values in lists are different\n".
                \ "first missing element: ".item."\n\n".
                \ "expected: ".string(a:expected)."\n".
                \ "got: ".string(a:got)."\n"
                \ )
        endif
    endfor
endfunction


function vtbox#utils#themis#assert_list_of_string(list)
    for item in a:list
        if !vtbox#utils#vim#is_string(item)
            call s:assert.fail(
                \ "it's not list of strings\n\n".
                \ "input: ".string(a:got)."\n"
                \ )
        endif
    endfor
endfunction

let s:assert = themis#helper('assert')

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
