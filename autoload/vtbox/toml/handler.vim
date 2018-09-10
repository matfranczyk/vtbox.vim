"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

function vtbox#toml#handler#create(file, content_provider)
    return {
        \ "_file"              : a:file,
        \ "_modification_time" : {},
        \ "_content_factory"   : a:content_provider,
        \
        \ "_create_file" : function("s:_create_file"),
        \
        \ "has_changed" : function('s:has_changed'),
        \ "file"        : function('s:file'),
        \ "parse"       : function("s:parse"),
        \ }
endfunction


function s:parse() dict
    if self.has_changed()
        let self._modification_time = getftime(self._file)
    endif

    return vtbox#vital#lib('Text.TOML').parse_file(self.file())
endfunction


function s:has_changed() dict
    return empty(self._modification_time) ||
          \ getftime(self._file) != self._modification_time
endfunction


function s:file() dict
    if !filereadable(self._file)
        call self._create_file()
    endif

    return self._file
endfunction

"
" private
"
function s:_create_file() dict
    call vtbox#utils#filesystem#set_file_content(
            \ self._file,
            \ self._content_factory())
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
