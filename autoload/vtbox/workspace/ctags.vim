"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" API::user
"
let s:object = vtbox#workspace#ctags#settings#get().object()

" echomsg string(s:object.commands()) | return

let s:cmd = join(s:object.commands())
" echomsg join(s:object.commands())

let s:cmd = 'find /home/mateusz/.vim.dein/plugins/repos/github.com/matfranczyk/vtbox.vim/ -not ( -type d -name .svn -prune ) -not ( -type d -name .git -prune ) -not ( -type d -name .vim.cache -prune ) -type f -iname *'

let s:job = vtbox#job#async#create(s:cmd,
            \ {"stdout_file" : getcwd()."/files.ctags", "stderr_file" : getcwd()."/err.files.ctags"})
call s:job.launch()


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
