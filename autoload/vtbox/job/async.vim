"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#job#async#create(command, properties)
    return s:job_factory(a:command, a:properties)
endfunction

"
" impl
"
function s:job_factory(command, properties)
    return {
        \ "_job"     : vtbox#utils#optional#create("job id"),
        \ '_command' : {},
        \ "_context" : vtbox#job#async#context#create(a:command, a:properties),
        \
        \ "launch"     : function('s:launch'),
        \ "is_running" : function("s:is_running"),
        \ "command"    : function('s:command'),
        \ }
endfunction


"
" obj:api
"
function s:launch() dict
        call self._job.value(
                \ vtbox#vital#lib("System.Job").start(
                \       self._context.command(),
                \       self._context))
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
    if empty(a:000) | return self._command | endif
    let self._command = a:1
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
