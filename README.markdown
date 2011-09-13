## VimFootnotes for Markdown

This fork is a slight tweak of the venerable [vimfootnotes][], for use
with extended markdown.

The original script inserts footnotes that look like this:

~~~
Here is some text.[1]

[1] Here is a note.
~~~

The new script inserts footnotes in the widely supported extended
markdown syntax,

~~~
Here is some text.[^1]

[^1]: Here is a note.
~~~

The original script inserts footnotes at the end of the file **or**
before an email sig line, if any. The new script inserts all footnotes at the
end of the file.

The script defines two mappings, 

~~~
<Leader>f    Insert new footnote 
<Leader>r    Return from footnote
~~~

To insert a footnote, type `<Leader>f`. A footnote mark will be inserted
after the cursor. A matching footnote mark will be inserted at the end
of the file. A new buffer will open in a split window at the bottom of
your screen, ready to edit the new footnote. When you are done, type
`<Leader>r` to close the split and return to the main text.

![Screenshot](https://raw.github.com/vim-pandoc/vim-markdownfootnotes/master/footnotes.png)

## Installation

Drop `markdownfootnotes.vim` in your plugin directory. 

Or use [Pathogen](https://github.com/tpope/vim-pathogen).

## Settings

By default, footnote ids are arabic numerals. You can change this by
setting `b:vimfootnotetype`:

+	`arabic`: 1, 2, 3...
+	`alpha`:  a, b, c, aa, bb..., zz, a...
+   `Alpha`:  A, B, C, AA, BB..., ZZ, A...
+   `roman`:  i, ii, iii... (displayed properly up to 89)
+   `Roman`:  I, II, III... 
+   `star`:   \*, \*\*, \*\*\*...	

## Commands

`AddVimFootnote`
 :  inserts footnotemark at cursor location, inserts footnotemark on new 
    line at end of file, opens a split window all ready for you to enter in
    the footnote.

`ReturnFromFootnote`
 :  closes the split window and returns to the text in proper place. 

These are mapped to `<Leader>f` and `<Leader>r` respectively.

`FootnoteNumber`
 :  Change the current footnote number (one obligatory argument)
    :FootnoteNumber 5	

`FootnoteNumberRestore`
 :  Restore old footnote number  

`FootnoteUndo`
 :  Decrease footnote counter by 1

`FootnoteMeta [<footnotetype>]`
 :  Change type of the footnotes and restart counter (1, a, A, i, I, *)
 
The `<footnotetype>` argument is optional. If omitted, and your previous
footnote type was not `arabic`, the new type will be `arabic`; if it was
arabic, the new type will be `alpha`. If the new type is the same as the
previous type, then the counter will not be restarted.


`FootnoteRestore`
  : Restore previous footnote type and counter.

## Todo

1.  It would not be hard to add support for other plaintext footnote
    formats, triggered by filetype.
2.  I have not really looked very carefully at how the script is
    implemented. I suspect there are ways in which it could be
    refactored and streamlined.


 [vimfootnotes]: http://www.vim.org/scripts/script.php?script_id=431
