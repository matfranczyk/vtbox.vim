"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:logger = vtbox#utils#logger#create()
let s:parser = vtbox#workspace#find#parser#factory#create()

"
" impl
"
function s:process(input)
    if has_key(a:input, "configuration")
        return vtbox#workspace#find#settings#get().configuration()
    endif

    let l:object = vtbox#workspace#find#settings#get().object()

    if has_key(a:input, "names")
        call l:object.names( vtbox#utils#string#wrap(a:input.names, '*') )
    endif

    if has_key(a:input, "inames")
        call l:object.inames( vtbox#utils#string#wrap(a:input.inames, '*') )
    endif

    call vtbox#find#execute(l:object, 'unite', 'find::workspace')
endfunction


function s:is_input_valid(parsed)
    if has_key(a:parsed, "configuration")
        return 1
    endif

    call s:logger.clear()

    if (!has_key(a:parsed, "names")) && (!has_key(a:parsed, "inames"))
        call s:logger.append("[!] lack of names/inames specified")
    endif

    return s:logger.empty()
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)
    unlet l:parsed.__unknown_args__ | return l:parsed
endfunction


"
" impl::api
"
function vtbox#workspace#find#parser#completion(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction


function vtbox#workspace#find#parser#execute(qargs)
    return vtbox#utils#vital#OptionParser#generic_execution(
                \ s:parse(a:qargs),
                \ function('s:is_input_valid'),
                \ function('s:process'),
                \ s:parser,
                \ s:logger)
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
