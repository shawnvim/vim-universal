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
    elseif empty(expand('%:p'))
        exe ":NERDTree"
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

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#GetErlangLsConfig()
    let l:config_linux = expand('~/.config/erlang_ls/erlang_ls.config')
    if filereadable(l:config_linux) || isdirectory(expand('~/.config/erlang_ls/'))
        return l:config_linux
    else
        return ""
    endif
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#IsBlank()
    return strpart(getline('.'), 0, col('.')-1) =~ '^\s*$'
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#GrepEscape(str)
    let str_escape = escape(a:str, '\|[]$')
    let str_shellescape = shellescape(str_escape, 1)
    " let str_quota  = substitute(str_escape, '"' , '"\\""', 'g')
    " let str_dollar = substitute(str_escape, '\$' , '\"\\$\"', 'g')

    return str_shellescape
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#Record2Map()
    silent exe "normal f{"
    let Ending = util#CheckWordAfterBrace()
    if Ending =~ '^}[\s\n ]*='
        let eq = ':='
    else
        let eq = '=>'
    endif
    silent exe "normal dT#"
    silent exe "normal vaby"
    if getreg('"') =~ '\n'
        silent exe "normal gvJ"
    endif

    call sj#elixir#Record2Map('{', '}', eq)
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! util#CheckWordAfterBrace()
    silent exe "normal %"
    exe "normal y2e"
    let Ending = getreg('"')
    silent exe "normal %"
    return Ending
endfunction



