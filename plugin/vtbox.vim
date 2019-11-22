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
command! -nargs=* -complete=customlist,vtbox#find#parser#completion
        \ FindFile :call vtbox#find#parser#execute(<q-args>)
cabbrev ff FindFile

command!  -nargs=* -complete=customlist,vtbox#grep#parser#complete
         \ Grep :call vtbox#grep#parser#execute(<q-args>)
cabbrev gg Grep

command!  -nargs=* -complete=customlist,vtbox#file#command#complete
         \ File :call vtbox#file#command#execute(<q-args>)



cnoreabbrev     o Open
cnoreabbrev     e Open
command! -nargs=1 Open         :call vtbox#open#command#execute(<q-args>, 'edit')

cnoreabbrev     s  OpenInSplit
command! -nargs=1  OpenInSplit  :call vtbox#open#command#execute(<q-args>, 'split')

cnoreabbrev    v  OpenInVSplit
cnoreabbrev    vs OpenInVSplit
command! -nargs=1 OpenInVSplit :call vtbox#open#command#execute(<q-args>, 'vsplit')

cnoreabbrev     t OpenInTab
command! -nargs=1 OpenInTab    :call vtbox#open#command#execute(<q-args>, 'tabnew')


"
" bootstrap: workspace
"
if vtbox#workspace#cache#local().is_available()
    call vtbox#workspace#manager().configure()
endif

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
