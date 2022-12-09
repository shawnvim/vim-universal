# Newbie Guide

 - This is a functional guide to help newcomers get started quickly.  
 - Only **a few** functions are introduced here, and it is better to check the specific introduction of the corresponding plug-in in [`/pack`](https://github.com/shawnvim/vim-universal/tree/master/pack) to get more detailed information.  
 - Tips:  
 <kbd>Leader</kbd> is set as <kbd>Space</kbd> by default  
 <kbd>Ctrl-R</kbd><kbd>Ctrl-W</kbd> for a quick copy from **current word** to command line



## Finder  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>Ctrl-P</kbd>                          | Finder for **files** in repo
| <kbd>Ctrl-F</kbd>                          | Finder for **functions** in file
| <kbd>Ctrl-H</kbd>                          | Global search by **grep**<br><kbd>Ctrl-G</kbd> to quick insert current root directory
| <kbd>gh</kbd>                              | Global search by **ripgrep**<br><kbd>Shift-Q</kbd> to quick duplicate search result to quickfix

## Menu  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>F2</kbd>                              | NERDTree file system explorer
| <kbd>Alt-2</kbd>                           | Most recently used buffers
| <kbd>Alt-3</kbd>                           | Nearby functions
| <kbd>Alt-4</kbd>                           | For internal testing only

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>Alt-1</kbd>                           | QuickUI menu for following commands
| |
| <kbd>TU</kbd>                              | Tags update
| <kbd>TS</kbd>                              | For internal testing only
| <kbd>DM</kbd>                              | Display as markdown
| <kbd>DF</kbd>                              | Display as file(html/doc/...)
| <kbd>DD</kbd>                              | Display as directory
| <kbd>DU</kbd>                              | Display as UML
| <kbd>DR</kbd>                              | For internal testing only
| <kbd>GB</kbd>                              | Git blame
| <kbd>GR</kbd>                              | Git browse code review
| <kbd>GC</kbd>                              | Git browse commit
| <kbd>GG</kbd>                              | Git commit history log for current buffer
| <kbd>GD</kbd>                              | Git diff
| <kbd>GM</kbd>                              | Git diff from origin/master

## Quickfix  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>Alt-Q</kbd>                           | Quickfix toggle
| <kbd>Leader-G</kbd>                        | Grep within quickfix
| <kbd>Leader-R</kbd>                        | Restore to original quickfix
| <kbd>Alt-A</kbd>                           | Enable quickfix modification
|  |
| <kbd>za</kbd>                              | Toggle fold
| <kbd>zr</kbd>                              | Open all folds
| <kbd>zm</kbd>                              | Close all folds

## Search / Replace  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>Ctrl-K</kbd>                          | **Highlight** current word
| <kbd>n</kbd> / <kbd>N</kbd>                | Navigate next/previous highlighted word
| <kbd>Ctrl-J</kbd>                          | Clear all highlighted words
| |
| <kbd>Ctrl-N</kbd>                          | **Select** current word to start modify with multiple cursors
| <kbd>Shift-→</kbd>                         | Expand selection by character
| <kbd>n</kbd> <kbd>N</kbd>                  | Get next/previous occurrence
| <kbd>q</kbd>                               | Skip current and get next occurrence
| <kbd>Q</kbd>                               | Remove current selected occurrence

## Compile  

| Command                                    | Description
| ----------------------                     | ----------------------
| `:Gmake`                             | Use gmake to multi-thread compile **closest parent directory** with **Makefile**

## Commentary  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>F8</kbd>                              | Comment
| <kbd>F9</kbd>                              | Uncomment

## Register  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>"</kbd>                               | Open register(**clipboard**)
| <kbd>Ctrl-C</kbd>                          | Copy to register 0 and +(**system register**)
| <kbd>Ctrl-V</kbd>                          | Paste from register 0
| <kbd>Ctrl-Shift-V</kbd>                    | Paste from register +

## Completion  

| Command (Insert Mode)                      | Description
| ----------------------                     | ----------------------
| <kbd>Tab</kbd> / <kbd>Ctrl-N</kbd>         | Complete list
| <kbd>Shift-Tab</kbd> / <kbd>Ctrl-P</kbd>   | Complete list (reverse)
| <kbd>Ctrl-X</kbd><kbd>Ctrl-O</kbd>         | Omnicomplete list

## LSP  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>Ctrl-D</kbd>                          | LSP definition
| <kbd>Ctrl-Shift-D</kbd>                    | LSP diagnostics<br><kbd>Alt-L</kbd> to toggle location list

## General  

| Command                                    | Description
| ----------------------                     | ----------------------
| <kbd>Leader-N</kbd>                        | Relative line number toggle
| <kbd>Leader-W</kbd>                        | Auto wrap toggle
| <kbd>Leader-U</kbd>                        | Undo tree toggle
| |
| <kbd>Ctrl-S</kbd>                          | Save file
| <kbd>Alt-J</kbd> / <kbd>Alt-K</kbd>        | Line movement
| <kbd>F12</kbd>                             | Stop background async process



