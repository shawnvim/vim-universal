# Language Server Protocol (LSP)

## Installation
LSP generally requires local installation and additional configuration.  
The following are the installation steps in simple terms:  
1. Prepare required project or executable bin file, e.g.:
    - [erlang_ls](https://github.com/erlang-ls/erlang_ls) requires `rebar3`
    - [vim-language-server](https://github.com/iamcco/vim-language-server) requires `cargo`  
2. Double check the [Path Environment Variables](https://linuxconfig.org/linux-path-environment-variable), or add it in Vim manually by `let $PATH .= ':/Path/To/Your/bin'`
3. Use `:LspInstallServer` to install the corresponding language server for current filetype
4. Restart Vim and open the previous file
5. Check the server status by `:LspStatus`  

## Reference
 - [vim-lsp](https://github.com/prabirshrestha/vim-lsp)
 - [vim-lsp-settings](https://github.com/mattn/vim-lsp-settings)
