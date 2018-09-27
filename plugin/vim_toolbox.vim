"----------------------------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------------------------

if !exists('g:vtbox_initialized_flag')
    let g:vtbox_initialized_flag = {}
endif

command! -nargs=* -complete=customlist,vtbox#find#parser#completion
        \ FindFile :call vtbox#find#parser#execute(<q-args>)

command!  -nargs=* -complete=customlist,vtbox#grep#parser#complete
         \ Grep :call vtbox#grep#parser#execute(<q-args>)


"
" unite buffer constants
"
let g:vtbox_buffer_width = 180
let g:__vtbox_buffer_shortner_sign = '.....'
let g:__vtbox_buffer_maxline_width = g:vtbox_buffer_width + len(g:__vtbox_buffer_shortner_sign)


call vtbox#workspace#bootstrap()

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
