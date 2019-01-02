"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function vtbox#find#cpp#flip_source(...)
    try
        let l:filename = vtbox#utils#cpp#flip(
                            \ vtbox#utils#filesystem#current_filename())
    catch
        return vtbox#show_exception(s:label, 'cannot resolve filename')
    endtry

    let l:object =  vtbox#find#object#new({'paths' : expand("%:p:h:h")})
    call l:object.names(l:filename)

    call vtbox#find#execute(
                \ l:object,
                \ empty(a:000) ? 'edit' : 'unite')

endfunction

"
" impl
"
let s:label = 'find::cpp'

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
