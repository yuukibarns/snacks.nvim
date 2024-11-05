# 🍿 statuscolumn

<!-- docgen -->

## ⚙️ Config

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
