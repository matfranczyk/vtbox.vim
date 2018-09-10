"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#job#async#context#create(command, properties)
    return extend(s:create(a:command),
                \ s:custom(a:properties)
                \ )
endfunction
"
" impl
"
function s:custom(user)
    let l:properties = {}

    if has_key(a:user, "stdout_file")
        call extend(l:properties, {"_stdout_file" : a:user.stdout_file})
    endif

    if has_key(a:user, "stderr_file")
        call extend(l:properties, {"_stderr_file" : a:user.stderr_file})
    endif

    return l:properties
endfunction


function s:create(command)
    return {
        \ '_command' : a:command,
        \ '_stdout': [''], '_stderr': [''],
        \
        \ '_exit_status' : vtbox#utils#optional#create('job:exit_status'),
        \ "_time_start"  : vtbox#utils#optional#create('job:time_start', vtbox#utils#vim#watch_time()),
        \ "_time_stop"   : vtbox#utils#optional#create('job:time_stop'),
        \
        \ "on_stdout"  : function('s:on_stdout'),
        \ "on_stderr"  : function('s:on_stderr'),
        \ "on_exit"    : function('s:on_exit'),
        \
        \ "_on_passed"  : function('s:_on_passed'),
        \ "_on_failed"  : function('s:_on_failed'),
        \
        \ 'command'    : function('s:command'),
        \ 'reset'      : function('s:reset'),
        \ 'has_passed' : function('s:has_passed')
        \ }
endfunction

"
" common
"
function s:on_stdout(data) abort dict
    call s:_append_output(self._stdout, a:data)
endfunction

function s:on_stderr(data) abort dict
    call s:_append_output(self._stderr, a:data)
endfunction

function s:_append_output(buffer, output_data)
    call map(a:output_data, 'v:val[-1:] ==# "\r" ? v:val[:-2] : v:val')

    let a:buffer[-1] .= a:output_data[0]
    call extend(a:buffer, a:output_data[1:])
endfunction

function s:on_exit(exit_value) abort dict
    call self._exit_status.value(a:exit_value)
    call self._time_stop.value(vtbox#utils#vim#watch_time())

    if has_key(self, "_stdout_file")
        silent call vtbox#utils#filesystem#set_file_content(
                    \ self._stdout_file,
                    \ self._stdout)
    endif

    if has_key(self, "_stderr_file")
        silent call vtbox#utils#filesystem#set_file_content(
                    \ self._stderr_file,
                    \ self._stderr)
    endif

    if ! self.has_passed()
        return self._on_failed()
    endif

    call self._on_passed()
endfunction


function s:_on_passed() dict
    call s:stream(self)
endfunction


function s:_on_failed() dict
    call s:stream(self)
endfunction

"
" default
"
function s:default_final() dict
    if self._exit_status.value() != 0
        call s:warning(self._failed_info())
        call vtbox#utils#vim#make_qflist(self._stderr)
        copen | return
    endif

    call s:echo(self._passed_info())
endfunction

"
" obj:api
"
function s:reset() dict
    let self._stdout = ['']
    let self._stderr = ['']

    call self._exit_status.reset()

    call self._time_start.value(vtbox#utils#vim#watch_time())
    call self._time_stop.reset()
endfunction


function s:command(...) dict
    if empty(a:000)
        return split(self._command)
    endif

    let self._command = a:1
endfunction


function s:has_passed() dict
    return self._exit_status.value() == 0
endfunction

"
" script:impl
"
function s:stream(context)
    let l:msg = s:stream_command(a:context)
             \ ." ".s:stream_status(a:context)
             \ ." ".s:stream_time(a:context)

    if a:context.has_passed()
        call vtbox#log#echo('[vtbox:async:job] '.l:msg)
    else
        call vtbox#log#warning('[vtbox:async:job] '.l:msg)
    endif
endfunction

function s:stream_command(context)
    if has_key(a:context, "description")
        return "'".a:context.description."'"
    endif

    return "'".a:context._command."'"
endfunction

function s:stream_status(context)
    return 'status: '.a:context._exit_status.value()
endfunction

function s:stream_time(context)
    return '[start: '.a:context._time_start.value().','
        \ .' stop: '.a:context._time_stop.value().']'
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
