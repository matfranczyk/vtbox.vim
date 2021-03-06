"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function vtbox#open#utils#parse(input)
    let l:obj = {
        \ 'filepath'   : s:filepath(a:input),
        \ 'lineNumber' : vtbox#utils#optional#create('lineNumber')
        \ }

    if s:hasLineNumber(a:input)
        call l:obj.lineNumber.value( s:lineNumber(a:input) )
    endif

    return l:obj
endfunction


function vtbox#open#utils#createResolver()
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

"
"
" impl :: parser
"

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

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
