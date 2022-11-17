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
    if executable(g:erlang_ls) &&
                \ filereadable(g:erlang_ls_config) &&
                \ systemlist("cat " . fnameescape(g:erlang_ls_config) . " | grep " . fnameescape(getcwd())) != []
        " pip install erlang_ls
        au User lsp_setup call lsp#register_server({
                    \ 'name': g:erlang_ls,
                    \ 'cmd': {server_info->[g:erlang_ls]},
                    \ 'allowlist': ['erlang'],
                    \ })
    endif

    augroup lsp_install
        au!
        " call s:on_lsp_buffer_enabled only for languages that has the server registered.
        autocmd User lsp_buffer_enabled call lsp#on_lsp_buffer_enabled()
    augroup END

endfunction
