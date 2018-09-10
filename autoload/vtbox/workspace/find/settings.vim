"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl:api
"
function vtbox#workspace#find#settings#get()
    return s:settings.get()
endfunction


function vtbox#workspace#find#settings#save(settings)
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
                    \       vtbox#workspace#manager#api().cache_path()."/find/settings.toml",
                    \       function('vtbox#workspace#toml#content#find')),
                    \   "workspace:find:config"
                    \ ])
                    \)
"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
