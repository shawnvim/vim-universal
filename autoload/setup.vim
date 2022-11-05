"-----------------------------------------------------------------------------"
"------------- Use gx to open URL, use gf to go to directory -----------------"
"-----------------------------------------------------------------------------"

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#mkdir(path)
    let dir = expand(a:path)
    " check path and create if not exist "
    if !isdirectory(dir)
        silent! call mkdir(dir, 'p')
    endif
    return dir
endfunction


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#startify()
    call setup#mkdir('~/.cache/vim/files/info')
    set viminfo+=r$TEMP:,r$TMP:,r$TMPDIR:,n$HOME/.cache/vim/files/info/viminfo

    let g:startify_session_dir = setup#mkdir('~/.cache/vim/session')
    set ssop-=curdir

    let g:startify_session_persistence = 0
    let g:startify_change_cmd = 'cd'
    let g:startify_session_sort = 1
    let g:startify_session_number = 3
    let g:startify_padding_left = 3
    let g:startify_session_delete_buffers = 1

    let g:startify_commands = [
                \ {'p': ['Project Finder (Ctrl-P)', 'Leaderf file']},
                \ {'v': ['Visit Vim-universal on Github',
                \        'call netrw#BrowseX("https://github.com/shawnvim/vim-universal", 1)']},
                \ ]
    let g:startify_lists = [
                \ { 'type': 'commands',  'header': ['   Recommendations']    },
                \ { 'type': 'bookmarks', 'header': ['   Vim in Use']          },
                \ { 'type': 'dir',       'header': ['   Recents '. getcwd()] },
                \ { 'type': 'sessions',  'header': ['   Sessions (only for emergency)']           },
                \ ]
    let g:startify_files_number = 7
    let g:startify_bookmarks = [
                \ {'u' : g:path_vimrc},
                \ {'r' : $VIMRUNTIME},
                \ ]
    let g:startify_custom_header = [
                \ '    *------------------------------------------------------*',
                \ '    |                                                      |',
                \ '    |   Welcome to vim-universal                           |',
                \ '    |                                                      |',
                \ '    |   This is a integration for Vim 8.2 or later         |',
                \ '    |                                                      |',
                \ '    |   Please refer to recommendations blew to start      |',
                \ '    |                                                      |',
                \ '    *------------------------------------------------------*',
                \ '',
                \ '',
                \ ]
    function! SaveSession()
        if bufname() == '' || bufname() =~# 'MiniBufExplorer' || bufname() =~# 'NERD_tree'
            return
        elseif isdirectory(g:startify_session_dir)
            let num_rm = system('echo $(ls -l ' . g:startify_session_dir . ' | wc -l)') - g:startify_session_number
            if num_rm > 2
                let num_rm -= 1
                let cli_rm = 'cd ' . g:startify_session_dir . ' && rm $(ls -rt ' . g:startify_session_dir . ' | head -n ' . num_rm . ' )'
                echom 'Too many sessions, cleanup: ' . cli_rm
                call system(cli_rm)
            endif
            let filename = fnamemodify(getcwd(),':t') . '_' . localtime()
            execute("SSave! " . filename)
        endif
    endfunction
    au VimLeave * call SaveSession()
    let g:startify_session_before_save = [ 'silent! tabdo NERDTreeClose',
                \                          'silent! tabdo MBECloseAll',
                \ ]
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#screenAndMouse()
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

    " Highlighting tabs and trailing whitespaces
    hi link localWhitespaceError Error
    function! ShowBlank()
        " syn match localWhitespaceError /\t\+/ containedin=ALL
        syn match localWhitespaceError /\s$/ containedin=ALL
    endfunction
    au BufNewFile,BufRead * call ShowBlank()

    " In many terminal emulators the mouse works just fine, thus enable it.
    if has('mouse')
        set mouse=a
    endif

endfunction


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#paste()
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

endfunction


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#utilFunction(file_plantuml, file_pandoc, path_lua_filters)
    let s:vim_tmp = setup#mkdir('~/.cache/vim/tmp')

    function DisplayHTML(Url)
        call netrw#BrowseX(a:Url, 0)
    endfunction

    function DisplayHTMLR(Url)
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

endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#netrw()
    let g:netrw_keepdir = 0 
    let g:netrw_winsize = 30
    let g:netrw_browse_split = 4
    let g:netrw_liststyle = 3
    let g:netrw_altv = 1
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/preservim/nerdtree
" ./pack/original/start/nerdtree/
"-----------------------------------------------------------------------------"
function! setup#NERDTree()
    let NERDTreeQuitOnOpen=1 "close NREDTree after file opened

    noremap <F2> :call util#NERDTreeToggleInCurDir()<CR>

