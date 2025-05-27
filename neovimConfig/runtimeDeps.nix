# runtimeDeps.nix
{ pkgs }:
{
  deps1 = with pkgs; [
    # LSPs
    lua-language-server           # Lua
    nodePackages.typescript-language-server  # TypeScript/JavaScript
    pyright                      # Python (or python-lsp-server)
    rust-analyzer               # Rust
    gopls                       # Go
    nil                         # Nix
    clang-tools                 # C/C++ (includes clangd)
    haskell-language-server     # Haskell
    metals                      # Scala
    jdt-language-server         # Java
    elmPackages.elm-language-server  # Elm
    nodePackages.bash-language-server  # Bash
    nodePackages.yaml-language-server  # YAML
    nodePackages.vscode-langservers-extracted  # HTML/CSS/JSON/ESLint
    terraform-ls                # Terraform
  ];
  deps2 = with pkgs; [ lazygit ];
}
