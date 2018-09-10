"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#find#parser#factory#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    let l:parser.unknown_options_completion = 'file'

    call l:parser.on("--names=VALUE",
                   \ "\t {required if no --inames} works like gnu find '-name'"
                   \)
    call l:parser.on("--inames=VALUE",
                   \ "\t {required if no --names}  works like gnu find '-iname'"
                   \)
    call l:parser.on("--exclude_file_names=VALUE",
                   \ "\t [optional] exclude file name (glob pattern)"
                   \)
    call l:parser.on("--exclude_file_inames=VALUE",
                   \ "\t [optional] exclude file name (exclude file iname (glob pattern)"
                   \)
    call l:parser.on("--exclude_dir_names=VALUE",
                   \ "\t [optional] exclude dir name (glob pattern)"
                   \)
    call l:parser.on("--exclude_dir_inames=VALUE",
                   \ "\t [optional] exclude dir iname (glob pattern)"
                   \)

    return l:parser
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
