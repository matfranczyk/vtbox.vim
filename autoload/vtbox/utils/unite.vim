"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#utils#unite#copen()
    if empty(getqflist())
        return vtbox#log#echo('lack of quickfix list')
    endif

	execute "Unite -buffer-name=quickfix quickfix"
endfunction


function vtbox#utils#unite#lopen()
    if empty(getloclist(0))
        return vtbox#log#echo('lack of location lists')
    endif

	execute "Unite -buffer-name=location_list location_list"
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
