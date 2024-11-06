# 🍿 win

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.win.Config: vim.api.keyset.win_config
---@field style? string merges with config from `Snacks.config.views[view]`
---@field show? boolean Show the window immediately (default: true)
---@field minimal? boolean
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
  show = true,
  relative = "editor",
  position = "float",
  minimal = true,
  wo = {
    winhighlight = "Normal:NormalFloat,NormalNC:NormalFloat",
  },
  bo = {},
  keys = {
    q = "close",
  },
}
```

## 🎨 Styles

### `float`

```lua
{
  position = "float",
  backdrop = 60,
  height = 0.9,
  width = 0.9,
  zindex = 50,
}
```

### `minimal`

```lua
{
  wo = {
    cursorcolumn = false,
    cursorline = false,
    cursorlineopt = "both",
    fillchars = "eob: ,lastline:…",
    list = false,
    listchars = "extends:…,tab:  ",
    number = false,
    relativenumber = false,
    signcolumn = "no",
    spell = false,
    winbar = "",
    statuscolumn = "",
    winfixheight = true,
    winfixwidth = true,
    wrap = false,
  },
}
```

### `split`

```lua
{
  position = "bottom",
  height = 0.4,
  width = 0.4,
}
```

## 📚 Types

```lua
---@class snacks.win.Keys: vim.api.keyset.keymap
---@field [1]? string
---@field [2]? string|fun(self: snacks.win): any
---@field mode? string|string[]
```

## 📦 Module

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

### `Snacks.win.resolve()`

```lua
---@param ... snacks.win.Config|string
---@return snacks.win.Config
Snacks.win.resolve(...)
```

### `win:add_padding()`

```lua
win:add_padding()
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

### `win:size()`

```lua
---@return { height: number, width: number }
win:size()
```

### `win:toggle()`

```lua
win:toggle()
```

### `win:update()`

```lua
win:update()
```

### `win:valid()`

```lua
win:valid()
```

### `win:win_valid()`

```lua
win:win_valid()
```
