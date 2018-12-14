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
    if has_key(a:input, 'list') || len(keys(a:input)) == 0
        return vtbox#tasks#list()
    endif
endfunction


function s:is_input_valid(parsed)
    call s:logger.clear()

    " if !has_key(a:parsed, 'check_syntax') &&
    "  \ !has_key(a:parsed, 'save')         &&
    "  \ !has_key(a:parsed, 'view')
    "     call s:logger.append('[!] you need to provide one of {check_syntax, save, view} parameters')
    " endif

    return s:logger.empty()
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)

    unlet l:parsed.__unknown_args__ | return l:parsed
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
