"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#vital#OptionParser#generic_execution(
            \ parsed_input,
            \ input_validator_callback,
            \ process_callback,
            \ parser,
            \ logger)

    if a:input_validator_callback(a:parsed_input)
        return a:process_callback(a:parsed_input)
    endif

    return s:invalid_usage(
                \ a:parser,
                \ a:logger.withdraw())
endfunction


function vtbox#utils#vital#OptionParser#any_known_option(parsed_input, parser)
    let l:options = values(a:parser.options)

    for selected in keys(a:parsed_input)
        if count(l:options, selected) >= 0
            return 1
        endif
    endfor

    return 0
endfunction

"
" impl
"
function s:invalid_usage(parser, message)
    call vtbox#log#echo(
            \ "\n>> Invalid usage << \n"
            \ .a:message
            \ ."\n\n"
            \ .s:information(a:parser)
            \ )
endfunction


function s:information(parser)
    return
         \ a:parser.help()
         \ ."\n"
         \ .s:howto()
endfunction


function s:howto()
    return join([
        \ "\n",
        \ "HowTo: providing arguments for specific option like '--optoin=VALUE'",
        \ "",
        \ "  - spaces are not supported   ( --option=valid  |  --option=inv alid )",
        \ "  - multiple values by ','     ( --option=first,second )",
        \ "\n"
        \ ], "\n")
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
