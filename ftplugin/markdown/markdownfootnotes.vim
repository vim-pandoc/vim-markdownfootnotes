" Maintainer: David Sanson <dsanson@gmail.com>
" Description: Extended Markdown Footnotes in Vim
" Version: 1.0
" URL: https://github.com/vim-pandoc/vim-markdownfootnotes
"
" I've taken the original and modified the output to fit the widely 
" supported extended markdown format for footnotes.[^note]
"
" [^note]: Like this.
"
" The original script either puts notes at the end, or before your
" email sig line (i.e., if there is a line that consists of two dashes,
" it puts the notes before that line). This version just puts them at 
" the end.
"
" Based On:
"   VimFootnotes
"   Author:	Mikolaj Machowski <mikmach@wp.pl>
"   Version:	0.6
"   Description:	Footnotes in Vim
"   Installation: See below
"   Last Change: pon wrz 30 09:00  2002 C
"   URL: http://www.vim.org/scripts/script.php?script_id=431
"   Help Part:
"     Inspired by Emmanuel Touzery tip:
"     http://vim.sourceforge.net/tip_view.php?tip_id=332 
"     and discussion below (thanks to Luc for pluginization hints) 
"     I added functions and turned it into vim script.
"
" Installation: Drop it to your plugin directory or use pathogen.
"
" Settings:
"
" By default, footnote ids are arabic numerals. You can change this by
" setting b:vimfootnotetype,
"
" 	arabic (default) - [1] [2] [3] ...
" 	alpha  - [a] [b] ... [z] [aa] [bb] ... [zz] [a] ...
"   Alpha  - as above but uppercase [A] ...
"   roman  - [i] [ii] [iii] displayed properly up to 89
"   Roman  - as above but uppercase [I] ... 
"   star   - [*] [**] [***] ...	
"
" Commands:
" 
" Those mappings correspond to two commands that you can use in your own
" mappings:
"
" AddVimFootnote
"  ~  inserts footnotemark at cursor location, inserts footnotemark on new 
"     line at end of file, opens a split window all ready for you to enter in
"     the footnote.

" ReturnFromFootnote
"  ~  closes the split window and returns to the text in proper place. 
"
" These are mapped to <Leader>f and <Leader>r respectively.
" 
" FootnoteNumber
"  ~  Change the current footnote number (one obligatory argument)
"     :FootnoteNumber 5	
"
" FootnoteNumberRestore
"  ~  Restore old footnote number  

