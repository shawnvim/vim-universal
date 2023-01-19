"-----------------------------------------------------------------------------"
" https://github.com/prabirshrestha/vim-lsp
" ./pack/original/start/vim-lsp/
"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
" https://github.com/mattn/vim-lsp-settings
" ./pack/original/start/vim-lsp-settings/
"-----------------------------------------------------------------------------"

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! lsp#on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    " if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <C-d> <plug>(lsp-definition)
    nmap <buffer> <C-S-d> :LspDocumentDiagnostics<CR>
endfunction

"-----------------------------------------------------------------------------"
"-----------------------------------------------------------------------------"
function! lsp#install() abort
    let g:lsp_use_native_client = 1
    let g:lsp_use_event_queue = 1
    let g:lsp_document_highlight_enabled = 0
    
    let g:lsp_settings_root_markers = g:rooter_patterns
    let g:file_erlang_ls_config = util#GetErlangLsConfig()
    let g:file_erlang_ls = g:lsp_settings_servers_dir . '/erlang-ls/_build/default/bin/erlang_ls'
    if filereadable(g:file_erlang_ls)
        if executable(g:file_erlang_ls)
            let g:lsp_settings = {
                        \ 'erlang-ls': {'cmd': g:lsp_settings_servers_dir . '/erlang-ls/_build/default/bin/erlang_ls'}
                        \}
        else
            echom 'erlang_ls existed but not executable, please check your PATH env for installation.'
        endif
    endif
    augroup lsp_install
        au!
        " call s:on_lsp_buffer_enabled only for languages that has the server registered.
        autocmd User lsp_buffer_enabled call lsp#on_lsp_buffer_enabled()
    augroup END
endfunction
