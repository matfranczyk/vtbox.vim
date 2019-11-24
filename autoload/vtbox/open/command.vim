"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function vtbox#open#command#execute(args, opening_mode)
    try
        let l:parsed = vtbox#open#utils#parse(a:args)

        execute a:opening_mode." ".s:filepath(l:parsed.filepath)

        if(l:parsed.lineNumber.has_value())
            execute l:parsed.lineNumber.value()
        endif
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
