# Cheat Sheet

The most important commands and shortcuts to master Vim.

<br>

## Cursor Motions

### Moving by Characters, Words

|||
|-|-|
<kbd>h</kbd> <kbd>j</kbd> <kbd>k</kbd> <kbd>l</kbd> | Arrow keys
<kbd>←</kbd> <kbd>↓</kbd> <kbd>↑</kbd> <kbd>→</kbd> | Arrow keys
<kbd>w</kbd>                                        | Next word
<kbd>b</kbd>                                        | Previous word
<kbd>W</kbd>                                        | Next word (space seperated)
<kbd>B</kbd>                                        | Previous word (space seperated)
<kbd>e</kbd>                                        | Next end of word
<kbd>ge</kbd>                                       | Previous end of word

<br>

### Moving by Lines

|||
|-|-|
<kbd>0</kbd>                                                        | Start of line
<kbd>$</kbd>                                                        | End of line
<kbd>^</kbd> / <kbd>0w</kbd>                                        | First non-blank character of line
<kbd>Num</kbd><kbd>G</kbd> / <kbd>Num</kbd><kbd>gg</kbd> / `:[num]` | Move to a specified line number

<br>

### Moving by Screens

|||
|-|-|
 <kbd>Ctrl-D</kbd> |  Move down half a page
 <kbd>Ctrl-U</kbd> |  Move up half a page
 <kbd>}</kbd>      |  Go forward by paragraph (the next blank line)
 <kbd>{</kbd>      |  Go backward by paragraph (the next blank line)
 <kbd>gg</kbd>     |  Go to the top of the page
 <kbd>G</kbd>      |  Go the bottom of the page
 <kbd>Ctrl-E</kbd> |  Scroll down one line
 <kbd>Ctrl-Y</kbd> |  Scroll up one line

<br>

### Moving by Files

|||
|-|-|
`:tag [function_name]`                        | Jump to that function
<kbd>Ctrl-]</kbd> / <kbd>Ctrl-LeftClick</kbd> | Call :tag on the word under the cursor
<kbd>Ctrl-O</kbd>                             | Go to previous cursor spot
<kbd>Ctrl-T</kbd>                             | Go to previous cursor spot where you called :tag
<kbd>gx</kbd>                                 | Open the URL under the cursor
<kbd>gf</kbd>                                 | Open the file located at the filepath under the cursor

<br>

## Editing Text
### Inserting Text

