"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#save_file(file, format)
    call system(s:save_command(a:file, a:format))
endfunction


function vtbox#plantuml#output_file(file, format)
    return vtbox#utils#filesystem#fileroot(a:file).'.'.a:format
endfunction


function vtbox#plantuml#bin()
    return s:bin
endfunction


function vtbox#plantuml#log(text)
    call vtbox#log#echo(s:log(a:text))
endfunction

function vtbox#plantuml#warn(text)
    call vtbox#log#warning(s:log(a:text))
endfunction

"
" impl
"
let s:bin = fnamemodify(expand('<sfile>'), ":p:h")."/plantuml/bin/plantuml.jar"

function s:log(text)
    return "[Plantuml] ".a:text
endfunction

function s:save_command(file, format)
    return join(['java', '-jar', s:bin, '-'.a:format, '-failfast2', a:file])
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
