"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:parser = vtbox#workspace#grep#parser#factory#create()
let s:logger = vtbox#utils#logger#create()

"
" impl
"
function s:process(input)
    if has_key(a:input, "configuration")
        return vtbox#workspace#grep#settings#get().configuration()
    endif

    let l:object = vtbox#workspace#grep#settings#get().object()

    if has_key(a:input, "fixed")
        call l:object.fixed(a:input.fixed)
    endif

    if has_key(a:input, "regex")
        call l:object.regex(a:input.regex)
    endif

    if has_key(a:input, "insensitive")
        call l:object.icase()
    endif

    call vtbox#grep#execute(l:object, "grep::workspace")
endfunction


function s:is_input_valid(parsed)
    if has_key(a:parsed, "configuration")
        return 1
    endif

    call s:logger.clear()

    if (!has_key(a:parsed, "fixed")) && (!has_key(a:parsed, "regex"))
        call s:logger.append("[!] lack of fixed/regex specified")
    endif

    if has_key(a:parsed, "fixed") && has_key(a:parsed, "regex")
        call s:logger.append("[!] both fixed & regex cannot be provided")
    endif

    return s:logger.empty()
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)
    unlet l:parsed.__unknown_args__ | return l:parsed
endfunction


"
" obj::api
"
function vtbox#workspace#grep#parser#completion(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction


function vtbox#workspace#grep#parser#execute(qargs)
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
