"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#themis#parser#factory#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    call l:parser.on("--current_buffer",
                   \ "\t [optional] running test from current buffer"
                   \)
    call l:parser.on("--recursively=VALUE",
                   \ "\t [optional] run test from files '*test*vim' recursively from path 'VALUE'",
                   \ {'completion' : 'file'}
                   \)
    call l:parser.on("--regression",
                   \ "\t [optional] run all files: 'find ./ -type f -iname *test*vim'"
                   \)
    return l:parser
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
