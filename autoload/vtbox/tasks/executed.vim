"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#tasks#executed#show()
    return s:unite().create_buffer()
endfunction

"
" impl :: unite buffer
"
function s:unite()
"{{{
    if empty(s:_unite__)
        let s:__unite__ = s:create_unite()
    endif
    return s:__unite__
endfunction
let s:_unite__ = {}
"}}}

function s:create_unite()
    let l:unite =  {
        \ 'source' : {
        \   'name' : vtbox#stamp(vtbox#tasks#stamp(), 'executed'),
        \   'default_kind' : 'command',
        \
        \   'gather_candidates' : function('s:gather_candidates'),
        \ },
        \ 'create_buffer' : function('s:create_buffer')
        \ }

    call unite#define_source(l:unite.source)

    return l:unite
endfunction


function s:create_buffer() dict
    call unite#start(
        \   [self.source.name],
        \   s:create_context(self.source.name))

    call vtbox#tasks#executed#snapshot#api().message()
endfunction


function s:create_context(buffer_name)
    let l:context = unite#init#_context({})

    let l:context.buffer_name = a:buffer_name
    let l:context.wipe = vtbox#utils#unite#wipe_buffer()

    return l:context
endfunction


function s:candidate(word, action)
    return {'word' : a:word, 'action__command' : a:action}
endfunction

function s:gather_candidates(args, context)
    if vtbox#tasks#executed#snapshot#api().has_stderr()
        return [
            \   s:candidate('stdout', 'call vtbox#tasks#executed#show_stdout()'),
            \   s:candidate('stderr', 'call vtbox#tasks#executed#show_stderr()'),
            \ ]
    endif
        return [
            \   s:candidate('stdout', 'call vtbox#tasks#executed#show_stdout()'),
            \ ]
endfunction


function vtbox#tasks#executed#show_stdout()
    call vtbox#utils#unite#list#show_buffer(
                \ 'stdout',
                \ vtbox#tasks#executed#snapshot#api().stdout())
endfunction

function vtbox#tasks#executed#show_stderr()
    call vtbox#utils#unite#list#show_buffer(
                \ 'stderr',
                \ vtbox#tasks#executed#snapshot#api().stderr())
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
