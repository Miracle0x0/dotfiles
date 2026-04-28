# Neovim Plugin Configuration

[English](README.md) | [中文](README.zh-CN.md)

This directory contains the chezmoi-managed source files for Neovim plugin configuration. It maps to `~/.config/nvim/lua/plugins` on the target system. AstroNvim and lazy.nvim read the Lua files in this directory to override default behavior, add user plugins, and tune LSP, UI, Treesitter, Mason, completion, formatting, and related editor behavior.

## Directory Mapping

```text
chezmoi source: ~/.local/share/chezmoi/dot_config/nvim/lua/plugins
target path:    ~/.config/nvim/lua/plugins
```

After editing this source directory, run `chezmoi apply ~/.config/nvim/lua/plugins` to sync changes into the active Neovim configuration. After editing the active configuration directly, run `chezmoi add ~/.config/nvim/lua/plugins` to update this chezmoi backup.

## Loading Rules

AstroNvim loads Lua plugin specification files from this directory. A file whose first executable line is `if true then return {} end` is explicitly disabled and will not affect the runtime configuration until that line is removed. Files ending in `.bak` are kept as historical backups and are not intended to be loaded as normal Lua plugin specs.

## Files

| File | Status | Purpose |
| --- | --- | --- |
| `astrocore.lua` | Disabled | AstroCore example entry point for core features, diagnostics, filetypes, editor options, and mappings. |
| `astrolsp.lua` | Enabled | AstroLSP configuration for LSP features, language servers, formatting, and related capabilities. |
| `astroui.lua` | Enabled | AstroUI configuration for icons, colors, statusline, tabline, and general UI behavior. |
| `blink.lua.bak` | Backup | Saved blink.cmp completion settings for menu display, fuzzy sorting, signature help, and documentation popups. |
| `mason.lua` | Disabled | Mason tool installer example for language servers, formatters, debuggers, and `tree-sitter-cli`. |
| `none-ls.lua` | Disabled | none-ls example for integrating external formatters, linters, and diagnostic sources. |
| `treesitter.lua` | Disabled | Treesitter example for highlighting, indentation, automatic parser installation, and parser lists. |
| `user.lua` | Enabled | Main user plugin entry point for adding plugins, overriding defaults, disabling unwanted plugins, and custom plugin logic. |

## Maintenance

Validate behavior in `~/.config/nvim/lua/plugins` before backing it up with `chezmoi add ~/.config/nvim/lua/plugins`. If editing this source directory directly, apply changes with `chezmoi apply ~/.config/nvim/lua/plugins`. To enable or disable a plugin configuration file, change only the explicit disable line at the top of the file instead of duplicating or renaming files.
