"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#utils#filesystem#current_file()
    return expand("%:p")
endfunction

function vtbox#utils#filesystem#current_filename()
    return expand("%:t")
endfunction

function vtbox#utils#filesystem#full_path(filename_or_path)
    return fnamemodify(a:filename_or_path, ":p")
endfunction


function vtbox#utils#filesystem#relative_path(file)
    return fnamemodify(a:file, ':.')
endfunction


function vtbox#utils#filesystem#filename(file)
    return fnamemodify(a:file, ":t")
endfunction


function vtbox#utils#filesystem#parent_path(file)
    return fnamemodify(a:file, ':p:h')
endfunction


function vtbox#utils#filesystem#dirname(path)
    return fnamemodify(a:path, ':t')
endfunction


function vtbox#utils#filesystem#ensure_directory(path)
    if !isdirectory(a:path)
        call mkdir(a:path, 'p')
    endif
endfunction

function vtbox#utils#filesystem#fetch_directory(path)
    call vtbox#utils#filesystem#ensure_directory(a:path) | return a:path
endfunction

function vtbox#utils#filesystem#delete(file)
    if isdirectory(a:file)
        call system("rm -r ".a:file)
    endif

    call system("rm ".a:file)
endfunction


function vtbox#utils#filesystem#get_file_content(file)
    call s:buffers_lib.open(a:file, {"opener" : "split"})
    let l:data = getline(1, "$") | silent bdelete

    return l:data
endfunction

function! vtbox#utils#filesystem#set_file_content(file, list_of_lines)
    call vtbox#utils#filesystem#ensure_directory(
        \ vtbox#utils#filesystem#parent_path(a:file))

    call s:buffers_lib.open(a:file, {"opener" : "split"})
    call s:buffers_lib.edit_content(a:list_of_lines)

    silent write | silent bdelete
endfunction


function vtbox#utils#filesystem#substitute_path_separator(path)
    return s:prelude_lib.substitute_path_separator(a:path)
endfunction


function vtbox#utils#filesystem#return_first_valid_directory(...)
    for directory in a:000
        if isdirectory(directory)
            return directory
        endif
    endfor

    return ""
endfunction


let s:prelude_lib = vtbox#vital#lib('Prelude')
let s:buffers_lib = vtbox#vital#lib('Vim.Buffer')

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
