"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:parser = vtbox#themis#parser#factory#create()
let s:logger = vtbox#utils#logger#create()

"
" impl::api
"
function vtbox#themis#command#complete(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction


function vtbox#themis#command#execute(qargs)
    return vtbox#utils#vital#OptionParser#generic_execution(
                \ s:parse(a:qargs),
                \ function('s:is_input_valid'),
                \ function('s:process'),
                \ s:parser,
                \ s:logger)
endfunction

"
" impl
"
function s:process(input)
    if has_key(a:input, "current_buffer")
        return s:launch_tests(expand("%:p"))
    endif

    if has_key(a:input, "regression")
        return s:launch_tests(s:collect_files(getcwd()))
    endif

    if has_key(a:input, "recursively")
        return s:launch_tests(s:collect_files(a:input.recursively))
    endif
endfunction


function s:is_input_valid(parsed)
    call s:logger.clear()

    if !has_key(a:parsed, "current_buffer") &&
     \ !has_key(a:parsed, "regression")     &&
     \ !has_key(a:parsed, "recursively")
        call s:logger.append("no options provided")
    endif

    return s:logger.empty()
endfunction


function s:launch_tests(files)
    let l:results = s:run_tests(
                \ vtbox#utils#vim#is_list(a:files) ? a:files : [a:files])
    let l:number_of_files = len(l:results)

    call filter(l:results, 'v:val.exit_code != 0')

    if !empty(l:results)
        call vtbox#utils#vim#make_qflist(s:create_failed_report(l:results))
        return vtbox#utils#unite#copen()
    endif

    return vtbox#log#message("[themis::passed] number of passing files [".l:number_of_files."]")
endfunction


function s:report_header(results)
    let l:header = [">>> failing files <<<"]
    for result in a:results
        call add(l:header, ">>> ".result.file)
    endfor

    return add(l:header, "\n")
endfunction


function s:create_failed_report(results)
    let l:report = s:report_header(a:results)

    for item in a:results
        call extend(l:report, item.stdout)
    endfor

    return l:report
endfunction


function s:run_tests(files_list)
    return map(a:files_list, 's:execute(v:val)')
endfunction

function s:execute(file)
    return {
        \ 'stdout'    : vtbox#utils#vim#systemlist('themis '.a:file),
        \ 'exit_code' : v:shell_error,
        \ 'file'      : vtbox#utils#filesystem#full_path(a:file)
        \ }
endfunction


function s:collect_files(path)
    return vtbox#utils#vim#systemlist(
                \ 'find '.a:path.' -type f -iname ''*test*vim''')
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)

    if len(l:parsed) == 1 && empty(l:parsed.__unknown_args__)
        unlet  l:parsed.__unknown_args__
    endif

    return l:parsed
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