|||
|-|-|
<kbd>i</kbd> / <kbd>a</kbd>                   | Start insert mode at/after cursor
<kbd>I</kbd> / <kbd>A</kbd>                   | Start insert mode at the beginning/end of the line
<kbd>o</kbd> / <kbd>O</kbd>                   | Add blank line below/above current line
<kbd>ea</kbd>                      | Insert text at the end of the word
<kbd>Esc</kbd> / <kbd>Ctrl-[</kbd> | Exit insert mode
<kbd>d</kbd>                       | Delete
<kbd>c</kbd>                       | Delete, then start insert mode

You can also combine operators with motions. E.g.: <kbd>d$</kbd> deletes from the cursor to the end of the line.

### Editing Text

|||
|-|-|
<kbd>r</kbd>                       | replace a single character (and return to command mode)
<kbd>cc</kbd>                      | replace an entire line (deletes the line and moves into insert mode)
<kbd>C</kbd> / <kbd>c$</kbd>       | replace from the cursor to the end of a line
<kbd>cw</kbd>                      | replace from the cursor to the end of a word
<kbd>s</kbd>                       | delete a character (and move into insert mode)
<kbd>J</kbd>                       | merge the line below to the current one with a space in between them
<kbd>gJ</kbd>                      | merge the line below to the current one with no space in between them
<kbd>u</kbd>                       | undo
<kbd>Ctrl-R</kbd>                  | redo
<kbd>.</kbd>                       | repeat last command
<kbd>></kbd>                       | Indent one level
<kbd><</kbd>                       | Unindent one level

<br>

### Cutting, Copying and Pasting (Clipboard)

|||
|-|-|
<kbd>yy</kbd>  | Yank (copy) a line
<kbd>p</kbd>   | Paste after cursor
<kbd>P</kbd>   | Paste before cursor
<kbd>dd</kbd>  | Delete (cut) a line
<kbd>cc</kbd>  | Delete line, then start insert mode
<kbd>x</kbd>   | Delete (cut) current character
<kbd>X</kbd>   | Delete (cut) previous character
<kbd>#yy</kbd> | Copy the specified number of lines
<kbd>#dd</kbd> | Cut the specified number of lines

<br>

### Marking Text (Visual Mode)

|||
|-|-|
<kbd>v</kbd>                       | Start visual mode
<kbd>V</kbd>                       | Start linewise visual mode
<kbd>Ctrl-V</kbd>                  | Start visual block mode
<kbd>Esc</kbd> / <kbd>Ctrl-[</kbd> | Exit visual mode

<br>

Once you have enabled one of the modes, use the navigation keys to select the desired text.

|||
|-|-|
<kbd>o</kbd>  | Move to other end of marked area
<kbd>O</kbd>  | Move to other corner of block
<kbd>aw</kbd> | Select a word
<kbd>ab</kbd> | Select a block with ()
<kbd>aB</kbd> | Select a block with {}
<kbd>at</kbd> | Select a block with <>
<kbd>ib</kbd> | Select inner block with ()
<kbd>iB</kbd> | Select inner block with {}
<kbd>it</kbd> | Select inner block with <>

Once you have selected the desired text in visual mode, you can use one of the visual commands to manipulate it.

|||
|-|-|
<kbd>y</kbd> | Yank (copy) the marked text
<kbd>d</kbd> | Delete (cut) the marked text
<kbd>p</kbd> | Paste the text after the cursor
<kbd>u</kbd> | Change the market text to lowercase
<kbd>U</kbd> | Change the market text to uppercase

<br>


## Search/Replace

|||
|-|-|
<kbd>\*</kbd>             | Jump to the next instance of the current word
<kbd>#</kbd>              | Jump to previous instance of the current word
<kbd>/pattern</kbd>       | Search for pattern
<kbd>?pattern</kbd>       | Search backward for pattern
<kbd>n</kbd>              | Repeat search in same direction
<kbd>N</kbd>              | Repeat search in opposite direction
`:%s/old/new/g`  | Replace all old with new throughout file (gn is better though)
`:%s/old/new/gc` | Replace all old with new throughout file with confirmations

<br>

## Exiting

|||
|-|-|
`:w`            | Write (save) the file, but don’t quit
`:wq` / `:x` / <kbd>ZZ</kbd> | Write (save) and quit
`:q`            | Quit (fails if anything has changed)
`:q!` / <kbd>ZQ</kbd>      | Quit and throw away changes

<br>


# Advanced


## Character Movement

|||
|-|-|
<kbd>f</kbd><kbd>Char</kbd> | Move forward to the given char
<kbd>F</kbd><kbd>Char</kbd> | Move backward to the given char
<kbd>t</kbd><kbd>Char</kbd> | Move forward to before the given char
<kbd>T</kbd><kbd>Char</kbd> | Move backward to before the given char
<kbd>;</kbd> / <kbd>,</kbd> | Repeat search forwards/backwards

<br>


## File Tabs

|||
|-|-|
`:e filename` | Edit a file
`:tabe` | Make a new tab
<kbd>gt</kbd> | Go to the next tab
<kbd>gT</kbd> | Go to the previous tab
`:vsp` | Vertically split windows
<kbd>Ctrl-WS</kbd> | Split windows horizontally
<kbd>Ctrl-WV</kbd> | Split windows vertically
<kbd>Ctrl-WW</kbd> | Switch between windows
<kbd>Ctrl-WQ</kbd> | Quit a window

<br>

## Marks

Marks allow you to jump to designated points in your code.

|||
|-|-|
<kbd>m</kbd><kbd>{a-z}</kbd> | Set mark {a-z} at cursor position<br>A capital mark {A-Z} sets a global mark and will work between files
<kbd>'</kbd><kbd>{a-z}</kbd> | Move the cursor to the start of the line where the mark was set
<kbd>''</kbd>     | Go back to the previous jump location

<br>

## Macros

|||
|-|-|
<kbd>qa</kbd> | record macro a
<kbd>q </kbd>  | stop recording macro
<kbd>@a </kbd>  | run macro a
<kbd>@@ </kbd>  | run last macro again

<br>

## General

|||
|-|-|
<kbd>.</kbd> | Repeat last command
<kbd>Ctrl-R</kbd><kbd>0</kbd> | in insert mode inserts the last yanked text (or in command mode)
<kbd>gv</kbd> | reselect (select last selected block of text, from visual mode)
<kbd>%</kbd> | jumps between matching () or {}

<br>

