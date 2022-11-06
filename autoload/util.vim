"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#SelectCliWithPattern(cli_list, pattern)
    for cli in a:cli_list
        if executable(cli) && system(cli . ' --version | grep -i ' . a:pattern) != ""
            return cli
        else
            continue
        endif
    endfor
    echom a:pattern . " not found"
    return a:cli_list[0]
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#SetInclude()
    let extended_name_set = get(b:, 'extended_name_set', [])
    let def_ext_name = expand('%:e')

    if def_ext_name == ""
        return "--include=\\* "
    else
        return "--include=\\*.{" . join(uniq(sort(add(extended_name_set, def_ext_name))),',') . '} '
    endif
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#GetRootDirectory()
    let rootdir = FindRootDirectory()
    if rootdir == ""
        return expand('%:p:h')
    else
        return rootdir
    endif
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#NERDTreeToggleInCurDir()
    " If NERDTree is open in the current buffer
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exe ":NERDTreeToggle"
    else
        exe ":NERDTreeFind"
    endif
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#AsyncCompileSubSystem(cli)
    if executable('gmake')
        let make = 'gmake'
    else
        let make = 'make'
    endif
    let root = getcwd()
    let curdir = expand("%:p:h")
    exe ':cd ' . curdir
    while !filereadable("./Makefile") || system("cat Makefile | grep -i '.*#.*obsolete'") != ""
        cd ..
        if getcwd() == root
            break
        endif
    endwhile
    if filereadable("./Makefile")
        call asyncrun#run("", "", make . ' -j ' . a:cli)
    endif
    exe ':cd ' . root
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#mkdir(path)
    let dir = expand(a:path)
    " check path and create if not exist "
    if !isdirectory(dir)
        silent! call mkdir(dir, 'p', 0700)
    endif
    return dir
endfunction
