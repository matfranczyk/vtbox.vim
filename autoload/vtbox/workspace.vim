"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#workspace#bootstrap()
    if vtbox#workspace#manager#cache#local().is_available()
        return vtbox#workspace#manager#api().configure()
    endif

    command! -nargs=0 WorkspaceCreate :call vtbox#workspace#create()
endfunction


function vtbox#workspace#create()
    try
        call vtbox#workspace#manager#cache#local().create()
    catch
        call vtbox#exception#rethrow('cannot create local workspace')
    endtry

    call vtbox#workspace#manager#api().configure()
    delcommand WorkspaceCreate
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
