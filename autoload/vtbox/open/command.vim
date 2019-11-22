"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api
"
function vtbox#open#command#execute(args, mode)
    try
        execute a:mode." ".s:PathResolver(a:args)
    catch
        return vtbox#show_exception(s:label)
    endtry
endfunction

"
" impl
"
function s:createPathResolver()

    if vtbox#utils#os#is_wsl()
        function s:resolver(file)
            if filereadable(a:file)
                return a:file
            endif

            if vtbox#utils#filesystem#is_windows_path(a:file)
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
        function s:linux_path_resolver(file)
            if filereadable(a:file)
                return a:file
            endif

            call vtbox#throw("linux", "invalid filepath: ".a:file)
        endfunction

        return function("s:resolver")
    endif

    call vtbox#throw(s:label, "resolver <-> missing implementation")
endfunction


let s:label = 'open::command'
let s:PathResolver = s:createPathResolver()

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
