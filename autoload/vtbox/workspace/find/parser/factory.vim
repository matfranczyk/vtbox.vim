"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#workspace#find#parser#factory#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    call l:parser.on("--names=VALUE",
                   \ "\t {required if no --inams} works like gnu find '-name'"
                   \)
    call l:parser.on("--inames=VALUE",
                   \ "\t {required if no --nams}  works like gnu find '-iname'"
                   \)
    call l:parser.on("--configuration",
                   \ "\t [optional]  check&configure paths in toml file"
                   \)

    return l:parser
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
