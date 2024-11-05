# 🍿 gitbrowse

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.gitbrowse.Config
{
  open = function(url)
    if vim.fn.has("nvim-0.10") == 0 then
      require("lazy.util").open(url, { system = true })
      return
    end
    vim.ui.open(url)
  end,
  patterns = {
    { "^(https?://.*)%.git$"              , "%1" },
    { "^git@(.+):(.+)%.git$"              , "https://%1/%2" },
    { "^git@(.+):(.+)$"                   , "https://%1/%2" },
    { "^git@(.+)/(.+)$"                   , "https://%1/%2" },
    { "^ssh://git@(.*)$"                  , "https://%1" },
    { "^ssh://([^:/]+)(:%d+)/(.*)$"       , "https://%1/%3" },
    { "^ssh://([^/]+)/(.*)$"              , "https://%1/%2" },
    { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
    { "^https://%w*@(.*)"                 , "https://%1" },
    { "^git@(.*)"                         , "https://%1" },
    { ":%d+"                              , "" },
    { "%.git$"                            , "" },
  },
}
```

## 📦 Module

```lua
---@class snacks.gitbrowse
Snacks.gitbrowse = {}
```

### `Snacks.gitbrowse()`

```lua
---@type fun(opts?: snacks.gitbrowse.Config)
Snacks.gitbrowse()
```

### `Snacks.gitbrowse.get_url()`

```lua
---@param remote string
---@param opts? snacks.gitbrowse.Config
Snacks.gitbrowse.get_url(remote, opts)
```

### `Snacks.gitbrowse.open()`

```lua
---@param opts? snacks.gitbrowse.Config
Snacks.gitbrowse.open(opts)
```
