"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:parser = vtbox#file#parser#create()
let s:logger = vtbox#utils#logger#create()


"
" impl::api
"
function vtbox#file#command#complete(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

function vtbox#file#command#execute(qargs)
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
    if has_key(a:input, 'filename')
        return vtbox#echo('filename',
                    \ vtbox#utils#filesystem#filename(expand("%:p")))
    endif

    if has_key(a:input, 'parent_path')
        return vtbox#echo('parent_path',
                    \ vtbox#utils#filesystem#parent_path(expand("%:p")))
    endif

    if has_key(a:input, 'filepath')
        return vtbox#echo('filepath',
                    \ expand("%:p"))
    endif

    if has_key(a:input, 'winpath')
        return vtbox#echo('winpath',
                \ vtbox#utils#filesystem#win_path_from_wsl(expand("%:p")))
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
