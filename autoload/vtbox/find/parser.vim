"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:parser = vtbox#find#parser#factory#create()
let s:logger = vtbox#utils#logger#create()

"
" impl
"
function s:process(parsed)
    let l:object = vtbox#find#object#new(a:parsed)

    if has_key(a:parsed, "names")
        call l:object.names( vtbox#utils#string#wrap(a:parsed.names, '*') )
    endif

    if has_key(a:parsed, "inames")
        call l:object.inames( vtbox#utils#string#wrap(a:parsed.inames, '*') )
    endif

    return vtbox#find#unite(l:object)
endfunction


function s:is_input_valid(parsed)
    call s:logger.clear()

    if !has_key(a:parsed, "paths")
        call s:logger.append("[!] lack of paths specified")
    endif

    if (!has_key(a:parsed, "names")) && (!has_key(a:parsed, "inames"))
        call s:logger.append("[!] lack of names/inames specified")
    endif

    return s:logger.empty()
endfunction


function s:parse(qargs)
    let l:parsed = s:parser.parse(a:qargs)

    if !empty(l:parsed.__unknown_args__)
        let l:parsed["paths"] = deepcopy(l:parsed.__unknown_args__)
    endif

    unlet l:parsed.__unknown_args__ | return l:parsed
endfunction


"
" impl::api
"
function! vtbox#find#parser#completion(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction


function! vtbox#find#parser#execute(qargs)
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
