"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------

let s:logger  = vtbox#utils#logger#create()
let s:ignore_dirs = ['.svn', '.git', vtbox#workspace#manager#cache#dirname()]

"
" impl::api
"
function vtbox#grep#command#shell#compose(data)
    call s:logger.clear()

    let l:commands =
        \ filter(map(a:data, 'vtbox#grep#command#shell#single_command(v:val)'),
        \       '!empty(v:val)')

    if ! s:logger.empty()
        call vtbox#log#error(s:logger.withdraw())
    endif

    if !empty(l:commands)
        return l:commands
    endif

    call s:throw("cannot compose valid gnu grep command")
endfunction


"
" impl
"
function vtbox#grep#command#shell#single_command(attributes)
    try
        let l:arguments = [
            \ "grep",
            \ s:extract_flags(a:attributes),
            \ vtbox#grep#command#shell#compose_pattern(a:attributes),
            \ vtbox#grep#command#shell#compose_paths(a:attributes),
            \ s:extract_includes(a:attributes),
            \ s:extract_excludes(a:attributes),
            \ s:extract_excludes_dir(a:attributes),
            \ s:exclude_common_dirs()
            \ ]

        return join(filter(l:arguments, "!empty(v:val)"), ' ')
    catch
        call s:logger.append(v:exception) | return ""
    endtry
endfunction


function s:extract_flags(attributes)
    if has_key(a:attributes, 'insensitive')
        return '-IHnir'
    endif

    return '-IHnr'
endfunction


function s:is_path_valid(path)
    let l:path = vtbox#utils#string#has(a:path, '~') ? expand(a:path) : a:path

    if ! isdirectory(l:path)
        call s:logger.append('invalid path: '.l:path)
        return 0
    endif

    return 1
endfunction

function vtbox#grep#command#shell#compose_paths(attributes)
    if !has_key(a:attributes, 'paths')
        call s:throw("lack of paths")
    endif

    let l:paths = filter(copy(a:attributes.paths), 's:is_path_valid(v:val)')

    if empty(l:paths)
        call s:throw("no valid paths")
    endif

    return join(map(l:paths, 'vtbox#utils#filesystem#full_path(v:val)'), " ")
endfunction


function s:escape(fixed_pattern)
    return vtbox#vital#lib("Data.String").replace(a:fixed_pattern, '"', '\"')
endfunction

function vtbox#grep#command#shell#compose_pattern(attributes)
    if has_key(a:attributes, 'regex') && has_key(a:attributes, 'fixed')
        call s:throw("cannot compose for both regex & fixed")
    endif

    if has_key(a:attributes, 'regex')
        if len(a:attributes.regex) > 1
            call s:throw('more than single regex pattern')
        endif

        return "-E '".a:attributes.regex[0]."'"
    endif


    if has_key(a:attributes, 'fixed')
        if len(a:attributes.fixed) > 1
            call s:throw('more than single fixed pattern')
        endif

        return '-F "'.s:escape(a:attributes.fixed[0]).'"'
    endif

    call s:throw("lack of fixed/regex pattern")
endfunction


function s:format_include(arg)
    return "--include=".a:arg
endfunction

function s:extract_includes(attributes)
    if ! has_key(a:attributes, 'include')
        return ""
    endif

    return join(map(copy(a:attributes.include),
                \ 's:format_include(v:val)'), " ")
endfunction


function s:format_exclude(arg)
    return "--exclude=".a:arg
endfunction

function s:extract_excludes(attributes)
    if ! has_key(a:attributes, 'exclude')
        return ""
    endif

    return join(map(copy(a:attributes.exclude),
                \ 's:format_exclude(v:val)'), " ")
endfunction


function s:format_exclude_dir(arg)
    return "--exclude-dir=".a:arg
endfunction


function s:exclude_common_dirs()
    if empty(s:_exclude_common_dirs_)
        let s:_exclude_common_dirs_ =
                    \ join(map(copy(s:ignore_dirs),
                           \ 's:format_exclude_dir(v:val)'), " ")
    endif
    return s:_exclude_common_dirs_
endfunction
let s:_exclude_common_dirs_ = ""


function s:extract_excludes_dir(attributes)
    if ! has_key(a:attributes, 'exclude_dir')
        return ""
    endif

    return join(map(copy(a:attributes.exclude_dir),
                \ 's:format_exclude_dir(v:val)'), " ")
endfunction


function s:extract_attribute(asttribute, name)
    if !has_key(a:asttribute, a:name)
        return ""
    endif

    retur join(map(copy(a:asttribute[a:name]),
                \ 's:format_'.a:name.'(v:val)'), " ")
endfunction


function s:format_exclude_dir_names(name)
    return '-not ( -type d -name '.a:name.' -prune )'
endfunction

function s:format_exclude_dir_inames(name)
    return '-not ( -type d -iname '.a:name.' -prune )'
endfunction

function s:format_exclude_file_names(name)
    return '-not ( -type f -name '.a:name.' -prune )'
endfunction

function s:format_exclude_file_inames(name)
    return '-not ( -type f -iname '.a:name.' -prune )'
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
    throw "[grep:shell:command] ".a:info
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
