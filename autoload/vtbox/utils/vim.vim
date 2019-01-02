"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#utils#vim#options(dialog_info, options)
"{{{
    if type(a:options) == type([])
        return s:dialog_with_list_of_options(a:dialog_info, a:options)
    endif

    return s:dialog_with_map_of_options(a:dialog_info, a:options)
endfunction


function s:dialog_with_list_of_options(dialog_info, list_of_options)
    let l:options = []

    let l:i = 1
    for item in a:list_of_options
        call add(l:options, l:i.'. '.item) | let l:i += 1
    endfor

    while 1
		let l:answer = inputlist([a:dialog_info] + l:options)
		if l:answer >= 1 && l:answer <= len(a:list_of_options)
            return a:list_of_options[l:answer - 1]
        endif
    endwhile
endfunction

function! s:dialog_with_map_of_options(text, options_map)
    let l:options = []
    let l:keys = keys(a:options_map)

    let l:i = 1
    for item in l:keys
        call add(l:options, l:i.'. '.item) | let l:i += 1
    endfor

    while 1
        let l:answer = inputlist([a:text] + l:options)
        if l:answer >= 1 && l:answer <= len(l:keys)
            return a:options_map[l:keys[l:answer - 1]]
        endif
    endwhile
endfunction
"}}}

function vtbox#utils#vim#is_list(arg)
    return type(a:arg) == type([])
endfunction

function vtbox#utils#vim#is_dictionary(arg)
    return type(a:arg) == type({})
endfunction

function vtbox#utils#vim#is_string(arg)
    return type(a:arg) == type("")
endfunction

function vtbox#utils#vim#is_number(arg)
    return type(a:arg) == type(1) || type(a:arg) == type(1.1)
endfunction


function vtbox#utils#vim#is_list_of_dictionaries(arg)
    for item in a:arg
        if type(item) != type({})
            return 0
        endif
    endfor

    return 1
endfunction


function s:llists_buffer_numbers()
    redir =>l:buffer_list | silent! ls  | redir END
    return map(
        \ filter(split(l:buffer_list, '\n'),
        \        'v:val =~ "Location List"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
endfunction

function vtbox#utils#vim#is_llist()
    let l:current_buffer_number = winbufnr(0)
    return !empty(filter(s:llists_buffer_numbers(), 'v:val == l:current_buffer_number'))
endfunction


function s:open_error_list(cmd)
    try | execute a:cmd | catch
        return vtbox#echo("error list doesn't exist")
    endtry
endfunction

function vtbox#utils#vim#previous_error_list()
    if vtbox#utils#vim#is_llist()
        return s:open_error_list("lolder")
    endif

    return s:open_error_list("colder")
endfunction

function vtbox#utils#vim#next_error_list()
    if vtbox#utils#vim#is_llist()
        return s:open_error_list("lnewer")
    endif

    return s:open_error_list("cnewer")
endfunction


function vtbox#utils#vim#cfile() abort
    try
        return split(expand("<cfile>"), "/")[-1]
    catch
        throw "no filename found under cursor"
    endtry
endfunction


function vtbox#utils#vim#shellescape(string)
    return escape(a:string, "()'*")
endfunction


function vtbox#utils#vim#selected_string()
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]

    return join(lines, "\n")
endfunction


function vtbox#utils#vim#populate_qflist(data)
    if !vtbox#utils#vim#is_list(a:data)
        silent cexpr a:data | return
    endif

    silent cexpr a:data[0]

    let i = 1 | let size = len(a:data)
    while i < size
        silent caddexpr a:data[i]
    let i += 1 | endwhile
endfunction


function vtbox#utils#vim#open_file(file, mode)
    silent execute a:mode." ".a:file
endfunction


function vtbox#utils#vim#watch_time()
    return strftime("%H:%M:%S")
endfunction


function vtbox#utils#vim#system(command)
    return substitute(system(a:command), '\r', '', 'g')
endfunction


function vtbox#utils#vim#systemlist(command)
    return split(vtbox#utils#vim#system(a:command), '\n')
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
