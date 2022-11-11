Newbie Guide
=======
 - This is a functional guide to help newcomers get started quickly.  
 - Only **a few** functions are introduced here, and it is better to check the specific introduction of the corresponding plug-in in [`/pack`](https://github.com/shawnvim/vim-universal/tree/master/pack) to get more detailed information.  
 - Tips:  
 `<Leader>` is set as **space bar** by default  
 `<Ctrl-R><Ctrl-W>` for a quick copy from **current word** to command line



Finder
------------
| Command                    | Description
| -------                    | -----------
| `<Ctrl-P>`                 | Finder for **files** in repo
| `<Ctrl-F>`                 | Finder for **functions** in file
| `<Ctrl-H>`                 | Global search by **grep**<br>`<Ctrl-G>` to quick insert current root directory
| `gh`                       | Global search by **ripgrep**<br>`<Shift-Q>` to quick duplicate search result to quickfix

Menu
------------
| Command                    | Description
| -------                    | -----------
| `F2`                       | NERDTree file system explorer
| `<Alt-2>`                  | Most recently used buffers
| `<Alt-3>`                  | Nearby functions
| `<Alt-4>`                  | For internal testing only

| Command                    | Description
| -------                    | -----------
| `<Alt-1>`                  | QuickUI menu for following commands
| |
| `TU`                       | Tags update
| `TS`                       | For internal testing only
| `DM`                       | Display as markdown
| `DF`                       | Display as file(html/doc/...)
| `DD`                       | Display as directory
| `DU`                       | Display as UML
| `DR`                       | For internal testing only
| `GB`                       | Git blame
| `GR`                       | Git browse code review
| `GC`                       | Git browse commit
| `GG`                       | Git commit history log for current buffer
| `GD`                       | Git diff
| `GM`                       | Git diff from origin/master

Quickfix
------------
| Command                    | Description
| -------                    | -----------
| `<Alt-Q>`                  | Quickfix toggle
| `<Leader-G>`               | Grep within quickfix
| `<Leader-R>`               | Restore to original quickfix
| `<Alt-A>`                  | Enable quickfix modification
|  |
| `za`                       | Toggle fold
| `zr`                       | Open all folds
| `zm`                       | Close all folds

Search / Replace
------------
| Command                    | Description
| -------                    | -----------
| `<Ctrl-K>`                 | **Highlight** current word
| `n` `N`                    | Navigate next/previous highlighted word
| `<Ctrl-J>`                 | Clear all highlighted words
| |
| `<Ctrl-N>`                 | **Select** current word to start modify with multiple cursors
| `<Shift-→>`                | Expand selection by character
| `n` `N`                    | Get next/previous occurrence
| `q`                        | Skip current and get next occurrence
| `Q`                        | Remove current selected occurrence
 

Compile
------------
| Command                    | Description
| -------                    | -----------
| `:Gmake [arguments]`       | Use gmake to multi-thread compile **closest parent directory** with **Makefile**


Commentary
------------
| Command                    | Description
| -------                    | -----------
| `F8`                       | Comment
| `F9`                       | Uncomment

Register
------------
| Command                    | Description
| -------                    | -----------
| `"`                        | Open register(**clipboard**)
| `<Ctrl-C>`                 | Copy to register 0 and +(**system register**)
| `<Ctrl-V>`                 | Paste from register 0
| `<Ctrl-Shift-V>`           | Paste from register +

General
------------
| Command                    | Description
| -------                    | -----------
| `<Leader-N>`               | Relative line number toggle
| `<Leader-W>`               | Auto wrap toggle
| `<Leader-U>`               | Undo tree toggle
| |
| `<Ctrl-S>`                 | Save file
| `<Alt-J>` `<Alt-K>`        | Line movement
| `<F12>`                    | Stop background async process


  
  
