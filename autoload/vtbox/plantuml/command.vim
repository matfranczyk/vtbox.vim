"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:parser = vtbox#plantuml#parser#create()
let s:logger = vtbox#utils#logger#create()

"
" impl::api
"
function vtbox#plantuml#command#complete(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction


function vtbox#plantuml#command#execute(qargs)
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
    let l:file = expand('%:p')

    if has_key(a:input, 'check_syntax')
        return vtbox#plantuml#compile#file(l:file)
    endif

    if has_key(a:input, 'save')
        return vtbox#plantuml#save#file(l:file, s:format(a:input.save))
    endif
endfunction


function s:is_input_valid(parsed)
    call s:logger.clear()

    if empty(a:parsed)
        call s:logger.append('[!] lack of parameters')
    endif

    return s:logger.empty()
endfunction


function s:format(format)
    if a:format == 'txt'
        return 'utxt'
    else
        return 't'.a:format
    endif
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)

    unlet l:parsed.__unknown_args__ | return l:parsed
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
