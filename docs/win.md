# 🍿 win

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.win.Config
---@field position? "float"|"bottom"|"top"|"left"|"right"
---@field buf? number
---@field file? string
---@field enter? boolean
---@field backdrop? number|false
---@field win? vim.api.keyset.win_config
---@field wo? vim.wo
---@field bo? vim.bo
---@field keys? table<string, false|string|fun(self: snacks.win)|snacks.win.Keys>
---@field on_buf? fun(self: snacks.win)
---@field on_win? fun(self: snacks.win)
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

## 📦 Module

```lua
---@class snacks.win.Keys: vim.api.keyset.keymap
---@field [1]? string
---@field [2]? string|fun(self: snacks.win): any
---@field mode? string|string[]
```

```lua
---@class snacks.win
---@field id number
---@field buf? number
---@field win? number
---@field opts snacks.win.Config
---@field augroup? number
---@field backdrop? snacks.win
Snacks.win = {}
```

### `Snacks.win()`

```lua
---@type fun(opts? :snacks.win.Config): snacks.win
Snacks.win()
```

### `Snacks.win.new()`

```lua
---@param opts? snacks.win.Config
---@return snacks.win
Snacks.win.new(opts)
```

### `win:buf_valid()`

```lua
win:buf_valid()
```

### `win:close()`

```lua
---@param opts? { buf: boolean }
win:close(opts)
```

### `win:hide()`

```lua
win:hide()
```

### `win:is_floating()`

```lua
win:is_floating()
```

### `win:show()`

```lua
win:show()
```

### `win:toggle()`

```lua
win:toggle()
```

### `win:valid()`

```lua
win:valid()
```

### `win:win_valid()`

```lua
win:win_valid()
```
