
set nocompatible
set backspace=indent,eol,start
set bufhidden=delete
set redrawtime=7000    "extend syntax time for large file
set hlsearch           "highlight search

set autoread           "autoload when file is modified
set clipboard+=unnamed "share clipboard
set hidden             "jump to tags without save

" set nocscopetag        "always jump to first tag, now it's replaced by tag/ts
" set guioptions+=b      "bottom scroll bar
" set guioptions-=m      "no menu bar, due to Alt hotkey
set cursorline         " highlight current line
set modeline           " allows you to set variables specific to a file. By default, the first and last five lines are read by Vim for variable settings
set tabstop=4          " number of visual spaces per TAB
set expandtab          " tabs are spaces
set softtabstop=4      " number of spaces in tab when you press the <TAB> or <BS> keys in insert mode
set shiftwidth=4       " number of spaces in tab when you press >>, << or == in command mode
"set number

set cmdheight=2
set laststatus=2

"set scrolloff=10
set showmatch          " show bracket match
set wrap

set nobackup       " no backup files
set noswapfile     " no swap files
set nowritebackup  " only in case you don't want a backup file while editing
set noundofile     " no undo files

"syntax enable
syntax on
filetype plugin indent on

let mapleader = "\<space>"

" syntax for long comments
set synmaxcol=511
set regexpengine=1
syntax sync minlines=127
syntax sync maxlines=255
syntax sync linebreaks=255

set tags=tags;
set tags+=./tags

" root path depends on vimrc
" let g:file_vimrc = index(v:argv, '-u') != -1 ? get(v:argv, index(v:argv, '-u') + 1, '') : $MYVIMRC
" let g:path_vimrc = fnamemodify(g:file_vimrc, ':p:h')
let g:path_vimrc = expand('<sfile>:p:h')
" let g:compile_errorformat = &errorformat

" remove local plugin to avoid the interference
set rtp-=~/.vim
set packpath-=~/.vim
let &rtp .= ','.g:path_vimrc
let &packpath .= ','.g:path_vimrc

" set colorscheme after packpath
colorscheme gruvbox
set background=dark
set t_Co=256
set t_TI= t_TE= "to avoid >4;2m color info in vi mode

" General keymap

" store, save, write
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc><Esc>:w<CR>
vnoremap <C-s> <Esc><Esc>:w<CR>

" Shift-Backspace to delete a word
inoremap <S-BS> <C-w>

let g:path_tool      = g:path_vimrc . '/toolhouse'
let g:path_bin       = g:path_vimrc . '/bin'
let g:path_lib       = g:path_vimrc . '/lib'
let g:path_cache     = util#mkdir('~/.cache/vim')

" LSP
let g:lsp_settings_servers_dir = util#mkdir('~/.cache/vim_lsp/servers')
call lsp#install()

" Setup to select general using tools
let s:file_rg        = util#SelectCliWithPattern(['rg', g:path_bin . '/rg'], 'ripgrep')
let s:file_uctags    = util#SelectCliWithPattern(['ctags', g:path_bin . '/ctags'], 'universal\ ctags')
let s:file_pandoc    = util#SelectCliWithPattern(['pandoc', g:path_bin . '/pandoc', expand("~/pandoc")], 'pandoc-types')

let s:file_ctags_opt = g:path_tool . '/opt.ctags'
let s:file_plantuml  = g:path_tool . '/plantuml.jar'

" Personal ctag script or options
let s:file_ctags_opt_3gpptxt = g:path_tool . '/3gpptxt.ctags'

let s:path_lua_filters = g:path_lib . '/lua-filters'

let s:rooter_patterns = ['.root', '.git', '.project']

call setup#startify()
call setup#screenAndMouse()
call setup#paste()
call setup#completion()
call setup#utilFunction(s:file_plantuml, s:file_pandoc, s:path_lua_filters)
call setup#netrw()
call setup#NERDTree()
call setup#minibufexpl()
call te#meta#init()
call setup#TerminalMacMode()
call setup#relativenumber()
call setup#wrap()
call setup#undotree()
call setup#vimMove()
call setup#InsertQuick()
call setup#grep()
call setup#rooter(s:rooter_patterns)
call setup#Leaderf(s:file_uctags, s:file_rg, s:file_ctags_opt, s:file_ctags_opt_3gpptxt)
call setup#asyncrun()
call setup#gutentags(s:file_uctags, s:file_ctags_opt)
call setup#interestingwords()
call setup#ListToggle()
call setup#quickfixreflector()
call setup#rainbowcsv()
call setup#vimErlangTagJump(s:file_uctags, 'default')
" call setup#vimErlangTagJump(g:path_tool . '/levenshtein_distance.py') " you can use your own algorithm, e.g.: levenshtein_distance
call setup#vimttcn()
call setup#vim3gpptxt()
call setup#fugitive()
call setup#mkdp()
call setup#tablemode()
call setup#vimlsp()
call setup#quickui(s:file_uctags)
call setup#wilder()

" Global variables are best used for menu initialization.
call setup#quickuiMenu()
call setup#ToolBar()

" Initialize other runtimepath for personal/internal use,
" you can set to '' if no other rtp needed
let g:path_internal = '/proj/git_workspace/pdupc/ezqisui/vim-internal'
if isdirectory(g:path_internal)
    let &rtp .= ','.g:path_internal
    call internalsetup#env()
    let g:startify_bookmarks += [{'i' : g:path_internal}]
    call internalsetup#tags(s:file_uctags, s:file_ctags_opt)
    call internalsetup#gerrit()
    call internalsetup#quickuiMenu()
    call internalsetup#ToolBar()
    call internalsetup#LogTool()
endif
