"-----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"-----------------------------------
if exists('g:__vtbox_initialized_flag')
    finish
endif
let g:__vtbox_initialized_flag = 1

"
" constant::api
"
let g:vtbox_buffer_width = 120
"
" constant::impl
"
let g:__vtbox_buffer_shortner_sign = '.....'


"
" define commands
"
command! -nargs=* -complete=customlist,vtbox#find#parser#completion
        \ FindFile :call vtbox#find#parser#execute(<q-args>)

command!  -nargs=* -complete=customlist,vtbox#grep#parser#complete
         \ Grep :call vtbox#grep#parser#execute(<q-args>)


"
" bootstrap: workspace
"
if vtbox#workspace#cache#local().is_available()
    call vtbox#workspace#manager().configure()
else
    command! -nargs=0 WorkspaceCreate :call __Vtbox_create_workspace()

    function __Vtbox_create_workspace()
        try
            call vtbox#workspace#cache#local().create()
        catch
            call vtbox#exception#rethrow('cannot create local workspace')
        endtry

        call vtbox#workspace#manager().configure()
        delcommand WorkspaceCreate
    endfunction
endif



"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
