"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#executed#snapshot#api()
"{{{
    if empty(s:__snapshot__)
        let s:__snapshot__ = s:create()
    endif
    retur s:__snapshot__
endfunction
let s:__snapshot__ = {}
"}}}

"
" impl
"
function s:create()
    return {
        \ '_title'      : {},
        \ '_exit_status': {},
        \ '_stdout'     : {},
        \ '_stderr'     : {},
        \ '_time_start' : {},
        \ '_time_stop'  : {},
        \
        \ 'stdout' : function('s:stdout'),
        \ 'stderr' : function('s:stderr'),
        \
        \ 'has_data'   : function('s:has_data'),
        \ 'has_stderr' : function('s:has_stderr'),
        \
        \ 'save'    : function('s:save'),
        \ 'message' : function('s:message'),
        \ }
endfunction

"
" obj::public
"
function s:stdout() dict
    return self._stdout
endfunction

function s:stderr() dict
    return self._stderr
endfunction


function s:has_data() dict
    return !empty(self._title)
endfunction

function s:has_stderr() dict
    return self._exit_status != 0
endfunction


function s:save(
            \ task_title,
            \ exit_status,
            \ stdout,
            \ stderr,
            \ time_start,
            \ time_stop
            \ ) dict

    let self._title       = a:task_title
    let self._exit_status = a:exit_status
    let self._stdout      = copy(a:stdout)
    let self._stderr      = copy(a:stderr)
    let self._time_start  = a:time_start
    let self._time_stop   = a:time_stop
endfunction


function s:message() dict
    if self._exit_status == 0
        return vtbox#message(s:stamp,
                \ join([
                \      self._title,
                \      s:separator,
                \      s:timing(self._time_start, self._time_stop)
                \      ]))
    endif

    return vtbox#warning(s:stamp,
            \ join([
            \      self._title,
            \      s:separator,
            \      'error_code: '.self._exit_status,
            \      s:timing(self._time_start, self._time_stop)
            \      ]))
endfunction

let s:separator = '       '
let s:stamp = vtbox#tasks#stamp().'::executed::info'

function s:timing(time_start, time_stop)
    return printf("{started: %s, stopped: %s}", a:time_start, a:time_stop)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
