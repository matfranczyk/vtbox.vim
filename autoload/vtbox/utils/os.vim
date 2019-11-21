"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

"
" api
"
function vtbox#utils#os#is_wsl()
    return s:is_working_under_wsl()
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
