"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" usr:api
"
function vtbox#workspace#manager()
    if empty(s:_instance_)
        let s:_instance_ = s:factory()
    endif
    return s:_instance_
endfunction
let s:_instance_ = {}


function s:factory()
    if ! vtbox#workspace#cache#local().is_available()
        call vtbox#exception#throw("cannot create workspace#manager if cache local is not available")
    endif

    return {
        \ '_cache'     : vtbox#workspace#cache#local().path()."/workspace",
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


function s:commands()
	command! -nargs=* -complete=customlist,vtbox#tasks#parser#complete
			\ Tasks :call vtbox#tasks#parser#execute(<q-args>)
endfunction

function s:configure() dict
    if exists('*Vtbox_onWorkspaceConfiguration')
        call Vtbox_onWorkspaceConfiguration()
        call s:commands()
    endif
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
