"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#grep#parser#factory#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    let l:parser.unknown_options_completion = 'file'

    call l:parser.on("--fixed=VALUE",
                   \ "\t {required if no --regex} fixed pattern for grep, works like -F gnu grep (short -F)",
                   \ {'short' : '-F'}
                   \)
    call l:parser.on("--regex=VALUE",
                   \ "\t {required if no --fixed} regex pattern for grep, works like -E gnu grep (short -E)",
                   \ {'short' : '-E'}
                   \)
    call l:parser.on("--insensitive",
                   \ "\t [optional] turns case insensitivity, short flag (short -i)",
                   \ {'short' : '-i'}
                   \)

    call l:parser.on("--include=VALUE",
                   \ "\t [optional] includes only files that meet glob pattern VALUE",
                   \)
    call l:parser.on("--exclude=VALUE",
                   \ "\t [optional] excludes files that meet glob pattern VALUE",
                   \)
    call l:parser.on("--exclude_dir=VALUE",
                   \ "\t [optional] excludes files from directory that meet glob pattern VALUE",
                   \)

    return l:parser
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