" FootnoteUndo
"  ~  Decrease footnote counter by 1
" 
" FootnoteMeta
"  ~  Change type of the footnotes and restart counter (1, a, A, i, I, *)
" 	  :FootnoteMeta
" 		If your previous footnote type was alpha, Alpha, roman, Roman or star
" 		new type will be arabic.
" 		If your previous footnote type was arabic new type will be alpha.
" 	  :FootnoteMeta name_of_the_type
" 		Change footnote type to name_of_the_type. If name_of_the_type is the
" 		same as	your current footnote type nothing would be changed.
" 		You can change your default type of footnote before inserting first
" 		footnote.	
" 
" FootnoteRestore
"  ~  Restore previous footnote type and counter. Unfortunately there is no easy
" 	  way to sort footnotes at the end of file without handmade :!sort on marked
" 	  lines (it doesn't work for 'star' type).
" 	  :FootnoteRestore	
"
"""""""""""""""""""""""""""""""""""""""""""""""""""

if exists("b:loaded_footnote_vim") | finish | endif
	let b:loaded_footnote_vim = 1

let s:cpo_save = &cpo
set cpo&vim

if !exists("g:vimfootnotetype")
	let g:vimfootnotetype = "arabic"
endif
if !exists("g:vimfootnotenumber")
	let g:vimfootnotenumber = 0
endif

" Mappings
if !hasmapto('<Plug>AddVimFootnote', 'i')
	imap <Leader>f <Plug>AddVimFootnote
endif
if !hasmapto('<Plug>AddVimFootnote', 'n')
    nmap <Leader>f <Plug>AddVimFootnote
endif

if !hasmapto('<Plug>ReturnFromFootnote', 'i')
    imap <Leader>r <Plug>ReturnFromFootnote
endif
if !hasmapto('<Plug>ReturnFromFootnote', 'n')
    nmap <Leader>r <Plug>ReturnFromFootnote
endif

nnoremap <Plug>AddVimFootnote :call <SID>VimFootnotes('a')<CR>
inoremap <Plug>AddVimFootnote <C-O>:call <SID>VimFootnotes('a')<CR>

inoremap <Plug>ReturnFromFootnote <C-O>:q<CR><Right>
noremap <Plug>ReturnFromFootnote :q<CR><Right>

" :Footnote commands
command! -nargs=1 FootnoteNumber call <sid>VimFootnoteNumber(<q-args>)
command! -nargs=0 FootnoteNumberRestore call <sid>VimFootnoteNumberRestore()
command! -nargs=0 FootnoteUndo let g:vimfootnotenumber = g:vimfootnotenumber - 1
command! -nargs=? FootnoteMeta call <sid>VimFootnoteMeta(<f-args>)
command! -nargs=0 FootnoteRestore call <sid>VimFootnoteRestore()

function! s:VimFootnoteNumber(newnumber)
	let g:oldvimfootnotenumber = g:vimfootnotenumber
	let g:vimfootnotenumber = a:newnumber - 1
endfunction

function! s:VimFootnoteNumberRestore()
	if exists(g:oldvimfootnotenumber)
		let g:vimfootnotenumber = g:oldvimfootnotenumber
	else
		return 0
	endif
endfunction

function! s:VimFootnoteMeta(...)
	let g:oldvimfootnotetype = g:vimfootnotetype
	let g:oldvimfootnotenumber = g:vimfootnotenumber
	if a:0 == "0"
		if (g:vimfootnotetype == "arabic")
			let g:vimfootnotetype = "alpha"
		else
			let g:vimfootnotetype = "arabic"
		endif
	else
		if (a:1 == g:vimfootnotetype)
			echomsg "You have chosen the same footnote type! Command won't affect."
			return 0
		else
			let g:vimfootnotetype = a:1
		endif
	endif
	let g:vimfootnotenumber = 0
endfunction

function! s:VimFootnoteRestore()
	if exists("g:oldvimfootnotenumber")
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
	
function! s:VimFootnoteType(footnumber)
	if (g:vimfootnotetype =~ "alpha\\|Alpha")
		if (g:vimfootnotetype == "alpha")
			let upper = "0"
		else
			let upper = "-32"
		endif
		if (a:footnumber <= 26)
			let ftnumber = nr2char(a:footnumber+96+upper)
		elseif (a:footnumber <= 52)
		   	let ftnumber = nr2char(a:footnumber+70+upper).nr2char(a:footnumber+70+upper)
		else
			let g:vimfootnotenumber = 1
			let ftnumber = nr2char(97+upper)
		endif
	elseif (g:vimfootnotetype == "star")
		let starnumber = 1
		let ftnumber = ""
		while (starnumber <= a:footnumber)
			let ftnumber = ftnumber . '*'
			let starnumber = starnumber + 1
		endwhile
	elseif (g:vimfootnotetype =~ "roman\\|Roman")
		let ftnumber = ""
		let oneroman = ""
		let counter = g:vimfootnotenumber
		if (counter >= 50)
			let ftnumber = "l"
			let counter = counter - 50
		endif
		if (counter > 39 && counter < 50)
			let ftnumber = "xl"
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
			let tenmodulo = ""
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
		if (g:vimfootnotetype == "Roman")
			let ftnumber = substitute(ftnumber, ".*", "\\U\\0", "g")
		endif
	else
		let ftnumber = a:footnumber
	endif
	return ftnumber
endfunction

function! s:VimFootnotes(appendcmd)
	if (g:vimfootnotenumber != 0)
		let g:vimfootnotenumber = g:vimfootnotenumber + 1
		let g:vimfootnotemark = <sid>VimFootnoteType(g:vimfootnotenumber)
		let cr = "\<cr>"
	else
		let g:vimfootnotenumber = 1
		let g:vimfootnotemark = <sid>VimFootnoteType(g:vimfootnotenumber)
		let cr = "\<cr>"
	endif
	exe "normal ".a:appendcmd."[^".g:vimfootnotemark."]\<esc>" 
	:below 4split
	normal G
	exe "normal o".cr."[^".g:vimfootnotemark."]: "
	startinsert!
endfunction

let &cpo = s:cpo_save
