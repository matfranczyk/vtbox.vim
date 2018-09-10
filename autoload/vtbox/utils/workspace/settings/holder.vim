"---------------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#workspace#settings#holder#create(settings_factory)
    return {
        \ "_settings_factory" : a:settings_factory,
        \ "_settings" : {},
        \
        \ "save" : function('s:save'),
        \ "get"  : function('s:get')
        \ }
endfunction

"
" obj:api
"
function s:save(settings) dict
    let self._settings = a:settings
endfunction


function s:get() dict
    if empty(self._settings)
        let self._settings = self._settings_factory()
    endif

    return self._settings
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
