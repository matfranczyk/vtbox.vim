"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl:api
"
function vtbox#workspace#ctags#settings#get()
    return s:settings.get()
endfunction


function vtbox#workspace#ctags#settings#save(settings)
    return s:settings.save(a:settings)
endfunction

"
" impl
"
let s:settings = vtbox#utils#workspace#settings#holder#create(
                    \ function('vtbox#utils#workspace#settings#create',
                    \ [
                    \   function('vtbox#find#object#new'),
                    \   vtbox#toml#handler#create(
                    \       vtbox#workspace#manager().cache_path()."/ctags/settings.toml",
                    \       function('vtbox#workspace#toml#content#tags')),
                    \   "workspace:ctags:config"
                    \ ])
                    \)
"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
