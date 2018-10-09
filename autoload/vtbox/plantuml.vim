"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#process(file)
    call system(join(['java', '-jar', s:bin, '-tutxt', '-failfast2', a:file]))
endfunction


function s:output_file(file)
    return vtbox#utils#filesystem#fileroot(a:file).'.utxt'
endfunction

let s:bin = fnamemodify(expand('<sfile>'), ":p:h")."/plantuml/bin/plantuml.jar"


"
" TODO
"
" PlantUML --convert=[utxt {default}|svg|png] //generuje
" PlantUML --convert=[utxt {default}|svg|png] --show //generuje i pokazuje
" PlantUML --show //pokazuje {to robi unite buffer with new window}

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
