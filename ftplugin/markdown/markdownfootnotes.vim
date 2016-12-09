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
  	inoreabbrev <buffer> [] <c-o>:exe "normal \<Plug>AddVimFootnote"<cr>
endif
if !hasmapto('<Plug>AddVimFootnote', 'n')
    nmap <buffer> <Leader>f <Plug>AddVimFootnote
endif

nnoremap <buffer> <Plug>AddVimFootnote :call markdownfootnotes#VimFootnotes('a')<CR>
inoremap <buffer> <Plug>AddVimFootnote <C-O>:call markdownfootnotes#VimFootnotes('a')<CR>

" :Footnote commands
command! -buffer -nargs=1 FootnoteNumber call markdownfootnotes#VimFootnoteNumber(<q-args>)
command! -buffer -nargs=0 FootnoteNumberRestore call markdownfootnotes#VimFootnoteNumberRestore()
command! -buffer -nargs=0 FootnoteUndo let g:vimfootnotenumber = g:vimfootnotenumber - 1
command! -buffer -nargs=? FootnoteMeta call markdownfootnotes#VimFootnoteMeta(<f-args>)
command! -buffer -nargs=0 FootnoteRestore call markdownfootnotes#VimFootnoteRestore()

let &cpo = s:cpo_save
