"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#workspace#settings#create(
            \ object_factory,
            \ toml_handler,
            \ configuration_buffer_name)

    return {
        \ "_object_factory" : a:object_factory,
        \ "_toml_handler"   : a:toml_handler,
        \ "_unite_find"     : vtbox#utils#unite#find#factory(a:configuration_buffer_name),
        \
        \ "_object_cache"       : {},
        \ "_is_object_outdated" : function('s:_is_object_outdated'),
        \ "_create_object"      : function('s:_create_object'),
        \
        \ "object"        : function('s:object'),
        \ "configuration" : function('s:configuration'),
        \ }
endfunction


"
" obj::api
"
function s:object() dict
    if self._is_object_outdated()
        try
            let self._object_cache = self._create_object()
        catch
            let self._object_cache = {}
            call vtbox#exception#rethrow("cannot create settings:object")
        endtry
    endif

    return deepcopy(self._object_cache)
endfunction


function s:configuration() dict
    call self._unite_find.create_buffer([self._toml_handler.file()])
endfunction


"
" obj::impl
"
function s:_is_object_outdated() dict
    return empty(self._object_cache) || self._toml_handler.has_changed()
endfunction


function s:_create_object() dict
    try
        let l:attributes = self._toml_handler.parse()[vtbox#workspace#toml#content#attributes#key()]
    catch
        throw "toml:file syntax error: ".vtbox#utils#filesystem#relative_path(self._toml_handler.file())
    endtry

    return self._object_factory(l:attributes)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
