"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#job#async#create(...)
    if empty(a:000)
        return extend(s:factory(), {'_command' : vtbox#utils#optional#create('job:command')} )
    endif

    return extend(s:factory(), {'_command' : vtbox#utils#optional#create('job:command', a:1)} )
endfunction

"
" impl
"
let s:label = 'job::async'

function s:factory()
    return {
        \ "_job"        : vtbox#utils#optional#create("job::id"),
        \ '_properties' : {},
        \
        \ "launch"     : function('s:launch'),
        \ "is_running" : function("s:is_running"),
        \ "command"    : function('s:command'),
        \ }
endfunction

"
" obj:api
"
"   {empty} -> default vtbox#job#async#context :: s:default_finalizer()
"
"   job.launch({on_done_function : function('on_done_function')})
"       ----> arguments forwarded to 'on_done_function'
"           (1) exit_status,
"           (3) stdout,
"           (4) stderr,
"           (5) time_start,
"           (6) time_stop
"
function s:launch(...) dict
    try
        let l:command = self.command()
        let l:properties = empty(a:000) ? {} : a:1

        call self._job.value(
                \ vtbox#vital#lib("System.Job").start(
                \       ['/bin/bash', '-c', l:command],
                \       vtbox#job#async#context#create(l:command, l:properties))
                \)
    catch
        call self._job.reset()
        call vtbox#show_exception(s:label, 'problem with start job')
    endtry
endfunction

function s:is_running() dict
    return  self._job.has_value()
       \ && self._job.value().status() == 'run'
endfunction


function s:command(...) dict
    if empty(a:000) | return self._command.value() | endif

    return self._command.value(a:1)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
