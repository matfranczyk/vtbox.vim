"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" usr:api
"
function vtbox#workspace#manager#api()
    if empty(s:_instance_)
        let s:_instance_ = s:factory()
    endif
    return s:_instance_
endfunction
let s:_instance_ = {}


function s:factory()
    if ! vtbox#workspace#manager#cache#local().is_available()
        call vtbox#exception#throw("cannot create workspace#manager if cache local is not available")
    endif

    return {
        \ '_cache'     : vtbox#workspace#manager#cache#local().path()."/workspace",
        \
        \ 'cache_path' : function('s:cache_path'),
        \ 'configure'  : function('s:configure'),
        \ }
endfunction

"
" obj:api
"
function s:cache_path() dict
    return self._cache
endfunction


function s:configure() dict
    call s:default_commands()

    if exists('*Vtbox_onWorkspaceConfiguration')
        call Vtbox_onWorkspaceConfiguration()
    endif
endfunction


function s:default_commands()
    command! -nargs=* -complete=customlist,vtbox#workspace#find#parser#completion
            \ FindWorkspace :call vtbox#workspace#find#parser#execute(<q-args>)

    command!  -nargs=* -complete=customlist,vtbox#workspace#grep#parser#completion
            \ GrepWorkspace :call vtbox#workspace#grep#parser#execute(<q-args>)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
