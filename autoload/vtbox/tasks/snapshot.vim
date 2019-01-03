"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#snapshot#save(
            \ task_title,
            \ exit_status,
            \ stdout,
            \ stderr,
            \ time_start,
            \ time_stop
            \ )

    return s:snapshot().save(
                \ a:task_title,
                \ a:exit_status,
                \ a:stdout,
                \ a:stderr,
                \ a:time_start,
                \ a:time_stop
                \ )
endfunction


function vtbox#tasks#snapshot#unite()
    return s:unite().create_buffer()
endfunction

"
" impl :: unite buffer
"
function s:unite()
"{{{
    if empty(s:_unite__)
        let s:__unite__ = s:create_unite()
    endif
    return s:__unite__
endfunction
let s:_unite__ = {}
"}}}

function vtbox#tasks#snapshot#show_stdout()
    call vtbox#utils#unite#list#show_buffer(
                \ 'stdout',
                \ s:snapshot()._stdout)

    call vtbox#echo(s:snapshot().info())
endfunction

function vtbox#tasks#snapshot#show_stderr()
    call vtbox#utils#unite#list#show_buffer(
                \ 'stderr',
                \ s:snapshot()._stderr)

    call vtbox#echo(s:snapshot().info())
endfunction


function s:create_unite()
    let l:unite =  {
        \ 'source' : {
        \   'name' : vtbox#stamp(vtbox#tasks#stamp(), 'executed'),
        \   'default_kind' : 'command',
        \
        \   'gather_candidates' : function('s:gather_candidates'),
        \ },
        \ 'create_buffer' : function('s:create_buffer')
        \ }

    call unite#define_source(l:unite.source)

    return l:unite
endfunction

function s:create_buffer() dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(self.source.name))

    call vtbox#echo(s:snapshot().info())
endfunction


function s:gather_candidates(args, context)
    return
    \ [
        \ {
        \ "word"            : 'stdout',
        \ "action__command" : 'call vtbox#tasks#snapshot#show_stdout()',
        \ },
        \ {
        \ "word"            : 'stderr',
        \ "action__command" : 'call vtbox#tasks#snapshot#show_stderr()',
        \ },
    \ ]
endfunction


function s:create_context(buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = vtbox#utils#unite#wipe_buffer()

    return l:context
endfunction

"
" impl :: task snapshot
"
function s:snapshot()
"{{{
    if empty(s:__snapshot__)
        let s:__snapshot__ = s:create()
    endif
    retur s:__snapshot__
endfunction
let s:__snapshot__ = {}
"}}}

function s:create()
    return {
        \ '_title'      : {},
        \ '_exit_status': {},
        \ '_stdout'     : {},
        \ '_stderr'     : {},
        \ '_time_start' : {},
        \ '_time_stop'  : {},
        \
        \  'save' : function('s:save'),
        \  'info' : function('s:info'),
        \ }
endfunction

"
" obj::api
"
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


function s:info() dict
    return join(
                \ [
                \ "[Tasks] tittle :".self._title,
                \ "status : ".self._exit_status,
                \ printf("{started: %s, stopped: %s}", self._time_start, self._time_stop)
                \ ], " | ")
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
