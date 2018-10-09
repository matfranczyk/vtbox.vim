"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#update(file)

endfunction


function s:convert(file)

endfunction

let s:bin = fnamemodify(expand('<sfile>'), ":p:h")."/plantuml/bin/plantuml.jar"

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
