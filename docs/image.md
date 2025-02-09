# 🍿 image

<!-- docgen -->

## 📦 Setup

```lua
-- lazy.nvim
{
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    image = {
      -- your image configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  }
}
```

## ⚙️ Config

```lua
---@class snacks.image.Config
---@field file? string
{}
```

## 📚 Types

```lua
---@alias snacks.image.Dim {col: number, row: number, width: number, height: number}
```

## 📦 Module

```lua
---@class snacks.Image
---@field id number
---@field buf number
---@field wins table<number, snacks.image.Dim>
---@field opts snacks.image.Config
---@field file string
---@field _convert uv.uv_process_t?
Snacks.image = {}
```

### `Snacks.image.new()`

```lua
---@param buf number
---@param opts? snacks.image.Config
Snacks.image.new(buf, opts)
```

### `Snacks.image.supports()`

```lua
---@param file string
Snacks.image.supports(file)
```

### `image:convert()`

```lua
image:convert()
```

### `image:create()`

```lua
image:create()
```

### `image:dim()`

```lua
---@param win number
---@return snacks.image.Dim
image:dim(win)
```

### `image:hide()`

```lua
---@param win? number
image:hide(win)
```

### `image:ready()`

```lua
image:ready()
```

### `image:render()`

```lua
---@param win number
image:render(win)
```

### `image:request()`

```lua
---@param opts table<string, string|number>|{data?: string}
image:request(opts)
```

### `image:update()`

```lua
image:update()
```
