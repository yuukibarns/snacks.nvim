# 🍿 `snacks.nvim`

A collection of small QoL plugins for Neovim.

> [!CAUTION]
> Do **NOT** use this for now, it's still in development.

## ✨ Features

| Module                                                                                     | Description                                                                                                                            | Readme                                                                        |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [bigfile](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bigfile.lua)           | Deal with big files (❗ **requires** `setup`)                                                                                          | [README](https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md)      |
| [bufdelete](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua)       | Delete buffers without disrupting window layout                                                                                        | [README](https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md)    |
| [debug](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/debug.lua)               | Pretty inspect & backtraces for debugging                                                                                              | [README](https://github.com/folke/snacks.nvim/blob/main/docs/debug.md)        |
| [git](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/git.lua)                   | Useful functions for Git                                                                                                               | [README](https://github.com/folke/snacks.nvim/blob/main/docs/git.md)          |
| [gitbrowse](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/gitbrowse.lua)       | Open the repo of the active file in the browser (e.g., GitHub)                                                                         | [README](https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md)    |
| [lazygit](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/lazygit.lua)           | Open LazyGit in a float, auto-configure colorscheme and integration with Neovim                                                        | [README](https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md)      |
| [notify](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/notify.lua)             | Utility functions to work with Neovim's `vim.notify`                                                                                   | [README](https://github.com/folke/snacks.nvim/blob/main/docs/notify.md)       |
| [notifier](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/notifier.lua)         | Better and prettier `vim.notify` (❗ **requires** `setup`)                                                                             | [README](https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md)     |
| [quickfile](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/quickfile.lua)       | When doing `nvim somefile.txt`, it will render the file as quickly as possible, before loading your plugins. (❗ **requires** `setup`) | [README](https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md)    |
| [rename](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/rename.lua)             | LSP-integrated renaming with support for plugins like neo-tree, nvim-tree, oil, mini.files                                             | [README](https://github.com/folke/snacks.nvim/blob/main/docs/rename.md)       |
| [statuscolumn](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/statuscolumn.lua) | Pretty statuscolumn (❗ **requires** `setup`)                                                                                          | [README](https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md) |
| [terminal](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/terminal.lua)         | Create and toggle floating/split terminals                                                                                             | [README](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md)     |
| [toggle](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/toggle.lua)             | Toggle keymaps integrated with which-key icons / colors                                                                                | [README](https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md)       |
| [win](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/win.lua)                   | Easily create and manage floating windows or splits                                                                                    | [README](https://github.com/folke/snacks.nvim/blob/main/docs/win.md)          |
| [words](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/words.lua)               | Auto-show LSP references and quickly navigate between them (❗ **requires** `setup`)                                                   | [README](https://github.com/folke/snacks.nvim/blob/main/docs/words.md)        |

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
> Setup creates some autocmds and does not load any plugins.
> Check the [code](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/init.lua) to see what it does.

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
}
```

For an in-depth setup of `snacks.nvim` with `lazy.nvim`, check the [example](https://github.com/folke/snacks.nvim?tab=readme-ov-file#-usage) below.

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

## 🚀 Usage

See the example below for how to configure `snacks.nvim`.

<!-- example:start -->

```lua
{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    { "<leader>un", function() Snacks.notifier:hide() end, desc = "Dismiss All Notifications" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
    { "<leader>cR", function() Snacks.rename() end, desc = "Rename File" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          win = { width = 0.6, height = 0.6 },
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }) :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
```

<!-- example:end -->
