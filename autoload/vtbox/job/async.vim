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
        \ "_context" : vtbox#job#async#context#create(a:command, a:properties),
        \
        \ "launch"     : function('s:launch'),
        \ "is_running" : function("s:is_running"),
        \
        \ "command"     : function('s:command'),
        \
        \ "copy_stdout" : function('s:copy_stdout'),
        \ "copy_stderr" : function('s:copy_stderr'),
        \ }
endfunction


"
" obj:api
"
function s:launch() dict
    if self._job.has_value()
        call self._job.reset()
    endif

    try
        call self._context.reset()
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
    if empty(a:000) | return join(self._context.command()) | endif

    call self._context.command(a:1)
endfunction


function s:copy_stdout() dict
    return copy(self._context._stdout)
endfunction

function s:copy_stderr() dict
    return copy(self._context._stderr)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
