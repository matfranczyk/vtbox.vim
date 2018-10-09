"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
let s:bin = fnamemodify(expand('<sfile>'), ":p:h")."/plantuml/bin/plantuml.jar"

function vtbox#plantuml#save_file(file, format)
    call system(s:save_command(a:file, a:format))
endfunction


function vtbox#plantuml#check_syntax(file)
    call system(s:check_synstax_command(a:file))

    if v:shell_error
        echomsg "[plantuml] syntax error"
    else
        echomsg "[plantuml] syntax ok"
    endif
endfunction


function vtbox#plantuml#output_file(file, format)
    return vtbox#utils#filesystem#fileroot(a:file).'.'.a:format
endfunction


function s:save_command(file, format)
    return join(['java', '-jar', s:bin, '-'.a:format, '-failfast2', a:file])
endfunction

function s:check_synstax_command(file)
    return join(['cat', a:file, '|', 'java', '-jar', s:bin, '-pipe', '-syntax'])
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
