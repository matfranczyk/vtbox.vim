"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" usr:api
"
function vtbox#cache_path()
    if empty(s:_cache_path_)
        if vtbox#workspace#cache#local().is_available()
            let s:_cache_path_ = vtbox#workspace#cache#local().path()
        else
            let s:dirname      = get(g:, 'vimrc_cache_dirname',  ".vim.cache")
            let s:_cache_path_ = get(g:, 'vimrc_cache_global_path', expand("$HOME")."/".s:dirname."/global")
        endif
    endif

    return s:_cache_path_
endfunction

let s:_cache_path_ = {}

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
