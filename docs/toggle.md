# 🍿 toggle

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.toggle.Config
---@field icon? string|{ enabled: string, disabled: string }
---@field color? string|{ enabled: string, disabled: string }
{
  map = vim.keymap.set,
  which_key = true,
  notify = true,
  icon = {
    enabled = " ",
    disabled = " ",
  },
  color = {
    enabled = "green",
    disabled = "yellow",
  },
}
```

## 📦 Module

```lua
---@class snacks.toggle.Opts: snacks.toggle.Config
---@field name string
---@field get fun():boolean
---@field set fun(state:boolean)
```

```lua
---@class snacks.toggle
---@field opts snacks.toggle.Opts
Snacks.toggle = {}
```

### `Snacks.toggle()`

```lua
---@type fun(... :snacks.toggle.Opts): snacks.toggle
Snacks.toggle()
```

### `Snacks.toggle.diagnostics()`

```lua
---@param opts? snacks.toggle.Config
Snacks.toggle.diagnostics(opts)
```

### `Snacks.toggle.inlay_hints()`

```lua
---@param opts? snacks.toggle.Config
Snacks.toggle.inlay_hints(opts)
```

### `Snacks.toggle.line_number()`

```lua
---@param opts? snacks.toggle.Config
Snacks.toggle.line_number(opts)
```

### `Snacks.toggle.new()`

```lua
---@param ... snacks.toggle.Opts
---@return snacks.toggle
Snacks.toggle.new(...)
```

### `Snacks.toggle.option()`

```lua
---@param option string
---@param opts? snacks.toggle.Config | {on?: unknown, off?: unknown}
Snacks.toggle.option(option, opts)
```

### `Snacks.toggle.treesitter()`

```lua
---@param opts? snacks.toggle.Config
Snacks.toggle.treesitter(opts)
```

### `toggle:_wk()`

```lua
toggle:_wk(keys, mode)
```

### `toggle:get()`

```lua
toggle:get()
```

### `toggle:map()`

```lua
---@param keys string
---@param opts? vim.keymap.set.Opts | { mode: string|string[]}
toggle:map(keys, opts)
```

### `toggle:set()`

```lua
---@param state boolean
toggle:set(state)
```

### `toggle:toggle()`

```lua
toggle:toggle()
```
