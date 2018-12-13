"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#toml#handler()
    return s:handler
endfunction

"
" impl::private
"
let s:file = vtbox#workspace#manager().cache_path()."/async_tasks.toml"

function s:content_factory()
    return ["task_1 = 'clang --version'", "task_2 = 'clang --version'"]
endfunction

let s:handler = vtbox#toml#handler#create(s:file, function('s:content_factory'))

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
