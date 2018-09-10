"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#workspace#toml#content#attributes#find()
    let l:data = vtbox#find#attributes#new()

    let l:data.paths = ['./']
    unlet l:data.names
    unlet l:data.inames

    let l:data.exclude_dir_inames = s:excludes_idir()
    let l:data.exclude_file_names = s:excludes_files()

    return l:data
endfunction


function vtbox#workspace#toml#content#attributes#tags()
    let l:data = vtbox#find#attributes#new()

    let l:data.paths = ['./']
    let l:data.inames = ['*']
    unlet l:data.names

    let l:data.exclude_dir_inames = s:excludes_idir()
    let l:data.exclude_file_names = s:excludes_files()

    return l:data
endfunction


function vtbox#workspace#toml#content#attributes#grep()
    let l:data = vtbox#grep#attributes#new()

    let l:data.paths = ['./']
    unlet l:data.fixed
    unlet l:data.regex
    unlet l:data.insensitive

    let l:data.exclude_dir = s:excludes_idir()
    let l:data.exclude     = s:excludes_files()

    return l:data
endfunction


function vtbox#workspace#toml#content#attributes#key()
    return "files"
endfunction


"
" impl
"
function s:excludes_idir()
    return ['build']
endfunction

function s:excludes_files()
    return ['*.o', '*.obj', '*.pyc', '*.a', '*.so', '*.exe']
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
