![NIXOSBRAND](https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nixos.svg)

# My NixOS Configuration</h1>
---
# Desc.
Here is my personal structure of my nix setup :D, it is all thanks to a dear friend that introduced me this system and from that, I came to love using linux and the freedom that came with it(as you noticed most of the structure is lua, big reason why I love this structure!)

Not only that, but its easily reproducable and it comes with my neovim setup that I am getting very comfortable with! Some of the configurations are currently imperfect at the moment and quite broken-ish (home manager) But other than that it works just fine :D

---
# Structure

```
├── configuration.nix
├── flake.lock
├── flake.nix
├── hardware-configuration.nix
├── home.nix
├── mark.md
├── modules
│   ├── editors
│   │   └── neovim.nix
│   └── hardware
│       └── hardware.nix
├── neovimConfig
│   ├── config
│   │   ├── default.nix
│   │   └── lua
│   │       ├── chadrc.lua
│   │       ├── debug-chadrc.lua
│   │       ├── debug-path.lua
│   │       ├── nvim-0-init.lua
│   │       ├── nvim-cmp.lua
│   │       ├── nvim-lspconfig.lua
│   │       ├── nvim-setters.lua
│   │       └── plugins
│   │           ├── nvim-autopairs.lua
│   │           ├── nvim-chadui.lua
│   │           ├── nvim-compiler.lua
│   │           ├── nvim-gitsigns.lua
│   │           ├── nvim-indentBlankline.lua
│   │           ├── nvim-markview.lua
│   │           ├── nvim-neo-tree.lua
│   │           ├── nvim-obsidian.lua
│   │           ├── nvim-telescope.lua
│   │           ├── nvim-toggleterm.lua
│   │           └── nvim-treesitter.lua
│   ├── flake.lock
│   ├── flake.nix
│   ├── packages
│   │   └── myNeovim.nix
│   ├── plugins.nix
│   ├── readme.md
│   ├── runtimeDeps.nix
│   ├── test.md
│   └── test.py
├── README.md
└── users.nix
```
