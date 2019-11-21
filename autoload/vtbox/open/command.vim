"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

"
" api
"
function vtbox#open#command#execute(args)
    let l:path = s:PathResolver(a:args)
    execute "edit ".l:path
endfunction

"
" impl
"
function s:createPathResolver()
    if vtbox#utils#os#is_wsl()
        function s:pathResolver_WSL(path)
            if vtbox#utils#filesystem#is_windows_path(a:path)
                return vtbox#utils#filesystem#win_path_to_wsl(a:path)
            elseif vtbox#utils#filesystem#is_linux_path(a:path)
                return a:path
            endif

            call vtbox#throw(s:label."WSL::path:resolver", "unkown path")
        endfunction

        return function("s:pathResolver_WSL")
    endif

    if vtbox#utils#os#is_linux()
        function s:pathResolver_linux(path)
            if vtbox#utils#filesystem#is_linux_path(a:path)
                return a:path
            endif

            call vtbox#throw(s:label."linux:path:resolver", "unkown path")
        endfunction

        return function("s:pathResolver_linux")
    endif

    call vtbox#throw(s:label., "createPathResolver <-> missing implementation")
endfunction


let s:PathResolver = s:createPathResolver()
let s:label = 'open::command'

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
