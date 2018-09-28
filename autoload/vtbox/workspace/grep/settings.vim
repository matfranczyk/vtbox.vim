"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl:api
"
function vtbox#workspace#grep#settings#get()
    return s:settings.get()
endfunction


function vtbox#workspace#grep#settings#save(settings)
    return s:settings.save(a:settings)
endfunction

"
" impl
"
let s:settings = vtbox#utils#workspace#settings#holder#create(
                    \ function('vtbox#utils#workspace#settings#create',
                    \ [
                    \   function('vtbox#grep#object#new'),
                    \   vtbox#toml#handler#create(
                    \       vtbox#workspace#manager().cache_path()."/grep/settings.toml",
                    \       function('vtbox#workspace#toml#content#grep')),
                    \   "workspace:grep:config"
                    \ ])
                    \)

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