endfunction


"-----------------------------------------------------------------------------"
" https://github.com/shawnvim/minibufexpl.vim
" ./pack/forked/start/minibufexpl.vim/
"-----------------------------------------------------------------------------"
function! setup#minibufexpl()
    " ShowBufNum shoule be enable to let mru work
    let g:miniBufExplShowBufNumbers = 1 " def is 1
    let g:miniBufExplSortBy = 'mru'
    let g:miniBufExplMaxSize = 3 
    "   let g:miniBufExplMapWindowNavVim = 1
    let g:miniBufExplBuffersNeeded = 0 "mandatory for buffer switch
    "   let g:miniBufExplMapWindowNavArrows = 1
    "   let g:miniBufExplMapCTabSwitchBufs = 1
    "   let g:miniBufExplModSelTarget = 1
    " Depends on vim-rooter
    let g:miniBufExplStatusLineText = '%!FindRootDirectory()'
    let t:miniBufExplAutoUpdate = 1
    " Manually set Update Time
    let g:miniBufExplSetUT = 0 " def is 1
    " Too small will let other plugin(Leaderf) slow
    set updatetime=749
endfunction

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
    call te#meta#map('map','l','<A-l>')

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
endfunction

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
endfunction


"-----------------------------------------------------------------------------"
" https://github.com/mbbill/undotree
" ./pack/original/start/undotree/
"-----------------------------------------------------------------------------"
function! setup#undotree()
    nnoremap <leader>u :UndotreeToggle<CR>
