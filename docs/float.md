# float

<!-- docgen -->

## Config

```lua
---@class snacks.float.Config
---@field position? "float"|"bottom"|"top"|"left"|"right"
---@field buf? number
---@field file? string
---@field enter? boolean
---@field backdrop? number|false
---@field win? vim.api.keyset.win_config
---@field wo? vim.wo
---@field bo? vim.bo
---@field keys? table<string, false|string|fun(self: snacks.float)|snacks.float.Keys>
---@field on_buf? fun(self: snacks.float)
---@field on_win? fun(self: snacks.float)
{
  position = "float",
  win = {
    relative = "editor",
    style = "minimal",
  },
  wo = {
    winhighlight = "EndOfBuffer:NormalFloat,Normal:NormalFloat,NormalNC:NormalFloat",
  },
  bo = {},
  keys = {
    q = "close",
  },
}
```

## Module

```lua
---@class snacks.float.Keys: vim.api.keyset.keymap
---@field [1]? string
---@field [2]? string|fun(self: snacks.float): any
---@field mode? string|string[]
```

```lua
---@class snacks.float
---@field id number
---@field buf? number
---@field win? number
---@field opts snacks.float.Config
---@field augroup? number
---@field backdrop? snacks.float
---@overload fun(opts? :snacks.float.Config): snacks.float
Snacks.float = {}
```

### `Snacks.float.new()`

```lua
---@param opts? snacks.float.Config
---@return snacks.float
Snacks.float.new(opts)
```

### `float:buf_valid()`

```lua
float:buf_valid()
```

### `float:close()`

```lua
---@param opts? { buf: boolean }
float:close(opts)
```

### `float:hide()`

```lua
float:hide()
```

### `float:is_floating()`

```lua
float:is_floating()
```

### `float:show()`

```lua
float:show()
```

### `float:toggle()`

```lua
float:toggle()
```

### `float:valid()`

```lua
float:valid()
```

### `float:win_valid()`

```lua
float:win_valid()
```
