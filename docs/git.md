# 🍿 git

<!-- docgen -->

## 📦 Module

```lua
---@class snacks.git
Snacks.git = {}
```

### `Snacks.git.blame_line()`

Show git log for the current line.

```lua
---@param opts? snacks.terminal.Config | {count?: number}
Snacks.git.blame_line(opts)
```

### `Snacks.git.get_root()`

Gets the git root for a buffer or path.
Defaults to the current buffer.

```lua
---@param path? number|string buffer or path
Snacks.git.get_root(path)
```
