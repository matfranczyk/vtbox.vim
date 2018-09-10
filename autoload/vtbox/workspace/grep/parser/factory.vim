"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#workspace#grep#parser#factory#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    call l:parser.on("--fixed=VALUE",
                   \ "\t {required if no --regex} fixed pattern for grep, works like -F gnu grep (short -F)",
                   \ {'short' : '-F'}
                   \)
    call l:parser.on("--regex=VALUE",
                   \ "\t {required if no --fixed} regex pattern for grep, works like -E gnu grep (short -E)",
                   \ {'short' : '-E'}
                   \)
    call l:parser.on("--configuration",
                   \ "\t [optional]  check&configure paths in toml file"
                   \)

    call l:parser.on("--insensitive",
                   \ "\t [optional] turns case insensitivity, short flag (short -i)",
                   \ {'short' : '-i'}
                   \)

    return l:parser
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
