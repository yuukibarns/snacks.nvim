# 🍿 `snacks.nvim`

A collection of small QoL plugins for Neovim.

> [!CAUTION]
> Do **NOT** use this for now, it's still in development.

## ⚡️ Requirements

- **Neovim** >= 0.9.4
- for proper icons support:
  - [mini.icons](https://github.com/echasnovski/mini.icons) _(optional)_
  - [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) _(optional)_
  - a [Nerd Font](https://www.nerdfonts.com/) **_(optional)_**

## 📦 Installation

Install the plugin with your package manager:

### [lazy.nvim](https://github.com/folke/lazy.nvim)

> [!important]
> A couple of plugins **require** `snacks.nvim` to be set-up early.
> Setup only sets up some autocmds and does not load any plugins.
> Check the [code](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/init.lua) to see exactly what is being set up.

> [!tip]
> If you don't need these plugins, you can disable them, or skip `setup` alltogether.

```lua
{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
```

## ⚙️ Configuration

Please refer to the readme of each plugin for their specific configuration.

<details><summary>Default Options</summary>

<!-- config:start -->

```lua
---@class snacks.Config
---@field bigfile? snacks.bigfile.Config | { enabled: boolean }
---@field gitbrowse? snacks.gitbrowse.Config
---@field lazygit? snacks.lazygit.Config
---@field notifier? snacks.notifier.Config | { enabled: boolean }
---@field quickfile? { enabled: boolean }
---@field statuscolumn? snacks.statuscolumn.Config  | { enabled: boolean }
---@field terminal? snacks.terminal.Config
---@field toggle? snacks.toggle.Config
---@field views? table<string, snacks.win.Config>
---@field win? snacks.win.Config
---@field words? snacks.words.Config
{
  views = {},
  bigfile = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}
```

<!-- config:end -->

</details>

## 📦 Snacks

| Module                                                                                     | Description                                                                                | Readme                                                                        |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| [bigfile](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bigfile.lua)           | Deal with big files                                                                        | [README](https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md)      |
| [bufdelete](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua)       | Delete buffers without disrupting window layout                                            | [README](https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md)    |
| [debug](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/debug.lua)               | Pretty inspect & backtraces for debugging                                                  | [README](https://github.com/folke/snacks.nvim/blob/main/docs/debug.md)        |
| [git](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/git.lua)                   | Useful tools for Git                                                                       | [README](https://github.com/folke/snacks.nvim/blob/main/docs/git.md)          |
| [gitbrowse](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/gitbrowse.lua)       | Open the repo of the active file in the browser (e.g., GitHub)                             | [README](https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md)    |
| [lazygit](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/lazygit.lua)           | Open LazyGit in a float, auto-configure colorscheme and integration with Neovim            | [README](https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md)      |
| [notify](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/notify.lua)             | Small wrapper around Neovim's `vim.notify`                                                 | [README](https://github.com/folke/snacks.nvim/blob/main/docs/notify.md)       |
| [notifier](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/notifier.lua)         | Better `vim.notify`                                                                        | [README](https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md)     |
| [quickfile](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/quickfile.lua)       | Render a file as quickly as possible before loading all plugins (progressive rendering)    | [README](https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md)    |
| [rename](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/rename.lua)             | LSP-integrated renaming with support for plugins like neo-tree, nvim-tree, oil, mini.files | [README](https://github.com/folke/snacks.nvim/blob/main/docs/rename.md)       |
| [statuscolumn](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/statuscolumn.lua) | Customizable statuscolumn                                                                  | [README](https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md) |
| [terminal](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/terminal.lua)         | Create and toggle floating/sp. Uses **float**.                                             | [README](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md)     |
| [toggle](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/toggle.lua)             | Toggle keymaps integrated with which-key icons / colors                                    | [README](https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md)       |
| [win](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/win.lua)                   | Easily create and manage floating windows or splits                                        | [README](https://github.com/folke/snacks.nvim/blob/main/docs/win.md)          |
| [words](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/words.lua)               | Auto-show LSP references, auto-show and quick navigation between them                      | [README](https://github.com/folke/snacks.nvim/blob/main/docs/words.md)        |