endfunction


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#grep()
    set grepprg=grep

    cnoremap <C-g> <C-R>=' ' . util#GetRootDirectory() . '/*'<CR>

    let g:grep_exclude = 'out,beam,html,cov,log,Pbeam,history,swp'

    " nnoremap <C-h> :grep! -Hnri --exclude=*.{out,beam,html,cov,log,Pbeam,history,swp} --exclude-dir={test,do3} --exclude=tags --include=*.{erl,hrl} 

    nnoremap <C-h> :<C-U><C-R>=printf("grep! -Hnri " . util#SetInclude() . "--exclude=\\*.{" . g:grep_exclude . "} --exclude=tags --exclude=\\*.tags %s", expand("<cword>"))<CR>
    xnoremap <C-h> :<C-U><C-R>=printf("grep! -Hnri " . util#SetInclude() . "--exclude=\\*.{" . g:grep_exclude . "} --exclude=tags --exclude=\\*.tags %s", leaderf#Rg#visual())<CR>


endfunction

"-----------------------------------------------------------------------------"
" https://github.com/airblade/vim-rooter
" ./pack/original/start/vim-rooter/
"-----------------------------------------------------------------------------"
function! setup#rooter(rooter_patterns)
    " auto change cwd
    let g:rooter_patterns = a:rooter_patterns
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/Yggdroot/LeaderF
" ./pack/original/start/LeaderF/
"-----------------------------------------------------------------------------"
" Please init C Engine to speed up
" :LeaderfInstallCExtension
" :echo g:Lf_fuzzyEngine_C
"-----------------------------------------------------------------------------"
function! setup#Leaderf(file_uctags, file_rg, file_ctags_opt, file_ctags_opt_3gpptxt)
    let g:Lf_HideHelp = 1
    let g:Lf_ShortcutF = "<C-P>"
    let g:Lf_RootMarkers = g:rooter_patterns
    let g:Lf_WorkingDirectoryMode = 'ac'
    let g:Lf_ShowDevIcons = 0
    let g:Lf_UseCache = 0
    let g:Lf_Ctags = a:file_uctags
    " let g:Lf_ReverseOrder = 1
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
    nnoremap <silent><C-S-f> :LeaderfFunctionAll<CR>

    " nnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom --current-buffer -e %s ", expand("<cword>"))<CR>
    " xnoremap gf :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom --current-buffer -e %s ", leaderf#Rg#visual())<CR>
    nnoremap gh :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom -i -e %s ", expand("<cword>"))<CR>
    xnoremap gh :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen --nowrap --bottom -i -e %s ", leaderf#Rg#visual())<CR>
    nnoremap go :<C-U>Leaderf! rg --stayOpen --nowrap --bottom --recall<CR>

    nnoremap <silent><leader>t :Leaderf tag<CR>
    nnoremap <silent><leader>r :Leaderf rg<CR>

    nnoremap <silent><leader>q :LeaderfQuickFix<CR>
    nnoremap <silent><leader>l :LeaderfLocList<CR>
    nnoremap <silent><leader>f :LeaderfSelf<CR>

endfunction


"-----------------------------------------------------------------------------"
" https://github.com/skywind3000/asyncrun.vim
" ./pack/original/start/asyncrun.vim/
"-----------------------------------------------------------------------------"
function! setup#asyncrun()
    let g:asyncrun_exit = "echom 'Async job done, check result by <Alt-q>'"
    " let g:asyncrun_open = 17 "open quickfix auto

    " User defined command Gmake
    command! -nargs=* Gmake call util#AsyncCompileSubSystem(<q-args>)

    nmap <F12> :AsyncStop!<CR>

endfunction

"-----------------------------------------------------------------------------"
" https://github.com/ludovicchabant/vim-gutentags
" ./pack/original/start/vim-gutentags/
"-----------------------------------------------------------------------------"
function! setup#gutentags(file_uctags, file_ctags_opt)
    let s:vim_tags = setup#mkdir('~/.cache/tags')
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


endfunction

"-----------------------------------------------------------------------------"
" https://github.com/lfv89/vim-interestingwords
" ./pack/original/start/vim-interestingwords/
"-----------------------------------------------------------------------------"
function! setup#interestingwords()
    let g:interestingWordsDefaultMappings = 0
    nnoremap <silent> <C-k> :call InterestingWords('n')<cr>
    vnoremap <silent> <C-k> :call InterestingWords('v')<cr>
    nnoremap <silent> <C-j> :nohl<CR>:call UncolorAllWords()<CR>

    nnoremap <silent> n :call WordNavigation(1)<cr>
    nnoremap <silent> N :call WordNavigation(0)<cr>
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/Valloric/ListToggle
" ./pack/original/start/ListToggle/
"-----------------------------------------------------------------------------"
function! setup#ListToggle()
    let g:lt_location_list_toggle_map = '<A-l>'
    let g:lt_quickfix_list_toggle_map = '<A-q>'
    let g:lt_height = 27
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/shawnvim/quickfix-reflector.vim
" ./pack/forked/start/quickfix-reflector.vim/
"-----------------------------------------------------------------------------"
function! setup#quickfixreflector()
    " quickfix-reflector will autocmd when BuffReadPost which will affect fugitive
    " add manual keymap to activate quickfix buffer write
    nmap <A-a> :call OnQuickfixInit()<CR>
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/mechatroner/rainbow_csv
" ./pack/original/start/rainbow_csv/
"-----------------------------------------------------------------------------"
function! setup#rainbowcsv()
    let g:disable_rainbow_key_mappings = 1
    let g:rcsv_max_columns=999
    let g:multiline_search_range=999
    autocmd BufNewFile,BufRead *.csv   set filetype=rfc_semicolon
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/qiushihao/vim-erlang-tagjump
" ./pack/original/start/vim-erlang-tagjump/
"-----------------------------------------------------------------------------"
function! setup#vimErlangTagJump(file_uctags, algorithmFile)
    let s:file_uctags = a:file_uctags
    let g:extended_name_set = {'NONE': []}

    function! UpdateNameSet()
        let file_type = setup#convertedFt()
        if has_key(g:extended_name_set, file_type)
            let b:extended_name_set = get(g:extended_name_set, file_type)
        else
            let b:extended_name_set =
                \ systemlist(s:file_uctags . ' --list-map-extensions  | grep -wi ^' . setup#convertedFt() . 
                \ " | awk \'{print tolower(\$NF)}\' | sort -f | uniq -i")
            let g:extended_name_set[file_type] = b:extended_name_set
        endif
        return
    endfunction

    let g:erlang_minlines = 128
    let g:erlang_maxlines = 999
    let g:vimErlangTagJump_sortTag = a:algorithmFile
    let g:vimErlangTagJump_sortLengthMax = 15
    autocmd BufWinEnter *.* call UpdateNameSet()

    autocmd BufNewFile,BufRead *.* setlocal tagfunc=vimErlangTagJump#FbTagFunc
    autocmd BufNewFile,BufRead *.erl,*.hrl setlocal tagfunc=vimErlangTagJump#TagFunc |
                \ let b:splitjoin_split_callbacks = [
                \ 'sj#elixir#SplitDoBlock',
                \ 'sj#elixir#SplitArray',
                \ 'sj#elixir#SplitCommaParenthesis',
                \ 'sj#elixir#SplitCommaCurlybracket',
                \ 'sj#elixir#SplitPipe',
                \ ] |
                \ let b:splitjoin_join_callbacks = [
                \ 'sj#elixir#JoinDoBlock',
                \ 'sj#elixir#JoinArray',
                \ 'sj#elixir#JoinCommaDelimitedItems',
                \ 'sj#elixir#JoinPipe',
                \ ]

endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#convertedFt()
    if &ft == ''
        return 'NONE'
    elseif &ft == 'cpp'
        return 'c\+\+'
    else
        return &ft
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/qiushihao/vim-ttcn
" ./pack/forked/start/vim-ttcn/
"-----------------------------------------------------------------------------"
function! setup#vimttcn()
    let g:ttcn_hl_naming_convention = 1
endfunction

"-----------------------------------------------------------------------------"
" Convert CLI in terminal
" > soffice --convert-to 3gpptxt:Text *.docx
"-----------------------------------------------------------------------------"
function! setup#vim3gpptxt()
    au BufRead,BufNewFile *.3gpptxt set filetype=3gpptxt
endfunction


"-----------------------------------------------------------------------------"
" https://github.com/tpope/vim-fugitive
" ./pack/original/start/vim-fugitive/
"-----------------------------------------------------------------------------"
function! setup#fugitive()
    let g:fugitive_summary_format = "%an %ai %s"
    nnoremap gb :G blame<CR>
    vnoremap gb :G blame<CR> 
endfunction


"-----------------------------------------------------------------------------"
" https://github.com/shawnvim/markdown-preview.nvim
" ./pack/forked/start/markdown-preview.nvim/
"-----------------------------------------------------------------------------"
function! setup#mkdp()
    let g:mkdp_browserfunc = 'DisplayHTML'
    let g:mkdp_auto_close = 0
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/gelguy/wilder.nvim
" ./pack/original/start/wilder.nvim/
"-----------------------------------------------------------------------------"
function! setup#wilder()
    call wilder#setup({'modes': [':', '/', '?']})
    set shortmess-=S
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/dhruvasagar/vim-table-mode
" ./pack/original/start/vim-table-mode/
"-----------------------------------------------------------------------------"
function! setup#tablemode()
    function! s:isAtStartOfLine(mapping)
        let text_before_cursor = getline('.')[0 : col('.')-1]
        let mapping_pattern = '\V' . escape(a:mapping, '\')
        let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
        return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
    endfunction

    inoreabbrev <expr> <bar><bar>
                \ <SID>isAtStartOfLine('\|\|') ?
                \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
    inoreabbrev <expr> __
                \ <SID>isAtStartOfLine('__') ?
                \ '<c-o>:silent! TableModeDisable<cr>' : '__'
endfunction

"-----------------------------------------------------------------------------"
" https://github.com/skywind3000/vim-quickui
" ./pack/forked/start/vim-quickui/
"-----------------------------------------------------------------------------"
function! setup#quickui(file_uctags)

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

endfunction


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#quickuiMenu()

    call quickui#menu#reset()

    call quickui#menu#install("&File", [
                \ [ "Goto file in &Project\t(ctrl-p)", 'Leaderf file', 'Open file with leaderf'],
                \ [ "Goto file used &Recent", 'Leaderf mru --regexMode', 'Open recently accessed files'],
                \ [ "--", ],
                \ [ "Find &function in current buffer\t(ctrl-f)", 'Leaderf function', 'List functions in current buffer'],
                \ [ "Find function in &all buffers\t(ctrl-shift-f)", 'LeaderfFunctionAll'],
                \ [ "Find &tag\t(leader-t)", 'Leaderf tag'],
                \ [ "Find in &quickfix\t(leader-q)", 'LeaderfQuickFix'],
                \ [ "Find in l&ocationlist\t(leader-l)", 'LeaderfLocList'],
                \ [ "--", ],
                \ [ "&Grep on the fly\t(leader-r)", 'Leaderf rg'],
                \ [ "--", ],
                \ [ "&NERDTree\tF2", 'call util#NERDTreeToggleInCurDir()'],
                \ [ "--", ],
                \ [ "E&xit", 'qa' ],
                \ ])

    call quickui#menu#install("G&make", [
                \ ["&Gmake", 'Gmake'],
                \ ["Gmake &All", 'Gmake all'],
                \ ["Gmake &Beam", 'Gmake beam'],
                \ ["Gmake &Ts", 'Gmake ts'],
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
                \ ["View Gerrit&Comments", 'GerritComments'],
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

endfunction


"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! setup#ToolBar()
    an 1.250 ToolBar.Make			:Gmake<CR>
    an 1.270 ToolBar.RunCtags		:GutentagsUpdate<CR>
endfunction



