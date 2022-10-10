fun! setup#screenAndMouse()
    if has("gui_running")
        " Full screen
        set lines=999 columns=999
    else
        " Enable scroll in terminal mode
        :map <ScrollWheelUp> 3<C-Y>
        :map <S-ScrollWheelUp> <C-U>
        :map <ScrollWheelDown> 3<C-E>
        :map <S-ScrollWheelDown> <C-D>
    endif

    " Delete comment character when joining commented and no auto-wrap
    autocmd FileType * setlocal tw=0 formatoptions+=jc

    " In many terminal emulators the mouse works just fine, thus enable it.
    if has('mouse')
        set mouse=a
    endif

endfun


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#paste()
    nnoremap <C-v> "0p
    nnoremap <C-S-v> "+P

    xnoremap <C-v> "0p
    xnoremap <C-S-v> "+p

    " If we use <C-r><C-o>" instead, Vim inserts the contents of the default register literally,
    " using the current value of the default register.
    " And in this case, we can use the dot command to repeat the remaining changes.
    inoremap <C-v> <C-r><C-o>0
    inoremap <C-S-v> <C-r><C-o>+

    cnoremap <C-v> <C-r>0
    cnoremap <C-S-v> <C-r>+

    "" Copy and paste to system register +
    vnoremap  <silent><C-c> "0y:let @+ = getreg('0')<CR>
    nnoremap  <silent><C-c> :let @+ = getreg('0')<CR>

endfun


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#utilFunction(file_plantuml, file_pandoc, path_lua_filters)
    let s:vim_tmp = expand('~/.cache/vim')
    " check path and create if not exist "
    if !isdirectory(s:vim_tmp)
        silent! call mkdir(s:vim_tmp, 'p')
    endif

    function DisplayHTML(Url)
        call netrw#BrowseX(a:Url, 1)
    endfunction

    function DisplaySoffice(Url)
        call system('soffice ' . a:Url . ' &')
    endfunction

    let s:file_plantuml = a:file_plantuml
    function DisplayUML()
        let tmp_uml = s:vim_tmp . '/tmp_uml'
        let tmp_pic = 'svg'
        silent exe "?@startuml?,/@enduml/ w! " . tmp_uml
        call system('java -jar '. s:file_plantuml . ' -t' . tmp_pic . ' ' . tmp_uml)
        call system('mv ' . tmp_uml . '.' . tmp_pic . ' ' . tmp_uml . '.' . 'html')
        call DisplayHTML(tmp_uml . '.' . 'html')
        return
    endfunction

    let s:file_pandoc = a:file_pandoc
    let s:path_lua_filters = a:path_lua_filters
    function DisplayPandoc()
        let cli = s:file_pandoc . ' -f markdown -t html ' . expand("%:p") . 
                    \ ' --lua-filter=' . s:path_lua_filters . '/diagram-generator/diagram-generator.lua' .
                    \ ' --metadata=plantumlPath:' . s:file_plantuml . 
                    \ ' -o ' . expand("%:p:r") . '.html' .
                    \ ' --extract-media=' . expand("%:p:h") . '/media --toc'
        echom cli
        " let cli = s:file_pandoc . ' -f markdown -t html ' . expand("%:p") . ' -o ' . expand("%:p:r") . '.html' .
        "             \ ' --filter ' . g:path_tool . '/pandocfilters/examples/plantuml.py' .
        "             \ ' -s --toc'
        " echom 'Generate html by pandoc: ' . cli
        call system(cli)
        call DisplayHTML(expand("%:p:r") . '.html')
    endfunction

endfun

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#netrw()
    let g:netrw_keepdir = 0 
    let g:netrw_winsize = 30
    let g:netrw_browse_split = 4
    let g:netrw_liststyle = 3
    let g:netrw_altv = 1
endfun

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#NERDTree()
    let NERDTreeQuitOnOpen=1 "close NREDTree after file opened

    noremap <F2> :call NERDTreeToggleInCurDir()<CR>
    function! NERDTreeToggleInCurDir()
        " If NERDTree is open in the current buffer
        if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
            exe ":NERDTreeToggle"
        else
            exe ":NERDTreeFind"
        endif
    endfunction
