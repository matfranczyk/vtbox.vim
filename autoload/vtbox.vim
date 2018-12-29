"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" api :: cache
"
function vtbox#cache_path()
    if empty(s:_cache_path_)
        if vtbox#workspace#cache#local().is_available()
            let s:_cache_path_ = vtbox#workspace#cache#local().path()
        else
            let s:dirname      = get(g:, 'vimrc_cache_dirname',  ".vim.cache")
            let s:_cache_path_ = get(g:, 'vimrc_cache_global_path', expand("$HOME")."/".s:dirname."/global")
        endif
    endif

    return s:_cache_path_
endfunction

let s:_cache_path_ = {}

"
" api :: logging
"
function vtbox#echo(source, msg)
    call s:logger.echo('MoreMsg', s:msg(a:source, a:msg))
endfunction


function vtbox#echomsg(source, msg)
    call s:logger.echomsg('MoreMsg', s:msg(a:source, a:msg))
endfunction

function vtbox#warn(source, msg)
    call s:logger.warn(s:msg(a:source, a:msg))
endfunction


function vtbox#error(source, msg)
    call s:logger.error(s:msg(a:source, a:msg))
endfunction

"
" impl
"
function s:msg(source, msg)
    return '[vtbox::'.a:source.'] '.a:msg
endfunction

let s:logger = vtbox#vital#lib('Vim.Message')

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
