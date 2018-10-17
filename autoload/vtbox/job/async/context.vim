"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#job#async#context#create(command, properties)
    return extend(s:create_attributes(a:command, a:properties),
                \ s:create_framework()
                \ )
endfunction

"
" impl
"
function s:create_attributes(command, properties)
    return {
        \ 'command' : a:command,
        \
        \ 'on_done_function' : has_key(a:properties, 'on_done_function') ? a:properties.on_done_function : {},
        \ 'on_done_job'      : has_key(a:properties, 'on_done_job')      ? a:properties.on_done_job : {},
        \ }
endfunction

function s:create_framework()
    return {
        \ 'stdout': [''], 'stderr': [''],
        \ 'exit_status' : vtbox#utils#optional#create('job:exit_status'),
        \ "time_start"  : vtbox#utils#optional#create('job:time_start', vtbox#utils#vim#watch_time()),
        \ "time_stop"   : vtbox#utils#optional#create('job:time_stop'),
        \
        \ "on_stdout"  : function('s:on_stdout'),
        \ "on_stderr"  : function('s:on_stderr'),
        \ "on_exit"    : function('s:on_exit'),
        \
        \ 'default_finalizer' : function('s:default_finalizer'),
        \ 'summary' : function('s:summary')
        \ }
endfunction


function s:default_finalizer() dict
    if self.exit_status.value() == 0
        return vtbox#log#message("job done: ".self.command)
    endif

    call vtbox#utils#vim#make_qflist(self.stderr)
    call vtbox#utils#unite#copen()

    call vtbox#log#error("job failed: ".self.command)
endfunction


function s:summary() dict
    return {
        \ 'exit_status' : self.exit_status.value(),
        \
        \ 'time_start' : self.time_start.value(),
        \ 'time_stop'  : self.time_stop.value(),
        \ }
endfunction

"
" impl::event handlers
"
function s:on_exit(exit_status) abort dict
    call self.exit_status.value(a:exit_status)
    call self.time_stop.value(vtbox#utils#vim#watch_time())

    if has_key(self, "on_done_job") && !empty(self.on_done_job)
        return self.on_done_job.launch(
                    \self.summary(), self.stdout, self.stderr)
    endif

    if has_key(self, "on_done_function") && !empty(self.on_done_function)
        return self.on_done_function(
                    \ self.summary(), self.stdout, self.stderr)
    endif

    call self.default_finalizer()
endfunction


function s:_append_output(buffer, output_data)
    call map(a:output_data, 'v:val[-1:] ==# "\r" ? v:val[:-2] : v:val')

    let a:buffer[-1] .= a:output_data[0]
    call extend(a:buffer, a:output_data[1:])
endfunction

function s:on_stdout(input) abort dict
    call s:_append_output(self.stdout, a:input)
endfunction

function s:on_stderr(input) abort dict
    call s:_append_output(self.stderr, a:input)
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
