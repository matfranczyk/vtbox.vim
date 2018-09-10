"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:logger = vtbox#utils#logger#create()
let s:parser = vtbox#grep#parser#factory#create()

"
" impl
"
function s:is_input_valid(parsed)
    call s:logger.clear()

    if !has_key(a:parsed, "paths")
        call s:logger.append("[!] lack of paths specified")
    endif

    if (!has_key(a:parsed, "fixed")) && (!has_key(a:parsed, "regex"))
        call s:logger.append("[!] lack of fixed/regex specified")
    endif

    if has_key(a:parsed, "fixed") && has_key(a:parsed, "regex")
        call s:logger.append("[!] both fixed & regex cannot be provided")
    endif

    return s:logger.empty()
endfunction


function s:create_object(parsed)
    let l:object = vtbox#grep#object#new(a:parsed)

    if has_key(a:parsed, "fixed")
        call l:object.fixed(a:parsed.fixed) | return l:object
    endif

    call l:object.regex(a:parsed.regex) | return l:object
endfunction


function s:process(parsed)
    call vtbox#grep#execute(
                \ s:create_object(a:parsed))
endfunction


function s:parse(qargs)
    let l:data = s:parser.parse(a:qargs)

    if !empty(l:data.__unknown_args__)
        let l:data["paths"] = deepcopy(l:data.__unknown_args__)
    endif

    unlet l:data.__unknown_args__ | return l:data
endfunction


"
" impl::api
"
function vtbox#grep#parser#complete(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction


function vtbox#grep#parser#execute(qargs)
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
