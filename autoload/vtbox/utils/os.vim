"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

"
" api
"
function vtbox#utils#os#is_wsl()
    return vtbox#utils#os#is_linux() &&
        \  readfile("/proc/version")[0] =~ "Microsoft"
    return s:is_working_under_wsl()
endfunction


function vtbox#utils#os#is_linux()
    return substitute(system('uname'),'\n','','') == 'Linux'
endfunction

"
" impl
"
function s:is_working_under_wsl()
    if substitute(system('uname'),'\n','','') == 'Linux'
        return readfile("/proc/version")[0] =~ "Microsoft"
    endif
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
