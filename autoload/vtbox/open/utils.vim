"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function vtbox#open#utils#createResolver()
    return s:create_path_resolver()
endfunction

function vtbox#open#utils#parse(file)
    let l:obj = {
        \ 'filepath'   : s:filepath(a:file),
        \ 'lineNumber' : vtbox#utils#optional#create('lineNumber')
        \ }

    if s:hasLineNumber(a:file)
        call l:obj.lineNumber.value( s:lineNumber(a:file) )
    endif

    return l:obj
endfunction

"
"
" impl :: parser
"
function s:parse(file)
    let l:obj = {
        \ 'filepath'   : s:filepath(a:file),
        \ 'lineNumber' : vtbox#utils#optional#create('lineNumber')
        \ }

    if s:hasLineNumber(a:file)
        call l:obj.lineNumber.value( s:lineNumber(a:file) )
    endif

    return l:obj
endfunction


let s:regex_lineNumber = ':\d\+\s*$'
let s:regex_fileWithLineNumber = '\p\+'.s:regex_lineNumber

function s:hasLineNumber(filepath)
    return ! empty( matchstr(a:filepath, s:regex_fileWithLineNumber) )
endfunction

function s:filepath(filepath)
    return vtbox#utils#string#trim(
                \ substitute(a:filepath, s:regex_lineNumber, "", "g") )
endfunction

function s:lineNumber(filepath)
    return vtbox#utils#string#trim(
                \  matchstr(a:filepath, s:regex_lineNumber) )
endfunction


"
" impl :: create path resolver
"
function s:create_path_resolver()
    if vtbox#utils#os#is_wsl()
        function s:resolver(file)
            if filereadable(a:file)
                return a:file
            endif

            if vtbox#utils#filesystem#is_windows_abspath(a:file)
                let l:file = vtbox#utils#filesystem#win_path_to_wsl(a:file)
                if filereadable(l:file)
                    return l:file
                endif
            endif

            call vtbox#throw("wsl", "invalid filepath: ".a:file)
        endfunction

        return function("s:resolver")
    endif

    if vtbox#utils#os#is_linux()
        function s:resolver(file)
            if filereadable(a:file)
                return a:file
            endif

            call vtbox#throw("linux", "invalid filepath: ".a:file)
        endfunction

        return function("s:resolver")
    endif

    call vtbox#throw(s:label, "resolver <-> missing implementation")
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
