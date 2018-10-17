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
function s:launch(...) dict
    try
        let l:command = self.command()
        let l:properties = empty(a:000) ? {}, : a:1

        call self._job.value(
                \ vtbox#vital#lib("System.Job").start(
                \       ['/bin/bash', '-c', l:command],
                \       vtbox#job#async#context#create(l:command, l:properties))
                \)
    catch
        call self._job.reset()
        call vtbox#exception#log('async:job failed')
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
