"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#plantuml#compile(file)
    call s:async_job(
                \ s:compilation_cmd(a:file),
                \ vtbox#utils#filesystem#filename(a:file),
                \ 'compile')
endfunction

function vtbox#plantuml#export(file, format)
    call s:async_job(
                \ s:export_file_cmd(a:file, a:format),
                \ s:file_conversion(vtbox#utils#filesystem#parent_path(a:file), vtbox#utils#filesystem#filename(a:file), s:format(a:format)),
                \ 'save')
endfunction

function vtbox#plantuml#view(file)
    call s:async_job(
                \ s:view_file_cmd(a:file),
                \ s:file_conversion(s:temp_path(), vtbox#utils#filesystem#filename(a:file), 'utxt'),
                \ 'view')
endfunction

"
" impl::commands
"
let s:bin = fnamemodify(expand('<sfile>'), ":p:h")."/plantuml/bin/plantuml.jar"

function s:format(format)
    return a:format == 'txt' ? 'utxt' : a:format
endfunction

function s:plantuml_format(format)
    if a:format == 'txt'
        return 'utxt'
    else
        return 't'.a:format
    endif
endfunction


function s:compilation_cmd(file)
    return join(['cat', a:file, '|', 'java', '-jar', s:bin, '-pipe', '-syntax'])
endfunction


function s:export_file_cmd(file, format)
    return join(['java', '-jar', s:bin, '-'.s:plantuml_format(a:format), '-failfast2', a:file])
endfunction


function s:view_file_cmd(file)
    return s:export_file_cmd(a:file, 'utxt').' -o '.s:temp_path()
endfunction

function s:temp_path()
    return vtbox#cache_path().'/plantuml'
endfunction


function s:filename_conversion(file, format)
    return vtbox#utils#filesystem#fileroot(vtbox#utils#filesystem#filename(a:file)).'.'.a:format
endfunction

function s:file_conversion(path, file, format)
    return a:path.'/'.s:filename_conversion(a:file, a:format)
endfunction


"
" impl :: async jobs
"
let s:job = vtbox#job#async#create()

function s:async_job(command, file, cmd)
    call s:job.command(a:command)
    call s:job.launch(
                \ {'on_done_function' : function('s:on_done_job', [a:file, a:cmd])} )
endfunction


function s:on_done_job(file, command, exit_status, stdout, stderr, time_start, time_stop)
    let l:msg = a:command." ".a:file

    if a:exit_status == 0
        return s:log(l:msg)
    endif

    call s:error(a:stderr, l:msg)
endfunction


function s:unite()
    if empty(s:__unite__)
        let s:__unite__ = vtbox#utils#unite#qflist#new('planuml')
    endif

    return s:__unite__
endfunction
let s:__unite__ = {}


function s:error(stderr, msg)
    call vtbox#utils#vim#populate_qflist(a:stderr)
    call s:unite().create_buffer('error::last')

    return s:warn(a:msg)
endfunction

"
" impl :: logging
"
function s:log(text)
    call vtbox#log#echo(s:msg(a:text))
endfunction

function s:warn(text)
    call vtbox#log#warning(s:msg(a:text))
endfunction

function s:msg(text)
    return "[Plantuml] ".a:text
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
