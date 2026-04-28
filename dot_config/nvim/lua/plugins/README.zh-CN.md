# Neovim 插件配置说明

[English](README.md) | [中文](README.zh-CN.md)

本目录是 chezmoi 管理的 Neovim 插件配置源目录，对应目标路径为 `~/.config/nvim/lua/plugins`。AstroNvim 和 lazy.nvim 会读取这里的 Lua 文件，用于覆盖默认行为、追加用户插件，并调整 LSP、UI、Treesitter、Mason、补全、格式化等编辑器行为。

## 目录映射

```text
chezmoi 源目录: ~/.local/share/chezmoi/dot_config/nvim/lua/plugins
目标路径:       ~/.config/nvim/lua/plugins
```

在源目录修改后，执行 `chezmoi apply ~/.config/nvim/lua/plugins` 将变更同步到实际 Neovim 配置目录。若先在实际配置目录中修改，则执行 `chezmoi add ~/.config/nvim/lua/plugins` 更新 chezmoi 备份。

## 加载规则

AstroNvim 会加载本目录下的 Lua 插件规格文件。文件首个可执行语句若为 `if true then return {} end`，表示该配置被显式禁用；删除这一行后才会影响运行时配置。`.bak` 文件用于保留历史配置，不应作为常规 Lua 插件规格加载。

## 文件说明

| 文件 | 状态 | 用途 |
| --- | --- | --- |
| `astrocore.lua` | 禁用 | AstroCore 示例入口，用于集中调整核心功能、诊断、文件类型、编辑器选项和快捷键。 |
| `astrolsp.lua` | 启用 | AstroLSP 配置入口，用于调整 LSP 功能、语言服务器、格式化和相关能力。 |
| `astroui.lua` | 启用 | AstroUI 配置入口，用于调整图标、颜色、状态栏、标签栏和整体 UI 表现。 |
| `blink.lua.bak` | 备份 | blink.cmp 补全配置备份，保留菜单显示、模糊排序、签名提示和文档弹窗设置。 |
| `mason.lua` | 禁用 | Mason 工具安装示例，用于维护语言服务器、formatter、debugger 和 `tree-sitter-cli`。 |
| `none-ls.lua` | 禁用 | none-ls 示例配置，用于接入外部 formatter、linter 和 diagnostic source。 |
| `treesitter.lua` | 禁用 | Treesitter 示例配置，用于控制高亮、缩进、自动安装和 parser 列表。 |
| `user.lua` | 启用 | 用户插件主入口，用于追加插件、覆盖默认插件、禁用不需要的插件和编写插件级自定义逻辑。 |

## 维护方式

优先在 `~/.config/nvim/lua/plugins` 中验证 Neovim 行为，再用 `chezmoi add ~/.config/nvim/lua/plugins` 备份确认后的配置。若直接编辑 chezmoi 源目录，应执行 `chezmoi apply ~/.config/nvim/lua/plugins` 让实际 Neovim 配置同步。启用或禁用插件配置文件时，只调整文件顶部的显式禁用行，避免复制或重命名文件制造多个配置入口。
