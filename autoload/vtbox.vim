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
" api :: exception
"
function vtbox#throw(label, msg) abort
    throw s:msg(a:label, a:msg)
endfunction

function vtbox#show_exception(label, ...) abort
    let l:msg = 'v:exception: '.v:exception
    if !empty(a:000)
        let l:msg = join([a:1, l:msg], ' | ')
    endif

    call vtbox#error(a:label, l:msg)
endfunction


function vtbox#rethrow(label, msg) abort
    throw s:msg(a:label, a:msg.' | rethrown: '.v:exception)
endfunction


"
" api :: logging
"
function vtbox#echo(...)
    if a:0 == 1
        return s:logger.echo('MoreMsg', '[vtbox] '.a:1)
    endif

    return s:logger.echo('MoreMsg', s:msg(a:1, a:2))
endfunction


function vtbox#message(label, msg)
    call s:logger.echomsg('MoreMsg', s:msg(a:label, a:msg))
endfunction

function vtbox#warning(label, msg)
    call s:logger.warn(s:msg(a:label, a:msg))
endfunction

function vtbox#error(label, msg)
    call s:logger.error(s:msg(a:label, a:msg))
endfunction

"
" impl
"
function s:msg(label, msg)
    return '[vtbox::'.a:label.'] '.a:msg
endfunction

let s:logger = vtbox#vital#lib('Vim.Message')

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
