"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#job#async#context#create(properties)
    return extend(s:create_attributes(a:properties),
                \ s:create_handlers(),
                \ {'data' : s:create_data()},
                \ )
endfunction

"
" impl
"
function s:create_attributes(user)
    return {
        \ 'stdout_file' : has_key(a:user, 'stdout_file') ? a:user.stdout_file : {},
        \ 'stderr_file' : has_key(a:user, 'stderr_file') ? a:user.stderr_file : {},
        \
        \ 'on_done_function' : has_key(a:user, 'on_done_function') ? a:user.on_done_function : {},
        \ 'on_done_job'      : has_key(a:user, 'on_done_job')      ? a:user.on_done_job : {},
        \ }
endfunction

function s:create_handlers()
    return {
        \ "on_stdout"  : function('s:on_stdout'),
        \ "on_stderr"  : function('s:on_stderr'),
        \ "on_exit"    : function('s:on_exit'),
        \ }
endfunction

function s:create_data()
    return {
        \ 'stdout': [''], 'stderr': [''],
        \ 'exit_status' : vtbox#utils#optional#create('job:exit_status'),
        \ "time_start"  : vtbox#utils#optional#create('job:time_start', vtbox#utils#vim#watch_time()),
        \ "time_stop"   : vtbox#utils#optional#create('job:time_stop'),
        \ }
endfunction

function s:create_api() dict
    return {
         \ }
endfunction

"
" impl::event handlers
"
function s:on_exit(exit_value) abort dict
    call self.data.exit_value.value(a:exit_value)
    call self.data.time_stop.value(vtbox#utils#vim#watch_time())

    if has_key(self, "stdout_file")
        silent call vtbox#utils#filesystem#set_file_content(
                    \ self.stdout_file,
                    \ self.data.stdout)
    endif

    if has_key(self, "stderr_file")
        silent call vtbox#utils#filesystem#set_file_content(
                    \ self.stderr_file,
                    \ self.data.stderr)
    endif

    if has_key(self, "on_done_job")
        return self.on_done_job.launch(deepcopy(self.data))
    endif

    if has_key(self, "on_done_function")
        return self.on_done_function.launch(deepcopy(self.data))
    endif

    echomsg "done"
endfunction


function s:_append_output(buffer, output_data)
    call map(a:output_data, 'v:val[-1:] ==# "\r" ? v:val[:-2] : v:val')

    let a:buffer[-1] .= a:output_data[0]
    call extend(a:buffer, a:output_data[1:])
endfunction

function s:on_stdout(input) abort dict
    call s:_append_output(self.data.stdout, a:input)
endfunction

function s:on_stderr(input) abort dict
    call s:_append_output(self.data.stderr, a:input)
endfunction


"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
