# Cheat Sheet

## Cursor Motions

### Moving by Characters, Words
    h j k l - Arrow keys
    w / b - Next/previous word
    W / B - Next/previous word (space seperated)
    e / ge - Next/previous end of word
    
### Moving by Lines
    0 / $ - Start/End of line
    ^ - First non-blank character of line (same as 0w)
    #G / #gg / :# – move to a specified line number (replace # with the line number)

### Moving by Screens
    Ctrl+d - Move down half a page
    Ctrl+u - Move up half a page
    } - Go forward by paragraph (the next blank line)
    { - Go backward by paragraph (the next blank line)
    gg - Go to the top of the page
    G - Go the bottom of the page
    ctrl+e / ctrl+y - Scroll down/up one line

### Moving by Files
     :tag function_name  - jump to that function
     ctrl-] / ctrl-leftclick   - calls :tag on the word under the cursor
     ctrl-o   - goes to previous cursor spot
     ctrl-t   - goes to previous cursor spot where you called :tag
     gx - Open the URL under the cursor
     gf - Open the file located at the filepath under the cursor


## Editing Text
### Inserting Text
    i / a - Start insert mode at/after cursor
    I / A - Start insert mode at the beginning/end of the line
    o / O - Add blank line below/above current line
    ea – insert text at the end of the word
    Esc or Ctrl+[ - Exit insert mode
    d - Delete
    c - Delete, then start insert mode
    You can also combine operators with motions. Ex: d$ deletes from the cursor to the end of the line.

### Editing Text

    r – replace a single character (and return to command mode)
    cc – replace an entire line (deletes the line and moves into insert mode)
    C / c$ – replace from the cursor to the end of a line
    cw – replace from the cursor to the end of a word
    s – delete a character (and move into insert mode)
    J – merge the line below to the current one with a space in between them
    gJ – merge the line below to the current one with no space in between them
    u – undo
    Ctrl + r – redo
    . – repeat last command
    > - Indent one level
    < - Unindent one level
    
### Cutting, Copying and Pasting (Clipboard)

    yy - Yank (copy) a line
    p - Paste after cursor
    P - Paste before cursor
    dd - Delete (cut) a line
    cc - Delete line, then start insert mode
    x - Delete (cut) current character
    X - Delete (cut) previous character
    #yy – copy the specified number of lines
    #dd – cut the specified number of lines
    
### Marking Text (Visual Mode)

    v - Start visual mode
    V - Start linewise visual mode
    Ctrl+v - Start visual block mode
    Esc or Ctrl+[ - Exit visual mode
    Once you have enabled one of the modes, use the navigation keys to select the desired text.
    o - Move to other end of marked area
    O - Move to other corner of block
    aw – select a word
    ab – select a block with ()
    aB – select a block with {}
    at – select a block with <>
    ib – select inner block with ()
    iB – select inner block with {}
    it – select inner block with <>
    Once you have selected the desired text in visual mode, you can use one of the visual commands to manipulate it.
    y – yank (copy) the marked text
    d – delete (cut) the marked text
    p – paste the text after the cursor
    u – change the market text to lowercase
    U – change the market text to uppercase


## Search/Replace

    * – jump to the next instance of the current word
    # – jump to previous instance of the current word
    /pattern - Search for pattern
    ?pattern - Search backward for pattern
    n - Repeat search in same direction
    N - Repeat search in opposite direction
    :%s/old/new/g - Replace all old with new throughout file (gn is better though)
    :%s/old/new/gc - Replace all old with new throughout file with confirmations

## Exiting

    :w - Write (save) the file, but don’t quit
    :wq / :x / ZZ - Write (save) and quit
    :q - Quit (fails if anything has changed)
    :q! / ZQ - Quit and throw away changes


## General

    u - Undo
    Ctrl+r - Redo

# Advanced


## Character Movement

    f [char] - Move forward to the given char
    F [char] - Move backward to the given char
    t [char] - Move forward to before the given char
    T [char] - Move backward to before the given char
    ; / , - Repeat search forwards/backwards


## File Tabs

    :e filename - Edit a file
    :tabe - Make a new tab
    gt - Go to the next tab
    gT - Go to the previous tab
    :vsp - Vertically split windows
    ctrl+ws - Split windows horizontally
    ctrl+wv - Split windows vertically
    ctrl+ww - Switch between windows
    ctrl+wq - Quit a window

## Marks

    Marks allow you to jump to designated points in your code.
    m{a-z} - Set mark {a-z} at cursor position
    A capital mark {A-Z} sets a global mark and will work between files
    '{a-z} - Move the cursor to the start of the line where the mark was set
    '' - Go back to the previous jump location

## Macros

    qa  – record macro a
    q  – stop recording macro
    @a  – run macro a
    @@  – run last macro again

## General

    . - Repeat last command
    Ctrl+r + 0 in insert mode inserts the last yanked text (or in command mode)
    gv - reselect (select last selected block of text, from visual mode)
    % - jumps between matching () or {}
