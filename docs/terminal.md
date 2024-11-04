# terminal

<!-- docgen -->

## Config

```lua
---@class snacks.terminal.Config
---@field cwd? string
---@field env? table<string, string>
---@field float? snacks.float.Config
---@field interactive? boolean
---@field override? fun(cmd?: string|string[], opts?: snacks.terminal.Config) Use this to use a different terminal implementation
{
  float = {
    bo = {
      filetype = "snacks_terminal",
    },
    wo = {},
    keys = {
      gf = function(self)
        local f = vim.fn.findfile(vim.fn.expand("<cfile>"))
        if f ~= "" then
          vim.cmd("close")
          vim.cmd("e " .. f)
        end
      end,
      term_normal = {
        "<esc>",
        function(self)
          self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
          if self.esc_timer:is_active() then
            self.esc_timer:stop()
            vim.cmd("stopinsert")
          else
            self.esc_timer:start(200, 0, function() end)
            return "<esc>"
          end
        end,
        mode = "t",
        expr = true,
        desc = "Double escape to normal mode",
      },
    },
  },
}
```

## Module

```lua
---@class snacks.terminal: snacks.float
---@field cmd? string | string[]
---@field opts snacks.terminal.Config
---@overload fun(cmd?: string|string[], opts?: snacks.terminal.Config): snacks.terminal
Snacks.terminal = {}
```

### `Snacks.terminal.open()`

```lua
---@param cmd? string | string[]
---@param opts? snacks.terminal.Config
Snacks.terminal.open(cmd, opts)
```

### `Snacks.terminal.toggle()`

```lua
---@param cmd? string | string[]
---@param opts? snacks.terminal.Config
Snacks.terminal.toggle(cmd, opts)
```
