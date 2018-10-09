"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#parser#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    call l:parser.on("--save=VALUE",
                   \ "\t [default] txt format",
                   \ {
                   \    'default'    : 'utxt',
                   \    'completion' : function('s:formats')
                   \ })

    call l:parser.on("--show",
                   \ "\t [optional] will show txt format of current UML",
                   \)

    return l:parser
endfunction


function s:formats(...)
    return ['utxt', 'tsvg', 'tpng', 'tpdf']
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
