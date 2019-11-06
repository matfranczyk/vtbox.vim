"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#file#parser#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    call l:parser.on("--filename",
                  \ "\t {optional} echo filename of current buffer",
                  \ )

    call l:parser.on("--parent_path",
                  \ "\t {optional} echo parent path of current buffer",
                  \ )

    call l:parser.on("--filepath",
                  \ "\t {optional} echo filepath in linux format",
                  \ )

    call l:parser.on("--winpath",
                  \ "\t {optional} echo filepath in windows format",
                  \ )

    return l:parser
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
