# 🍿 notifier

![image](https://github.com/user-attachments/assets/b89eb279-08fb-40b2-9330-9a77014b9389)

## 🚀 Usage

```lua
-- to replace an existing notification just use the same id.
-- you can also use the return value of the notify function as id.
for i = 1, 10 do
  vim.defer_fn(function()
    vim.notify("Hello " .. i, "info", { id = "test" })
  end, i * 500)
end
```

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.notifier.Config
---@field keep? fun(notif: snacks.notifier.Notif): boolean # global keep function
{
  timeout = 3000, -- default timeout in ms
  width = { min = 40, max = 0.4 },
  height = { min = 1, max = 0.6 },
  -- editor margin to keep free. tabline and statusline are taken into account automatically
  margin = { top = 0, right = 1, bottom = 0 },
  padding = true, -- add 1 cell of left/right padding to the notification window
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

## 🎨 Styles

### `notification`

```lua
{
  border = "rounded",
  zindex = 100,
  ft = "markdown",
  wo = {
    winblend = 5,
    wrap = false,
  },
  bo = { filetype = "snacks_notif" },
}
```

## 📚 Types

Render styles:
* compact: use border for icon and title
* minimal: no border, only icon and message
* fancy: similar to the default nvim-notify style

```lua
---@alias snacks.notifier.style snacks.notifier.render|"compact"|"fancy"|"minimal"
```

### Notifications

Notification options

```lua
---@class snacks.notifier.Notif.opts
---@field id? number|string
---@field msg? string
---@field level? number|snacks.notifier.level
---@field title? string
---@field icon? string
---@field timeout? number
---@field ft? string
---@field keep? fun(notif: snacks.notifier.Notif): boolean
---@field style? snacks.notifier.style
```

Notification object

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
---@field added_hr number hrtime in ms
---@field layout? { width: number, height: number, top?: number }
```

### Rendering

```lua
---@alias snacks.notifier.render fun(buf: number, notif: snacks.notifier.Notif, ctx: snacks.notifier.ctx)
```

```lua
---@class snacks.notifier.hl
---@field title string
---@field icon string
---@field border string
---@field footer string
---@field msg string
```

```lua
---@class snacks.notifier.ctx
---@field opts snacks.win.Config
---@field notifier snacks.notifier
---@field hl snacks.notifier.hl
---@field ns number
```

## 📦 Module

### `Snacks.notifier()`

```lua
---@type fun(msg: string, level?: snacks.notifier.level|number, opts?: snacks.notifier.Notif.opts): number|string
Snacks.notifier()
```

### `Snacks.notifier.hide()`

```lua
---@param id? number|string
Snacks.notifier.hide(id)
```

### `Snacks.notifier.notify()`

```lua
---@param msg string
---@param level? snacks.notifier.level|number
---@param opts? snacks.notifier.Notif.opts
Snacks.notifier.notify(msg, level, opts)
```
