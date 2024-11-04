# statuscolumn

<!-- docgen -->

## Config

```lua
---@class snacks.statuscolumn.Config
{
  left = { "mark", "sign" },
  right = { "fold", "git" },
  folds = {
    open = false, -- show open fold icons
    git_hl = false, -- use Git Signs hl for fold icons
  },
  git = {
    patterns = { "GitSign", "MiniDiffSign" },
  },
  refresh = 50, -- refresh at most every 50ms
}
```

## Module

```lua
---@alias snacks.statuscolumn.Sign.type "mark"|"sign"|"fold"|"git"
---@alias snacks.statuscolumn.Sign {name:string, text:string, texthl:string, priority:number, type:snacks.statuscolumn.Sign.type}
```

```lua
---@class snacks.statuscolumn
---@overload fun(): string
Snacks.statuscolumn = {}
```

### `Snacks.statuscolumn.buf_signs()`

Returns a list of regular and extmark signs sorted by priority (low to high)

```lua
---@return table<number, snacks.statuscolumn.Sign[]>
---@param buf number
Snacks.statuscolumn.buf_signs(buf)
```

### `Snacks.statuscolumn.get()`

```lua
Snacks.statuscolumn.get()
```

### `Snacks.statuscolumn.icon()`

```lua
---@param sign? snacks.statuscolumn.Sign
---@param len? number
Snacks.statuscolumn.icon(sign, len)
```

### `Snacks.statuscolumn.is_git_sign()`

```lua
---@param name string
Snacks.statuscolumn.is_git_sign(name)
```

### `Snacks.statuscolumn.line_signs()`

Returns a list of regular and extmark signs sorted by priority (high to low)

```lua
---@return snacks.statuscolumn.Sign[]
---@param win number
---@param buf number
---@param lnum number
Snacks.statuscolumn.line_signs(win, buf, lnum)
```

### `Snacks.statuscolumn.setup()`

```lua
Snacks.statuscolumn.setup()
```
