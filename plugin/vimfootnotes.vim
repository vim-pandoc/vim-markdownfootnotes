" Author:	Mikolaj Machowski <mikmach@wp.pl>
" Version:	0.3
" Description:	Footnotes in Vim
" Installation: See below
" Last change: czw wrz 26 09:00  2002 C
" 
" Inspired by Emmanuel Touzery tip:
" http://vim.sourceforge.net/tip_view.php?tip_id=332 
" and discussion below (thanks to Luc for pluginization hints) 
" I added functions and turned it into vim script.
"
" Installation: Drop it to your plugin directory but you can declare your
"      favorite types of footnotes in your ftplugins.
"
"
" Commands:
" <Leader>f (in insert mode) - inserts footnotemark, opens at bottom window where
"     footnotemark is also inserted and you are ready to type in your
"     footnotetext.
" <Leader>r (in insert mode) - closes footnote window and returns to the text in
"     proper place. 
"
" You can change them by placing in your vimrc:
"  imap your_map <Plug>AddVimFootnote
"  imap your_map <Plug>ReturnFromFootnote
"
"
"    Footnotes are placed at the end of the file but above signature delimiter
"    (is one exists). 
"
" Settings:
" g:vimfootnotetype - possible values:
" 	arabic (default) - [1] [2] [3] ...
" 	alpha  - [a] [b] ... [z] [aa] [bb] ... [zz] [a] ...
"   Alpha  - as above but uppercase [A] ...
"   star   - [*] [**] [***] ...	
"
" Additional commands:
" FootnoteNumber:
" 	You can change current footnote number (one obligatory argument)
"   :FootnoteNumber 5	
" FootnoteNumberRestore:
"	You can restore old footnote number  
"	:FootnoteNumberRestore	
" FootnoteUndo: 
"	Decrease footnote counter by 1
"	:FootnoteUndo	 
" FootnoteMeta:
" 	Change type of the footnotes and restart counter (1, a, A, *)
" 	:FootnoteMeta
" 		If your previous footnote type was alpha, Alpha or star new type will
" 		be arabic.
" 		If your previous footnote type was arabic new type will be alpha.
" 	:FootnoteMeta name_of_the_type
" 		Change footnote type to name_of_the_type. If name_of_the_type is the
" 		same as	your current footnote type nothing would be changed.
" FootnoteRestore:
" 	Restore previous footnote type and counter. Unfortunately there is no easy
" 	way to sort footnotes at the end of file without handmade :!sort on marked
" 	lines (it doesn't work for 'star' type).
" 	:FootnoteRestore	
"
" For easier work with this commands I would suggest place this lines in your
" vimrc (they offer very nice competion of Vim commands):	
"	set laststatus=2
"	set wildmode=longest,list
"	set wildmenu
"
" And/or map :FootnoteComs for something you like.
"
"""""""""""""""""""""""""""""""""""""""""""""""""""
if exists("g:loaded_footnote_vim") | finish | endif
	let g:loaded_footnote_vim = 1

if !hasmapto('<Plug>AddVimFootnote', 'i')
	imap <Leader>f <Plug>AddVimFootnote
endif
if !hasmapto('<Plug>ReturnFromFootnote', 'i')
    imap <leader>r <Plug>ReturnFromFootnote
endif

imap <Plug>AddVimFootnote <C-O>:call <SID>VimFootnotes()<CR>
imap <Plug>ReturnFromFootnote <C-O>:q<CR><Right>

" :Footnote commands
command! -nargs=1 FootnoteNumber call <sid>VimFootnoteNumber(<q-args>)
command! -nargs=0 FootnoteNumberRestore call <sid>VimFootnoteNumberRestore()
command! -nargs=0 FootnoteUndo 
			\ | let g:vimfootnotenumber = g:vimfootnotenumber - 1
command! -nargs=? FootnoteMeta call <sid>VimFootnoteMeta(<f-args>)
command! -nargs=0 FootnoteRestore call <sid>VimFootnoteRestore()

function! s:VimFootnoteNumber(newnumber)
	let g:oldvimfootnotenumber = g:vimfootnotenumber
	let g:vimfootnotenumber = a:newnumber
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
		echomsg "You didn't chang footnote type. Yet."
		return 0
	endif
endfunction
	
function! s:VimFootnoteType(footnumber)
	if !exists("g:vimfootnotetype")
		let g:vimfootnotetype = "arabic"
	endif
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
		while starnumber <= a:footnumber
			let ftnumber = ftnumber."*"
			let starnumber = starnumber+1
		endwhile
	else
		let ftnumber = a:footnumber
	endif
	return ftnumber
endfunction

function! s:VimFootnotes()
	if exists("g:vimfootnotenumber")
		let g:vimfootnotenumber = g:vimfootnotenumber + 1
		let b:vimfootnotemark = <sid>VimFootnoteType(g:vimfootnotenumber)
		let cr = ""
	else
		let g:vimfootnotenumber = 1
		let b:vimfootnotemark = <sid>VimFootnoteType(g:vimfootnotenumber)
		let cr = "\<cr>"
	endif
	exe "normal a[".b:vimfootnotemark."]\<esc>" 
	:below 4split
	normal G
	if search("^-- $", "bW")
		exe "normal O".cr."[".b:vimfootnotemark."] "
	else
		exe "normal o".cr."[".b:vimfootnotemark."] "
	endif
	startinsert!
endfunction

