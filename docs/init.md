# 🍿 init

<!-- docgen -->

## 📦 Module

```lua
---@class Snacks
---@field bigfile snacks.bigfile
---@field bufdelete snacks.bufdelete
---@field quickfile snacks.quickfile
---@field statuscolumn snacks.statuscolumn
---@field words snacks.words
---@field rename snacks.rename
---@field win snacks.win
---@field terminal snacks.terminal
---@field lazygit snacks.lazygit
---@field git snacks.git
---@field gitbrowse snacks.gitbrowse
---@field notify snacks.notify
---@field debug snacks.debug
---@field toggle snacks.toggle
Snacks = {}
```

### `Snacks.config.get()`

```lua
---@generic T: table
---@param snack string
---@param defaults T
---@param ... T[]
---@return T
Snacks.config.get(snack, defaults, ...)
```

### `Snacks.config.view()`

Register a new window view config.

```lua
---@param name string
---@param defaults snacks.win.Config
Snacks.config.view(name, defaults)
```

### `Snacks.setup()`

```lua
---@param opts snacks.Opts?
Snacks.setup(opts)
```
