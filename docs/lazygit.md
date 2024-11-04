# 🍿 lazygit

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.lazygit.Config: snacks.terminal.Config
---@field args? string[]
---@field theme? snacks.lazygit.Theme
{
  configure = true,
  theme_path = vim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
  theme = {
    [241] = { fg = "Special" },
    activeBorderColor = { fg = "MatchParen", bold = true },
    cherryPickedCommitBgColor = { fg = "Identifier" },
    cherryPickedCommitFgColor = { fg = "Function" },
    defaultFgColor = { fg = "Normal" },
    inactiveBorderColor = { fg = "FloatBorder" },
    optionsTextColor = { fg = "Function" },
    searchingActiveBorderColor = { fg = "MatchParen", bold = true },
    selectedLineBgColor = { bg = "Visual" }, -- set to `default` to have no background colour
    unstagedChangesColor = { fg = "DiagnosticError" },
  },
}
```

## 📦 Module

```lua
---@alias snacks.lazygit.Color {fg?:string, bg?:string, bold?:boolean}
```

```lua
---@class snacks.lazygit.Theme: table<number, snacks.lazygit.Color>
---@field activeBorderColor snacks.lazygit.Color
---@field cherryPickedCommitBgColor snacks.lazygit.Color
---@field cherryPickedCommitFgColor snacks.lazygit.Color
---@field defaultFgColor snacks.lazygit.Color
---@field inactiveBorderColor snacks.lazygit.Color
---@field optionsTextColor snacks.lazygit.Color
---@field searchingActiveBorderColor snacks.lazygit.Color
---@field selectedLineBgColor snacks.lazygit.Color
---@field unstagedChangesColor snacks.lazygit.Color
```

```lua
---@class snacks.lazygit
---@overload fun(opts?: snacks.lazygit.Config): snacks.float
Snacks.lazygit = {}
```

### `Snacks.lazygit.log()`

```lua
---@param opts? snacks.lazygit.Config
Snacks.lazygit.log(opts)
```

### `Snacks.lazygit.log_file()`

```lua
---@param opts? snacks.lazygit.Config
Snacks.lazygit.log_file(opts)
```

### `Snacks.lazygit.open()`

Opens lazygit

```lua
---@param opts? snacks.lazygit.Config
Snacks.lazygit.open(opts)
```
