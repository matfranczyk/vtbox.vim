"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl :: api
"
function vtbox#utils#unite#source(...)
    if empty(a:000)
        return "[vtbox]"
    endif
    return "[vtbox] ".a:1
endfunction


function vtbox#utils#unite#wipe_buffer()
    return 1
endfunction

function vtbox#utils#unite#persistent_buffer()
    return 0
endfunction


function vtbox#utils#unite#copen()
    if empty(getqflist())
        return vtbox#echo('lack of quickfix list')
    endif

	execute "Unite -buffer-name=quickfix quickfix"
endfunction


function vtbox#utils#unite#lopen()
    if empty(getloclist(0))
        return vtbox#echo('lack of location lists')
    endif

	execute "Unite -buffer-name=location_list location_list"
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
