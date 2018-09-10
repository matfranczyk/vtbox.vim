"----------------------------------
let s:cpo_save = &cpo | set cpo&vim
"----------------------------------
"
" impl::api
"
function vtbox#utils#cpp#flip(filename)
	if match(a:filename,'\.c') > 0
		return substitute(a:filename,'\.c\(.*\)', '.h*', "")
    endi

	if match(a:filename,"\\.h") > 0
		return substitute(a:filename,'\.h\(.*\)', '.c*', "")
	endif

	throw "filename has unmatched filename"
endfunction

"---------------------------------------
let &cpo = s:cpo_save | unlet s:cpo_save
"---------------------------------------
