# 🍿 notifier

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.notifier.Config
{
  timeout = 3000,
  width = { min = 40, max = 0.4 },
  height = { min = 1, max = 0.6 },
  sort = { "level", "added" }, -- sort by level and time
  icons = {
    error = " ",
    warn = " ",
    info = " ",
    debug = " ",
    trace = " ",
  },
  ---@type snacks.notifier.style
  style = "compact",
}
```

## 📦 Module

```lua
---@alias snacks.notifier.hl "title"|"icon"|"border"|"footer"|"msg"
```

```lua
---@class snacks.notifier.ctx
---@field opts snacks.win.Config
---@field notifier snacks.notifier
---@field hl table<snacks.notifier.hl, string>
---@field ns number
```

```lua
---@alias snacks.notifier.render fun(buf: number, notif: snacks.notifier.Notif, ctx: snacks.notifier.ctx)
---@alias snacks.notifier.style snacks.notifier.render|"compact"|"fancy"
```

```lua
---@class snacks.notifier.Notif.opts
---@field id? number|string
---@field msg? string
---@field level? number|snacks.notifier.level
---@field title? string
---@field icon? string
---@field timeout? number
---@field once? boolean
---@field ft? string
---@field keep? fun(notif: snacks.notifier.Notif): boolean
---@field style? snacks.notifier.style
```

```lua
---@class snacks.notifier.Notif: snacks.notifier.Notif.opts
---@field msg string
---@field id number|string
---@field win? snacks.win
---@field icon string
---@field level snacks.notifier.level
---@field timeout number
---@field dirty? boolean
---@field shown? number timestamp in ms
---@field added number timestamp in ms
---@field layout? { width: number, height: number, top?: number }
```

```lua
---@class snacks.notifier
---@field queue snacks.notifier.Notif[]
---@field opts snacks.notifier.Config
---@field dirty boolean
Snacks.notifier = {}
```

### `Snacks.notifier.new()`

```lua
---@param opts? snacks.notifier.Config
---@return snacks.notifier
Snacks.notifier.new(opts)
```

### `notifier:add()`

```lua
---@param opts snacks.notifier.Notif.opts
notifier:add(opts)
```

### `notifier:get_render()`

```lua
---@param style? snacks.notifier.style
---@return snacks.notifier.render
notifier:get_render(style)
```

### `notifier:hide()`

```lua
---@param id? number|string
notifier:hide(id)
```

### `notifier:init()`

```lua
notifier:init()
```

### `notifier:layout()`

```lua
notifier:layout()
```

### `notifier:notify()`

```lua
---@param msg string
---@param level? snacks.notifier.level|number
---@param opts? snacks.notifier.Notif.opts
notifier:notify(msg, level, opts)
```

### `notifier:render()`

```lua
---@param notif snacks.notifier.Notif
notifier:render(notif)
```

### `notifier:sort()`

```lua
notifier:sort()
```

### `notifier:start()`

```lua
notifier:start()
```

### `notifier:update()`

```lua
notifier:update()
```
