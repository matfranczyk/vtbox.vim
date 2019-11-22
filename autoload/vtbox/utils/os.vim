"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function vtbox#utils#os#is_linux()
    return substitute(system('uname'),'\n','','') == 'Linux'
endfunction


function vtbox#utils#os#is_wsl()
    return vtbox#utils#os#is_linux() &&
        \  readfile("/proc/version")[0] =~ "Microsoft"
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
