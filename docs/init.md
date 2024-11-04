# init

<!-- docgen -->

## Module

```lua
---@class Snacks
---@field bigfile snacks.bigfile
---@field bufdelete snacks.bufdelete
---@field quickfile snacks.quickfile
---@field statuscolumn snacks.statuscolumn
---@field words snacks.words
---@field rename snacks.rename
---@field float snacks.float
---@field terminal snacks.terminal
---@field lazygit snacks.lazygit
---@field git snacks.git
---@field gitbrowse snacks.gitbrowse
Snacks = {}
```

### `Snacks.config.get()`

```lua
---@generic T: table
---@param snack string
---@param defaults T
---@param opts? T
---@return T
Snacks.config.get(snack, defaults, opts)
```

### `Snacks.setup()`

```lua
---@param opts snacks.Opts?
Snacks.setup(opts)
```
