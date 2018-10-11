"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#job#async#create(command, ...)
    return {
        \ "_job" : vtbox#utils#optional#create("job::id"),
        \
        \ '_command'    : a:command,
        \ '_properties' : empty(a:000) ? {} : a:1,
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
        call self._job.value(
                \ vtbox#vital#lib("System.Job").start(
                \       split(self.command()),
                \       vtbox#job#async#context#create(self._command, self._properties))
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
    if empty(a:000) | return self._command | endif
    let self._command = a:1
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
