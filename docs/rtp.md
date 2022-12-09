# Run Time Path (RTP)

If you have other VIM RTP, you can include it by:
```vim
let g:path_internal = "/Path/To/Your/Other/RTP"
if isdirectory(g:path_internal)
    let &rtp .= ','.g:path_internal
    " let &packpath .= ','.g:path_internal
    call YourOtherFunction()
endif
```
If you have other pack directory, you can include it in a similar way: 
```vim
let &packpath .= ','.g:path_internal
```
