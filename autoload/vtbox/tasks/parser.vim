"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:parser = vtbox#tasks#parser#factory#create()
let s:logger = vtbox#utils#logger#create()

"
" impl::api
"
function vtbox#tasks#parser#complete(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction


function vtbox#tasks#parser#execute(qargs)
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
    if has_key(a:input, 'list') || empty(a:input)
        return vtbox#tasks#list#show()
    endif

    if has_key(a:input, "edit")
        return vtbox#utils#unite#files_list#show(
                    \ vtbox#tasks#toml#file())
    endif

    if has_key(a:input, "last_executed")
        if vtbox#tasks#running().has_value()
            return vtbox#warning(vtbox#tasks#stamp(),
                        \ 'task running: '.vtbox#tasks#running().value(), ' | kill or wait')
        endif

        if vtbox#tasks#executed#snapshot#api().has_data()
            return vtbox#tasks#executed#show()
        endif

        return vtbox#warning(
                    \ vtbox#tasks#stamp(), 'no finished tasks so far')
    endif
endfunction


function s:is_input_valid(parsed)
    call s:logger.clear()

    if !vtbox#utils#vital#OptionParser#any_known_option(a:parsed, s:parser)
        call s:logger.append('no valid options provided')
    endif

    return s:logger.empty()
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)

    unlet l:parsed.__unknown_args__ | return l:parsed
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
