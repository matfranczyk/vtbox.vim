"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#toml#handler()
    return s:handler
endfunction

function vtbox#tasks#toml#file()
    return s:handler.file()
endfunction

function vtbox#tasks#toml#label()
    return "tasks"
endfunction

"
" impl:: task file contnet
"
let s:header_path = fnamemodify(expand('<sfile>'), ":p:h")."/header"

function s:header()
    return vtbox#utils#filesystem#get_file_content(
                \ s:header_path."/tasks.header")
endfunction

function s:task(command, description)
    return [
    \ "",
    \ "[[".vtbox#tasks#toml#label()."]]",
    \ "\t command     = '".a:command."'",
    \ "\t description = '".a:description."'",
    \ ]
endfunction

function s:content_factory()
    return extend(s:header(), s:task("ls -l", "[example] list file"))
endfunction


"
" impl :: project task file
"
let s:project_task_file = vtbox#workspace#manager().cache_path()."/async_tasks.toml"

let s:handler = vtbox#toml#handler#create(
            \ s:project_task_file,
            \ function('s:content_factory'))

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
