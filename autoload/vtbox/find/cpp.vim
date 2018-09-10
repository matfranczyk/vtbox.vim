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
        return vtbox#exception#log('flipping source/include')
    endtry

    let l:object =  vtbox#find#object#new({'paths' : expand("%:p:h:h")})
    call l:object.names(l:filename)

    call vtbox#find#execute(
                \ l:object,
                \ empty(a:000) ? 'edit' : 'unite')

endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
