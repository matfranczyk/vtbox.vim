"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#parser#factory#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    call l:parser.on("--list",
                   \ "\t [optional]  show list of available tasks", {'short' : '-l'}
                   \)

    call l:parser.on("--edit",
                   \ "\t [optional]  show list of available tasks", {'short' : '-l'}
                   \)

    return l:parser
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
