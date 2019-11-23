"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function vtbox#open#command#execute(args, mode)
    try
        execute a:mode." ".s:filepath(a:args)
    catch
        return vtbox#show_exception('open::command')
    endtry
endfunction

"
" impl
"
function s:filepath(filepath)
    if empty(s:__resolver__)
        let s:__resolver__ = vtbox#open#utils#createResolver()
    endif

    return s:__resolver__(a:filepath)
endfunction
let s:__resolver__ = {}


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
