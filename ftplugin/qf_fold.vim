"set nowrap
setlocal foldlevel=0
setlocal foldmethod=expr

setlocal foldtext=matchstr(getline(v:foldstart),'^[^\|]\\+').'\ ['.(v:foldend-v:foldstart+1).'\ lines]'
"setlocal foldexpr=matchstr(substitute(getline(v:lnum),'\|.*','',''),'^.*/')==#matchstr(substitute(getline(v:lnum+1),'\|.*','',''),'^.*/')?1:'<1'

setlocal foldexpr=matchstr(getline(v:lnum),'^[^\|]\\+')==#matchstr(getline(v:lnum+1),'^[^\|]\\+')?1:'<1'

if foldclosedend(1) == line('$') 
  " When all matches come from a single file, do not close that single fold;
  " the user probably is interested in the contents.  Likewise if few results.
  setlocal foldlevel=1
else
  setlocal foldlevel=0
endif

"setlocal foldexpr=matchstr(substitute(getline(v:lnum),'\|.*','',''),'^.*/')==#matchstr(substitute(getline(v:lnum+1),'\|.*','',''),'^.*/')?matchstr(getline(v:lnum),'^[^\|]\\+')==#matchstr(getline(v:lnum+1),'^[^\|]\\+')?2:'<1':'<1'
