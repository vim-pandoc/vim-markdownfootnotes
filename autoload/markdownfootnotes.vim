function! markdownfootnotes#VimFootnoteNumber(newnumber) abort
	let g:oldvimfootnotenumber = g:vimfootnotenumber
	let g:vimfootnotenumber = a:newnumber - 1
endfunction

function! markdownfootnotes#VimFootnoteNumberRestore() abort
	if exists(g:oldvimfootnotenumber)
		let g:vimfootnotenumber = g:oldvimfootnotenumber
	else
		return 0
	endif
endfunction

function! markdownfootnotes#VimFootnoteMeta(...) abort
	let g:oldvimfootnotetype = g:vimfootnotetype
	let g:oldvimfootnotenumber = g:vimfootnotenumber
	if a:0 ==# '0'
		if (g:vimfootnotetype ==? 'arabic')
			let g:vimfootnotetype = 'alpha'
		else
			let g:vimfootnotetype = 'arabic'
		endif
	else
		if (a:1 == g:vimfootnotetype)
			echomsg 'You have chosen the same footnote type! Command won’t affect.'
			return 0
		else
			let g:vimfootnotetype = a:1
		endif
	endif
	let g:vimfootnotenumber = 0
endfunction

function! markdownfootnotes#VimFootnoteRestore() abort
	if exists('g:oldvimfootnotenumber')
		let oldvimfootnotetype2 = g:vimfootnotetype
		let oldvimfootnotenumber2 = g:vimfootnotenumber
		let g:vimfootnotetype = g:oldvimfootnotetype
		let g:vimfootnotenumber = g:oldvimfootnotenumber
		let g:oldvimfootnotetype = oldvimfootnotetype2
		let g:oldvimfootnotenumber = oldvimfootnotenumber2
	else
		echomsg "You didn't change footnote type. Yet."
		return 0
	endif
endfunction

function! markdownfootnotes#VimFootnoteType(footnumber) abort
	if (g:vimfootnotetype =~? 'alpha')
		if (g:vimfootnotetype ==# 'alpha')
			let upper = 0
		else
			let upper = -32
		endif
		if (a:footnumber <= 26)
			let ftnumber = nr2char(a:footnumber+96+upper)
		elseif (a:footnumber <= 52)
		   	let ftnumber = nr2char(a:footnumber+70+upper).nr2char(a:footnumber+70+upper)
		else
			let g:vimfootnotenumber = 1
			let ftnumber = nr2char(97+upper)
		endif
	elseif (g:vimfootnotetype ==? 'star')
		let starnumber = 1
		let ftnumber = ''
		while (starnumber <= a:footnumber)
			let ftnumber = ftnumber . '*'
			let starnumber = starnumber + 1
		endwhile
	elseif (g:vimfootnotetype =~? 'roman')
		let ftnumber = ''
		let oneroman = ''
		let counter = g:vimfootnotenumber
		if (counter >= 50)
			let ftnumber = 'l'
			let counter = counter - 50
		endif
		if (counter > 39 && counter < 50)
			let ftnumber = 'xl'
			let counter = counter - 40
		endif
		if (counter > 10)
			let tenmodulo = counter % 10
			let number_roman_ten = (counter - tenmodulo) / 10
			let romanten = 1
			while (romanten <= number_roman_ten)
				let ftnumber = ftnumber.'x'
				let romanten = romanten + 1
			endwhile
		elseif (counter == 10)
			let ftnumber = ftnumber.'x'
			let tenmodulo = ''
		else
			let tenmodulo = counter
		endif
		if (tenmodulo == 1)
			let oneroman = 'i'
		elseif (tenmodulo == 2)
			let oneroman = 'ii'
		elseif (tenmodulo == 3)
			let oneroman = 'iii'
		elseif (tenmodulo == 4)
			let oneroman = 'iv'
		elseif (tenmodulo == 5)
			let oneroman = 'v'
		elseif (tenmodulo == 6)
			let oneroman = 'vi'
		elseif (tenmodulo == 7)
			let oneroman = 'vii'
		elseif (tenmodulo == 8)
			let oneroman = 'viii'
		elseif (tenmodulo == 9)
			let oneroman = 'ix'
		elseif (tenmodulo == 0)
			let oneroman = ''
		endif
		let ftnumber = ftnumber . oneroman
		if (g:vimfootnotetype ==# 'Roman')
			let ftnumber = substitute(ftnumber, '.*', "\\U\\0", 'g')
		endif
	else
		let ftnumber = a:footnumber
	endif
	return ftnumber
endfunction

function! markdownfootnotes#VimFootnotes(appendcmd) abort
    " save current position
    let s:cur_pos =  getpos('.')
    " Define search pattern for footnote definitions
    let l:pattern = '\v^\[\^(.+)\]:'
    let l:flags = 'eW'
    call cursor(1,1)
    " get first match
    let g:vimfootnotenumber = search(l:pattern, l:flags)
    if (g:vimfootnotenumber != 0)
        let l:temp = 1
        " count subsequent matches
        while search(l:pattern, l:flags) != 0
            let l:temp += 1
        endwhile
        let g:vimfootnotenumber = l:temp + 1
        " Return to position
        call setpos('.', s:cur_pos)
        let g:vimfootnotemark = markdownfootnotes#VimFootnoteType(g:vimfootnotenumber)
    else
        let g:vimfootnotenumber = 1
        " Return to position
        call setpos('.', s:cur_pos)
        let g:vimfootnotemark = markdownfootnotes#VimFootnoteType(g:vimfootnotenumber)
    endif
    let cr = g:vimfootnotelinebreak ? "\<cr>" : ''

    exe 'normal! '.a:appendcmd.'[^'.g:vimfootnotemark."]\<esc>"
    :below 4split
    normal! G
    exe "normal! o\<cr>[^".g:vimfootnotemark.']: '
    startinsert!
endfunction
