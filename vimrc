
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

"syntax enable
syntax on
filetype plugin indent on

let mapleader = "\<space>"

" syntax for long comments
set synmaxcol=999
syntax sync minlines=128
syntax sync maxlines=999
syntax sync linebreaks=999

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

" General keymap

" store, save, write
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc><Esc>:w<CR>
vnoremap <C-s> <Esc><Esc>:w<CR>

" Shift-Backspace to delete a word
inoremap <S-BS> <C-w>

let g:path_tool = g:path_vimrc . '/toolhouse'


" Setup to select general using tools
let s:file_rg = setup#SelectCliWithPattern(['rg', g:path_tool . '/rg'], 'ripgrep')
let s:file_uctags =  setup#SelectCliWithPattern(['ctags', g:path_tool . '/ctags'], 'universal\ ctags')

let s:file_ctags_opt = g:path_tool . '/opt.ctags'
let s:file_plantuml  = g:path_tool . '/plantuml.jar'

" Personal ctag script or options
let s:file_ctags_opt_3gpptxt = g:path_tool . '/3gpptxt.ctags'

let s:rooter_patterns = ['.root', '.git', '.project']

call setup#screenAndMouse()
call setup#paste()
call setup#utilFunction(s:file_plantuml)
call setup#netrw()
call setup#NERDTree()
call setup#minibufexpl()
call setup#TerminalMetaMode(0) "enable Alt for terminal mode
call setup#TerminalMacMode()
call setup#relativenumber()
call setup#wrap()
call setup#grep(s:file_uctags)
call setup#rooter(s:rooter_patterns)
call setup#Leaderf(s:file_uctags, s:file_rg, s:file_ctags_opt, s:file_ctags_opt_3gpptxt)
call setup#asyncrun()
call setup#gutentags(s:file_uctags, s:file_ctags_opt)
call setup#interestingwords()
call setup#ListToggle()
call setup#quickfixreflector()
call setup#rainbowcsv()
call setup#vimErlangTagJump(g:path_tool . '/levenshtein_distance.py')
call setup#vimttcn()
call setup#vim3gpptxt()
call setup#fugitive()
call setup#mkdp()
call setup#quickui(s:file_uctags)


" Global variables are best used for menu initialization.
call setup#quickuiMenu()
call setup#ToolBar()

" Initialize other runtimepath for personal/internal use,
" you can set to '' if no other rtp needed
let g:path_internal = '/proj/git_workspace/pdupc/ezqisui/vim-internal'
if isdirectory(g:path_internal)
    let &rtp .= ','.g:path_internal
    call internalsetup#tags(s:file_uctags, s:file_ctags_opt)
    call internalsetup#gerrit()
    call internalsetup#quickuiMenu()
    call internalsetup#ToolBar()
endif

" Function related keymapping
nnoremap <F5> :call RemoveTag()<CR>:GutentagsUpdate<CR>
