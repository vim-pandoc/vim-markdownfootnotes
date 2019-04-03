# WARNING: git repository fsck issue 

This repository has (for its entire lifetime, inherited from the two commits in [VimFootnotes](https://github.com/vim-scripts/VimFootnotes)) had an issue with malformed commits. If your git config has integrity checking turned on, it may be cloned with `git clone --config transfer.fsckobjects=false --config receive.fsckobjects=false --config fetch.fsckobjects=false <url>`. Per discussion in [issue #5](https://github.com/vim-pandoc/vim-markdownfootnotes/issues/5), it is planned to rebase the master branch of this repository to address this issue. This will unfortunately mean all forks and clones will need to be likewise rebased on the updated repository. This will not be done until at least 2019-04-14.

----

## VimFootnotes for Markdown

This fork is a slight tweak of the venerable [vimfootnotes][], for use
with extended markdown.

The new script inserts footnotes in the widely supported extended markdown
syntax:

~~~
Here is some text.[^1]

[^1]: Here is a note.
~~~

The footnote number gets determined by an automatic counter whenever a new
footnote gets inserted. The counter works with the default arabic numerals
and all other settings provided by `b:vimfootnotetype`. The automatic counter
code is based on the code for the counting of HTML footnotes in [this post by
Nick Coleman][3], adjusted slightly to work with Markdown footnotes.

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

![Screenshot][5]

## Installation

Drop `markdownfootnotes.vim` in your plugin directory.

Or use [Pathogen][6].

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

[1]: https://github.com/vim-pandoc/vim-markdownfootnotes/
[2]: http://www.vim.org/scripts/script.php?script_id=431
[3]: http://www.nickcoleman.org/blog/index.cgi?post=footnotevim%21201102211201%21programming
[5]: https://raw.github.com/vim-pandoc/vim-markdownfootnotes/master/footnotes.png
[6]: https://github.com/tpope/vim-pathogen
