"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#workspace#toml#content#find()
    return s:build(
                \ s:find_header,
                \ vtbox#workspace#toml#content#attributes#find())
endfunction


function vtbox#workspace#toml#content#tags()
    return s:build(
                \ s:tags_header,
                \ vtbox#workspace#toml#content#attributes#tags())
endfunction


function vtbox#workspace#toml#content#grep()
    return s:build(
                \ s:grep_header,
                \ vtbox#workspace#toml#content#attributes#grep())
endfunction

"
" impl
"
let s:header_paths = fnamemodify(expand('<sfile>'), ":p:h")."/content/header"

let s:find_header = s:header_paths."/find.toml"
let s:tags_header = s:header_paths."/tags.toml"
let s:grep_header = s:header_paths."/grep.toml"


function s:build(header, content)
    let l:builder = vtbox#workspace#toml#content#builder#create(a:header)
    call l:builder.add(a:content)

    return l:builder.content()
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