endfun


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#minibufexpl()
    " ShowBufNum shoule be enable to let mru work
    let g:miniBufExplShowBufNumbers = 1 " def is 1
    let g:miniBufExplSortBy = 'mru'
    let g:miniBufExplMaxSize = 3 
    "   let g:miniBufExplMapWindowNavVim = 1
    let g:miniBufExplBuffersNeeded = 1 "mandatory for buffer switch
    "   let g:miniBufExplMapWindowNavArrows = 1
    "   let g:miniBufExplMapCTabSwitchBufs = 1
    "   let g:miniBufExplModSelTarget = 1
    " Depends on vim-rooter
    let g:miniBufExplStatusLineText = '%!FindRootDirectory()'
    "let t:miniBufExplAutoUpdate = 0
    " Manually set Update Time
    let g:miniBufExplSetUT = 0 " def is 1
    " Too small will let other plugin(Leaderf) slow
    set updatetime=700
endfun


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#TerminalMetaMode(mode)
    set ttimeout
    if $TMUX != ''
        set ttimeoutlen=30
    elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
        set ttimeoutlen=80
    endif
    if te#env#IsNvim() || te#env#IsGui()
        return
    endif
    function! s:metacode(mode, key)
        if a:mode == 0
            exec "set <M-".a:key.">=\e".a:key
        elseif a:mode == 1
            exec "set <M-".a:key.">=\e]{0}".a:key."~"
        else

        endif
    endfunc
    for i in range(10)
        call s:metacode(a:mode, nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
        call s:metacode(a:mode, nr2char(char2nr('a') + i))
        call s:metacode(a:mode, nr2char(char2nr('A') + i))
    endfor
    if a:mode != 0
        for c in [',', '.', '/', ';', '[', ']', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    else
        for c in [',', '.', '/', ';', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_']
            call s:metacode(a:mode, c)
        endfor
    endif
endfunc

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#TerminalMacMode()
    call te#meta#map('map','1','<A-1>')
    call te#meta#map('map','2','<A-2>')
    call te#meta#map('map','3','<A-3>')
    call te#meta#map('map','4','<A-4>')

    call te#meta#map('map','a','<A-a>')
    call te#meta#map('map','b','<A-b>')
    call te#meta#map('map','q','<A-q>')

    call te#meta#map('map','j','<A-j>')
    call te#meta#map('map','k','<A-k>')

endfunc

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#relativenumber()
    set number relativenumber
    nnoremap <Leader>n :call NumberToggle()<CR>
    function! NumberToggle()
        if(&relativenumber == 1)
            set norelativenumber number
        else
            set relativenumber number
        endif
    endfunc
endfunc

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#wrap()
    nnoremap <leader>w :call WrapToggle()<CR>
    function! WrapToggle()
        if(&wrap == 1)
            set nowrap
        else
            set wrap
        endif
    endfunc
endfunc


"-----------------------------------------------------------------------------"
" https://github.com/qiushihao/vim-commentary
"-----------------------------------------------------------------------------"
function! setup#Commentary()


endfunc


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#grep()
    set grepprg=grep

    cnoremap <C-g> <C-R>=' ' . GetRootDirectory() . '/*'<CR>
    function! GetRootDirectory()
        let rootdir = FindRootDirectory()
        if rootdir == ""
            return expand('%:p:h')
        else
            return rootdir
        endif
    endfunction

    let g:grep_exclude = 'out,beam,html,cov,log,Pbeam,history,swp'

    " nnoremap <C-h> :grep! -Hnri --exclude=*.{out,beam,html,cov,log,Pbeam,history,swp} --exclude-dir={test,do3} --exclude=tags --include=*.{erl,hrl} 

    nnoremap <C-h> :<C-U><C-R>=printf("grep! -Hnri " . SetInclude() . "--exclude=\\*.{" . g:grep_exclude . "} --exclude=tags --exclude=\\*.tags %s", expand("<cword>"))<CR>
    xnoremap <C-h> :<C-U><C-R>=printf("grep! -Hnri " . SetInclude() . "--exclude=\\*.{" . g:grep_exclude . "} --exclude=tags --exclude=\\*.tags %s", leaderf#Rg#visual())<CR>
    
    function! SetInclude()
        let extended_name_set = get(b:, 'extended_name_set', '')
        let def_ext_name = expand('%:e')

        if def_ext_name == ""
            return "--include=\\* "
        elseif extended_name_set == ""
            return "--include=\\*.{" . def_ext_name . '} '
        else
            if extended_name_set =~# def_ext_name
                return "--include=\\*.{" . extended_name_set . '} '
            else
                return "--include=\\*.{" . extended_name_set . def_ext_name . '} '
            endif

        endif
    endfunction

endfun

"-----------------------------------------------------------------------------"
" https://github.com/airblade/vim-rooter
"-----------------------------------------------------------------------------"
fun! setup#rooter(rooter_patterns)
    " auto change cwd
    let g:rooter_patterns = a:rooter_patterns
endfun

"-----------------------------------------------------------------------------"
" https://github.com/Yggdroot/LeaderF
" Please init C Engine to speed up
" :LeaderfInstallCExtension
" :echo g:Lf_fuzzyEngine_C
"-----------------------------------------------------------------------------"
fun! setup#Leaderf(file_uctags, file_rg, file_ctags_opt, file_ctags_opt_3gpptxt)
    let g:Lf_HideHelp = 1
    let g:Lf_ShortcutF = "<C-P>"
    let g:Lf_RootMarkers = g:rooter_patterns
    let g:Lf_WorkingDirectoryMode = 'ac'
    let g:Lf_ShowDevIcons = 0
    let g:Lf_Ctags = a:file_uctags
    let g:Lf_ReverseOrder = 1
    let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}
    let g:Lf_Rg = a:file_rg
    let g:Lf_RgConfig = [ 
                \ "--glob='!tags'",
                \ "--glob='!*.tags'"
                \ ]
    let g:Lf_WindowPosition = 'popup'
    let g:Lf_StlColorscheme = 'gruvbox'
    let g:Lf_PopupColorscheme = 'gruvbox_material'
    let g:Lf_CtagsFuncOpts = {
                \ 'erlang': '--options=' . a:file_ctags_opt . ' --kinds-erlang=frdRat',
                \ '3gpptxt': '--options=' . a:file_ctags_opt_3gpptxt,
                \ 'ttcn': '--kinds-ttcn=MtcdfsCaGP',
                \ 'idl': '--language-force=c --kinds-c=dstg',
                \ 'markdown': '--kinds-markdown=csStTu',
                \ }

    nnoremap <silent><C-f> :LeaderfFunction<CR>
    nnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom --current-buffer -e %s ", expand("<cword>"))<CR>
    xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom --current-buffer -e %s ", leaderf#Rg#visual())<CR>
    nnoremap gh :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom -i -e %s ", expand("<cword>"))<CR>
    xnoremap gh :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom -i -e %s ", leaderf#Rg#visual())<CR>
    nnoremap go :<C-U>Leaderf! rg --stayOpen --nowrap --bottom --recall<CR>
    
    nnoremap <silent>gt :Leaderf tag<CR>
    nnoremap <silent>gr :Leaderf rg<CR>
    nnoremap <silent><C-a> :LeaderfFunctionAll<CR>
    
    nnoremap <silent>gq :LeaderfQuickFix<CR>
    nnoremap <silent>gl :LeaderfLocList<CR>
    
endfun


"-----------------------------------------------------------------------------"
" https://github.com/skywind3000/asyncrun.vim
"-----------------------------------------------------------------------------"
fun! setup#asyncrun()
    let g:asyncrun_exit = "echom 'Async job done, check result by <Alt-q>'"
    " let g:asyncrun_open = 17 "open quickfix auto

    nmap <F10> :call AsyncCompileSubSystem('beam')<CR>
    nmap <F11> :call AsyncCompileSubSystem('')<CR>
    nmap <F12> :AsyncStop!<CR>

    function! AsyncCompileSubSystem(cli)
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
            call asyncrun#run("", "", 'gmake -j ' . a:cli)
        endif
        exe ':cd ' . root
    endfunction

    " User defined command Gmake
    command! -nargs=* Gmake call AsyncCompileSubSystem(<q-args>)

endfun

"-----------------------------------------------------------------------------"
" https://github.com/ludovicchabant/vim-gutentags
"-----------------------------------------------------------------------------"
fun! setup#gutentags(file_uctags, file_ctags_opt)
    let s:vim_tags = expand('~/.cache/tags')
    " check path and create if not exist "
    if !isdirectory(s:vim_tags)
        silent! call mkdir(s:vim_tags, 'p')
    endif

    let g:gutentags_ctags_tagfile = '.tags'

    function! RemoveTag()
        execute "silent !rm -f " . s:vim_tags . '/*' . g:gutentags_ctags_tagfile 
    endfunction

    nnoremap <F5> :call RemoveTag()<CR>:GutentagsUpdate<CR>

    let g:gutentags_ctags_executable = a:file_uctags

    "let g:gutentags_add_default_project_roots = 0
    " Defalut root is OK
    let g:gutentags_project_root = g:rooter_patterns
    "let g:gutentags_project_root = ['path.cfg']

    " auto-generated tags will be put into ~/.cache/tags
    let g:gutentags_cache_dir = s:vim_tags


    let g:gutentags_ctags_extra_args=['--options=' . a:file_ctags_opt]


endfun

"-----------------------------------------------------------------------------"
" https://github.com/lfv89/vim-interestingwords
"-----------------------------------------------------------------------------"
fun! setup#interestingwords()
    let g:interestingWordsDefaultMappings = 0
    nnoremap <silent> <C-k> :call InterestingWords('n')<cr>
    vnoremap <silent> <C-k> :call InterestingWords('v')<cr>
    nnoremap <silent> <C-j> :nohl<CR>:call UncolorAllWords()<CR>

    nnoremap <silent> n :call WordNavigation(1)<cr>
    nnoremap <silent> N :call WordNavigation(0)<cr>
endfun

"-----------------------------------------------------------------------------"
" https://github.com/Valloric/ListToggle
"-----------------------------------------------------------------------------"
fun! setup#ListToggle()
    let g:lt_location_list_toggle_map = '<A-l>'
    let g:lt_quickfix_list_toggle_map = '<A-q>'
    let g:lt_height = 27
endfun

"-----------------------------------------------------------------------------"
" https://github.com/qiushihao/quickfix-reflector.vim
"-----------------------------------------------------------------------------"
fun! setup#quickfixreflector()
    " quickfix-reflector will autocmd when BuffReadPost which will affect fugitive
    " add manual keymap to activate quickfix buffer write
    nmap <A-a> :call OnQuickfixInit()<CR>
endfun

"-----------------------------------------------------------------------------"
" https://github.com/mechatroner/rainbow_csv
"-----------------------------------------------------------------------------"
fun! setup#rainbowcsv()
    let g:disable_rainbow_key_mappings = 1
    let g:rcsv_max_columns=999
    let g:multiline_search_range=999
    autocmd BufNewFile,BufRead *.csv   set filetype=rfc_semicolon
endfun

"-----------------------------------------------------------------------------"
" https://github.com/qiushihao/vim-erlang-tagjump
"-----------------------------------------------------------------------------"
fun! setup#vimErlangTagJump(file_uctags, algorithmFile)
    let g:vimErlangTagJump_sortTag = a:algorithmFile
    let g:vimErlangTagJump_sortLengthMax = 15
    autocmd BufNewFile,BufRead *.* let b:extended_name_set =
                \ system(s:file_uctags . ' --list-map-extensions  | grep -i ^' . (&ft == '' ? 'None' : &ft) . 
                \ " | awk \'{print $NF}\' | uniq -i | tr '\\n' ','")
    autocmd BufNewFile,BufRead *.* setlocal tagfunc=vimErlangTagJump#FbTagFunc
    autocmd BufNewFile,BufRead *.erl,*.hrl setlocal tagfunc=vimErlangTagJump#TagFunc
endfun

"-----------------------------------------------------------------------------"
" https://github.com/qiushihao/vim-ttcn
"-----------------------------------------------------------------------------"
fun! setup#vimttcn()
    let g:ttcn_hl_naming_convention = 1
endfun

"-----------------------------------------------------------------------------"
" Convert CLI in terminal
" > soffice --convert-to 3gpptxt:Text *.docx
"-----------------------------------------------------------------------------"
fun! setup#vim3gpptxt()
    au BufRead,BufNewFile *.3gpptxt set filetype=3gpptxt
endfun


"-----------------------------------------------------------------------------"
" https://github.com/tpope/vim-fugitive
"-----------------------------------------------------------------------------"
fun! setup#fugitive()
    let g:fugitive_summary_format = "%an %ai %s"
    nnoremap gb :G blame<CR>
    vnoremap gb :G blame<CR> 
endfun


"-----------------------------------------------------------------------------"
" https://github.com/iamcco/markdown-preview.nvim
"-----------------------------------------------------------------------------"
fun! setup#mkdp()
    let g:mkdp_browserfunc = 'DisplayHTML'
endfun


"-----------------------------------------------------------------------------"
" https://github.com/skywind3000/vim-quickui
"-----------------------------------------------------------------------------"
fun! setup#quickui(file_uctags)

    let g:quickui_ctags_exe = a:file_uctags
    let g:quickui_color_scheme = 'gruvbox'
    let g:quickui_border_style = 2

    let g:quickui_ctags_opts = get(g:, 'Lf_CtagsFuncOpts', {})

    nnoremap <silent><A-1> :call quickui#menu#open()<cr>
    vnoremap <silent><A-1> :call quickui#menu#open()<cr>
    " Previous buffer in buffer list
    nnoremap <silent><A-2> :call quickui#tools#list_buffer('e')<CR>
    nnoremap <silent><A-3> :call quickui#tools#list_function()<CR>
    let g:asyncrun_timer = 1500 " to prevent gui freeze by massive output

endfun


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#quickuiMenu()

    call quickui#menu#reset()

    call quickui#menu#install("&File", [
                \ [ "Goto file in &Project\t(ctrl-p)", 'Leaderf file', 'Open file with leaderf'],
                \ [ "Goto file used &Recent", 'Leaderf mru --regexMode', 'Open recently accessed files'],
                \ [ "--", ],
                \ [ "&Find in file\t(ctrl-f)", 'Leaderf function', 'List functions in current buffer'],
                \ [ "--", ],
                \ [ "&NERDTree\tF2", 'call NERDTreeToggleInCurDir()'],
                \ [ "--", ],
                \ [ "E&xit", 'qa' ],
                \ ])

    call quickui#menu#install("&Make", [
                \ ["Make &All", 'call AsyncCompileSubSystem("all")'],
                \ ["Make &Beam\tF10", 'call AsyncCompileSubSystem("beam")'],
                \ ["Make &General\tF11", 'call AsyncCompileSubSystem("")'],
                \ ["Make &Ts", 'call AsyncCompileSubSystem("ts")'],
                \ ])

    call quickui#menu#install('&Tags', [
                \ ["Tags &Update\tF5", 'GutentagsUpdate'],
                \ ["Tags &Clean", 'call RemoveTag()'],
                \ ])

    call quickui#menu#install("&Display", [
                \ ["Display &MD by MKDP", 'MarkdownPreviewToggle'],
                \ ["Display MD by &Pandoc", 'call DisplayPandoc()'],
                \ ["Display by &Browser", 'call DisplayHTML(expand("%"))'],
                \ ["Display by &UML", 'call DisplayUML()'],
                \ ["Display by S&Office", 'call DisplaySoffice(expand("%"))'],
                \ ])

    call quickui#menu#install("&View", [
                \ ["View GerritC&omments", 'GerritComments'],
                \ ])

    call quickui#menu#install("&Git", [
                \ ["Git &Status", 'G'],
                \ ["Git &Blame\t gb", 'G blame'],
                \ ["Git Browse&Review", 'GBrowse'],
                \ ["Git Browse&Commit", "GBrowse <cword>"],
                \ ["Git Lo&g", '0Gclog'],
                \ ["Git &Diff", 'G difftool'],
                \ ["Git Diff&Master", 'G difftool origin/master...'],
                \ ])

    call quickui#menu#install("&Cancel", [
                \ ["Cancel &AsyncJob\tF12", 'AsyncStop!'],
                \ ])

                " \ ["Git Browse&Commit", "GBrowse \"expand('<cword>')\""],

endfun


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#ToolBar()
    an 1.250 ToolBar.Make			:Gmake<CR>
    an 1.270 ToolBar.RunCtags		:GutentagsUpdate<CR>
endfun


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
fun! setup#SelectCliWithPattern(cli_list, pattern)
    for cli in a:cli_list
        if executable(cli) && system(cli . ' --version | grep -i ' . a:pattern) != ""
            return cli
        else
            continue
        endif
    endfor
    echom a:pattern . " not found"
    return a:cli_list[0]
endfun

