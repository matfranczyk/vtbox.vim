"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#open#parser#create()
    let l:parser = vtbox#vital#lib("OptionParser").new()

    call l:parser.on("--split",
                  \ "\t {optional} open in split",
                  \ { 'short' : '-s' })

    call l:parser.on("--vsplit",
                  \ "\t {optional} open in vertical split",
                  \ { 'short' : '-v' })

    call l:parser.on("--tab",
                  \ "\t {optional} open in new tab",
                  \ { 'short' : '-t' })

    return l:parser
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
