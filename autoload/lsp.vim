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
    augroup lsp_install
        au!
        " call s:on_lsp_buffer_enabled only for languages that has the server registered.
        autocmd User lsp_buffer_enabled call lsp#on_lsp_buffer_enabled()
    augroup END
endfunction
