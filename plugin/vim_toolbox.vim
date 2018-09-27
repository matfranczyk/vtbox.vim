"-----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"-----------------------------------

if !exists('g:__vtbox_initialized_flag')
    let g:__vtbox_initialized_flag = {}
endif


command! -nargs=* -complete=customlist,vtbox#find#parser#completion
        \ FindFile :call vtbox#find#parser#execute(<q-args>)

command!  -nargs=* -complete=customlist,vtbox#grep#parser#complete
         \ Grep :call vtbox#grep#parser#execute(<q-args>)


call vtbox#constants()
call vtbox#workspace#bootstrap()

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
