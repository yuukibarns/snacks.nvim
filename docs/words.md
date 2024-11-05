# 🍿 words

<!-- docgen -->

## ⚙️ Config

```lua
---@class snacks.words.Config
{
  enabled = true,
  debounce = 200,
}
```

## 📚 Types

```lua
---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}} 1-0 indexed
```

## 📦 Module

```lua
---@class snacks.words
Snacks.words = {}
```

### `Snacks.words.get()`

```lua
---@return LspWord[] words, number? current
Snacks.words.get()
```

### `Snacks.words.is_enabled()`

```lua
---@param buf number?
Snacks.words.is_enabled(buf)
```

### `Snacks.words.jump()`

```lua
---@param count number
---@param cycle? boolean
Snacks.words.jump(count, cycle)
```

### `Snacks.words.setup()`

```lua
Snacks.words.setup()
```

### `Snacks.words.update()`

```lua
Snacks.words.update()
```
