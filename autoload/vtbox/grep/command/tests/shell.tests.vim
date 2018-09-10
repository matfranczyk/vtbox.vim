let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
let s:tests_path = fnamemodify(expand('<sfile>'), ":p:h")
let s:impl_file = s:tests_path."/../shell.vim"

let s:impl_func = themis#helper('scope').funcs(s:impl_file)

let s:assert = themis#helper('assert')
call themis#helper('command').with(s:assert)

"
" helpers
"
let s:valid_path = vtbox#utils#filesystem#full_path("./")

"
" TestSuite
"
let s:common_excludes_dirs = '--exclude-dir=.svn --exclude-dir=.git --exclude-dir=.vim.cache'

let s:suite = themis#suite("GrepShellComposingCommonExcludes")

    function! s:suite.assert_common_ignoring_dirs()
        call s:assert.equals(
                    \ s:impl_func.exclude_common_dirs(),
                    \ s:common_excludes_dirs
                    \ )
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposingUsingComposerApi")
    function! s:suite.two_commands()
        let l:input = [
            \ {'fixed' : ['f_p'], 'paths' : [s:valid_path]   },
            \ {'regex' : ['r_p'], 'paths' : ['/home']},
            \ ]
        let l:output = [
            \ 'grep -IHnr -F "f_p" '.s:valid_path.' '.s:common_excludes_dirs,
            \ 'grep -IHnr -E ''r_p'' /home/ '.s:common_excludes_dirs
            \ ]

        call s:assert.equals(
                    \ vtbox#grep#command#shell#compose(l:input),
                    \ l:output)
    endfunction


    function! s:suite.remove_invalid_command()
        let l:input = [
            \ {'fixed'   : ['f_p'], 'paths' : ['./']   },
            \ {'invalid' : ['r_p'], 'paths' : ['/home']},
            \ ]
        let l:output = ['grep -IHnr -F "f_p" '.s:valid_path.' '.s:common_excludes_dirs]

        call s:assert.equals(
                    \ vtbox#grep#command#shell#compose(l:input),
                    \ l:output)
    endfunction


    function! s:suite.throw_when_cannot_construct()
        let l:input = [
            \ {'fixed'   : ['f_p'], 'paths' : ['/invalid/path']   },
            \ {'invalid' : ['r_p'], 'paths' : ['/home']},
            \ ]

        Throws :call vtbox#grep#command#shell#compose(l:input)
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposingUsingSingleComposer")

    function! s:suite.sunny_day()
    let l:input = {
        \ 'fixed'        : ['pattern'],
        \ 'paths'        : ['./'],
        \ 'insensitive'  : 0,
        \ 'include'      : ['include'],
        \ 'exclude'      : ['exclude'],
        \ 'exclude_dir'  : ['exclude_dir'],
        \}

        let l:output = 'grep -IHnir -F "pattern" '.s:valid_path.' --include=include --exclude=exclude --exclude-dir=exclude_dir '.s:common_excludes_dirs

        call s:assert.equals(
                    \ vtbox#grep#command#shell#single_command(l:input),
                    \ l:output)
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposer_FlagsTs")

    function! s:suite.default_flags()
        call s:assert.equals(
                    \ s:impl_func.extract_flags({'insensitive' : 1}),
                    \ '-IHnir')
    endfunction

    function! s:suite.default_flags()
        call s:assert.equals(
                    \ s:impl_func.extract_flags({'regex' : "pattern"}),
                    \ '-IHnr')
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposer_PatternsTs")

    function! s:suite.throw_if_no_patterns()
        Throws :call vtbox#grep#command#shell#compose_pattern(
                    \ {'paths' : ['./'], 'insensitive' : 1})
    endfunction

    function! s:suite.throw_for_both_regex_and_fixed()
        Throws :call vtbox#grep#command#shell#compose_pattern(
                    \ {'fixed' : ['pattern'], 'regex' : ['pattern']})
    endfunction


    function! s:suite.throw_if_more_than_one_fixed_pattern()
        Throws :call vtbox#grep#command#shell#compose_pattern(
                    \ {'regex' : ['pattern_1', 'pattern_2']})
    endfunction


    function! s:suite.extract_regex_pattern()
        let l:output = vtbox#grep#command#shell#compose_pattern(
                    \ {'regex' : ['rpattern']})

        call s:assert.equals(l:output, '-E rpattern')
    endfunction


    function! s:suite.extract_regex_pattern()
        let l:output = vtbox#grep#command#shell#compose_pattern(
                    \ {'fixed' : ['fpattern']})

        call s:assert.equals(l:output, '-F "fpattern"')
    endfunction

"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposer_PathsTs")

    function! s:suite.test_sunny_day()
        let l:expect = vtbox#utils#filesystem#full_path('./')
                    \ ." ".vtbox#utils#filesystem#full_path('/home')

        call s:assert.equals(
                    \ vtbox#grep#command#shell#compose_paths(
                    \   {'paths' : ['./', '/home']}),
                    \ l:expect)
    endfunction


    function! s:suite.throw_if_no_paths()
        Throws :call vtbox#grep#command#shell#compose_paths(
                    \ {'regex' : ['pattern_1']})
    endfunction

    function! s:suite.throw_if_no_valid_paths()
        Throws :call vtbox#grep#command#shell#compose_paths(
                    \ {'paths' : ['/invalid/paths_1', './invalid/paths']})
    endfunction


    function! s:suite.extract_only_valid_paths()
        call s:assert.equals(
                    \ vtbox#grep#command#shell#compose_paths(
                    \   {'paths' : ['./', '/invalid/next_paths']}),
                    \ vtbox#utils#filesystem#full_path('./'))
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposer_FormatIncludes")

    function! s:suite.sunny_day()
        let l:input = {'include' : ['first', 'second']}
        let l:ouput = "--include=first --include=second"

        call s:assert.equals(
                    \ s:impl_func.extract_includes(l:input),
                    \ l:ouput)
    endfunction


    function! s:suite.no_includes()
        call s:assert.empty(
                    \ s:impl_func.extract_includes({'no' : 'null'}))
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposer_FormatExcludes")

    function! s:suite.sunny_day()
        let l:input = {'exclude' : ['first', 'second']}
        let l:ouput = "--exclude=first --exclude=second"

        call s:assert.equals(
                    \ s:impl_func.extract_excludes(l:input),
                    \ l:ouput)
    endfunction


    function! s:suite.no_excludes()
        call s:assert.empty(
                    \ s:impl_func.extract_excludes({'no' : 'null'}))
    endfunction


"
" TestSuite
"
let s:suite = themis#suite("GrepShellComposer_FormatExcludesDir")

    function! s:suite.sunny_day()
        let l:input = {'exclude_dir' : ['first', 'second']}
        let l:ouput = "--exclude-dir=first --exclude-dir=second"

        call s:assert.equals(
                    \ s:impl_func.extract_excludes_dir(l:input),
                    \ l:ouput)
    endfunction


    function! s:suite.no_excludes()
        call s:assert.empty(
                    \ s:impl_func.extract_excludes_dir({'no' : 'null'}))
    endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
