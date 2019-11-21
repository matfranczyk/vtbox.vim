"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:parser = vtbox#open#parser#create()
let s:logger = vtbox#utils#logger#create()


"
" impl::api
"
function vtbox#open#command#complete(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

function vtbox#open#command#execute(qargs)
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
    if has_key(a:input, 'split')
        echo "split ".join(a:input['files'])
        return
    endif

    if has_key(a:input, 'vsplit')
        echo "vsplit ".join(a:input['files'])
        return
    endif

    if has_key(a:input, 'tab')
        echo "tab ".join(a:input['files'])
        return
    endif
endfunction


function s:is_input_valid(parsed)
    call s:logger.clear()

    " check every file that is passed here - and provide echo about invalid files

    if !vtbox#utils#vital#OptionParser#any_known_option(a:parsed, s:parser)
        call s:logger.append('no valid options provided')
    endif

    return s:logger.empty()
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)
    let l:parsed["files"] = deepcopy(l:parsed.__unknown_args__)

    unlet l:parsed.__unknown_args__ | return l:parsed
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------

