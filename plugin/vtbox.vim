"-----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"-----------------------------------
if exists('s:script_guard')
    finish
endif
let s:script_guard = 1


"
" constants
"
let g:vtbox_buffer_width = 120
let g:__vtbox_buffer_shortner_sign = '.....'


"
" define commands
"
cabbrev ff FindFile
command! -nargs=* -complete=customlist,vtbox#find#parser#completion
        \ FindFile :call vtbox#find#parser#execute(<q-args>)

cabbrev gg Grep
command!  -nargs=* -complete=customlist,vtbox#grep#parser#complete
         \ Grep :call vtbox#grep#parser#execute(<q-args>)

command!  -nargs=* -complete=customlist,vtbox#file#command#complete
         \ File :call vtbox#file#command#execute(<q-args>)

"
" bootstrap: workspace
"
if vtbox#workspace#cache#local().is_available()
    call vtbox#workspace#manager().configure()
endif

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
