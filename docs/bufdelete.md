# 🍿 bufdelete

Delete buffers without disrupting window layout.

If the buffer you want to close has changes,
a prompt will be shown to save or discard.

<!-- docgen -->

## 📦 Module

### `Snacks.bufdelete()`

```lua
---@type fun(buf?: number)
Snacks.bufdelete()
```

### `Snacks.bufdelete.all()`

Delete all buffers

```lua
Snacks.bufdelete.all()
```

### `Snacks.bufdelete.delete()`

Delete a buffer:
- either the current buffer if `buf` is not provided
- or the buffer `buf` if it is a number
- or every buffer for which `buf` returns true if it is a function

```lua
---@param buf? number | fun(buf: number): boolean
Snacks.bufdelete.delete(buf)
```

### `Snacks.bufdelete.other()`

Delete all buffers except the current one

```lua
Snacks.bufdelete.other()
```
