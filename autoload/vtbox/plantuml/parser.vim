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
                   \    'default'    : 'txt',
                   \    'completion' : function('s:formats')
                   \ })

    call l:parser.on("--check_syntax",
                   \ "\t {optional} check syntax")

    return l:parser
endfunction


function s:formats(...)
    return ['txt', 'svg', 'png']
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
