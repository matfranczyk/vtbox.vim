"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:logger = vtbox#utils#logger#create()
let s:ignore_dirs = ['.svn', '.git', vtbox#workspace#cache#dirname()]

"
" impl::api
"
function vtbox#find#command#shell#compose(data)
    call s:logger.clear()

    let l:commands =
        \ filter(map(a:data, 'vtbox#find#command#shell#single_command(v:val)'),
        \       '!empty(v:val)')

    if ! s:logger.empty()
        call vtbox#log#error(s:logger.withdraw())
    endif

    if !empty(l:commands)
        return l:commands
    endif

    call s:throw("cannot compose valid gnu find command")
endfunction


"
" impl
"
function vtbox#find#command#shell#single_command(attributes)
    try
        let l:arguments = [
            \ "find",
            \ vtbox#find#command#shell#compose_paths(a:attributes),
            \ s:exclude_common_dirs(),
            \ s:extract_exclude_dir_names(a:attributes),
            \ s:extract_exclude_dir_inames(a:attributes),
            \ s:extract_exclude_file_names(a:attributes),
            \ s:extract_exclude_file_inames(a:attributes),
            \ vtbox#find#command#shell#compose_names(a:attributes)
            \ ]

        return join(filter(l:arguments, "!empty(v:val)"), ' ')
    catch
        call s:logger.append(v:exception) | return ""
    endtry
endfunction


function s:is_path_valid(path)
    let l:path = vtbox#utils#string#has(a:path, '~') ? expand(a:path) : a:path

    if ! isdirectory(l:path)
        call s:logger.append('invalid path: '.l:path)
        return 0
    endif

    return 1
endfunction

function vtbox#find#command#shell#compose_paths(attributes)
    if !has_key(a:attributes, 'paths')
        call s:throw("lack of paths")
    endif

    let l:paths = filter(copy(a:attributes.paths), 's:is_path_valid(v:val)')

    if empty(l:paths)
        call s:throw("no valid paths")
    endif

    return join(map(l:paths, 'vtbox#utils#filesystem#full_path(v:val)'), " ")
endfunction


function s:format_name(name)
    return "-type f -name ".string(a:name)
endfunction

function s:format_iname(name)
    return "-type f -iname ".string(a:name)
endfunction


function vtbox#find#command#shell#compose_names(asttribute)
    let l:outcome = []

    if has_key(a:asttribute, 'names')
        call extend(l:outcome, map(copy(a:asttribute.names), 's:format_name(v:val)'))
    endif

    if has_key(a:asttribute, 'inames')
        call extend(l:outcome, map(copy(a:asttribute.inames), 's:format_iname(v:val)'))
    endif

    if !empty(l:outcome)
        return join(l:outcome, ' -or ')
    endif

    call s:throw("invalid names/inames")
endfunction


function s:exclude_common_dirs()
    if empty(s:_exclude_common_dirs_)
        let s:_exclude_common_dirs_ =
                    \ join(map(copy(s:ignore_dirs),
                           \ 's:format_exclude_dir_names(v:val)'), " ")
    endif
    return s:_exclude_common_dirs_
endfunction
let s:_exclude_common_dirs_ = ""


function s:extract_attribute(asttribute, name)
    if !has_key(a:asttribute, a:name)
        return ""
    endif

    retur join(map(copy(a:asttribute[a:name]),
                \ 's:format_'.a:name.'(v:val)'), " ")
endfunction


function s:format_exclude_dir_names(name)
    return '-not \( -type d -name '.string(a:name).' -prune \)'
endfunction

function s:format_exclude_dir_inames(name)
    return '-not \( -type d -iname '.string(a:name).' -prune \)'
endfunction

function s:format_exclude_file_names(name)
    return '-not \( -type f -name '.string(a:name).' -prune \)'
endfunction

function s:format_exclude_file_inames(name)
    return '-not \( -type f -iname '.string(a:name).' -prune \)'
endfunction


function s:extract_exclude_dir_names(asttribute)
    return s:extract_attribute(a:asttribute, "exclude_dir_names")
endfunction

function s:extract_exclude_dir_inames(asttribute)
    return s:extract_attribute(a:asttribute, "exclude_dir_inames")
endfunction

function s:extract_exclude_file_names(asttribute)
    return s:extract_attribute(a:asttribute, "exclude_file_names")
endfunction

function s:extract_exclude_file_inames(asttribute)
    return s:extract_attribute(a:asttribute, "exclude_file_inames")
endfunction


function s:throw(info)
    throw "[find:shell:command] ".a:info
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
