# 🍿 `snacks.nvim`

A collection of small QoL plugins for Neovim.

> [!CAUTION]
> Do **NOT** use this for now, it's still in development.

## Todo

- [ ] docs :)
- [x] float => win
- [x] win views
- [ ] cowboy
- [x] docgen
- [x] plugin
- [x] notify module
- [x] overload docgen
- [x] bigfile `BufReadPre`
- [x] bufdelete
- [x] statuscolumn
- [x] words `LspAttach`
- [x] quickfile `BufReadPost`
- [x] rename
- [x] terminal
- [x] float
- [x] lazygit
- [x] git
- [x] gitbrowse
- [x] toggle

### Maybe

- [ ] zen
- [ ] lsp
- [ ] root

## 📦 Snacks

| Module                                                                                     | Description                                                                                | Readme                                                                        |
| ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------- |
| [bigfile](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bigfile.lua)           | Deal with big files                                                                        | [README](https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md)      |
| [bufdelete](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/bufdelete.lua)       | Delete buffers without disrupting window layout                                            | [README](https://github.com/folke/snacks.nvim/blob/main/docs/bufdelete.md)    |
| [debug](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/debug.lua)               | Pretty inspect & backtraces for debugging                                                  | [README](https://github.com/folke/snacks.nvim/blob/main/docs/debug.md)        |
| [git](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/git.lua)                   | Useful tools for Git                                                                       | [README](https://github.com/folke/snacks.nvim/blob/main/docs/git.md)          |
| [gitbrowse](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/gitbrowse.lua)       | Open the repo of the active file in the browser (e.g., GitHub)                             | [README](https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md)    |
| [lazygit](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/lazygit.lua)           | Open LazyGit in a float, auto-configure colorscheme and integration with Neovim            | [README](https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md)      |
| [notify](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/notify.lua)             | Small wrapper around Neovim's `vim.notify`                                                 | [README](https://github.com/folke/snacks.nvim/blob/main/docs/notify.md)       |
| [quickfile](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/quickfile.lua)       | Render a file as quickly as possible before loading all plugins (progressive rendering)    | [README](https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md)    |
| [rename](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/rename.lua)             | LSP-integrated renaming with support for plugins like neo-tree, nvim-tree, oil, mini.files | [README](https://github.com/folke/snacks.nvim/blob/main/docs/rename.md)       |
| [statuscolumn](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/statuscolumn.lua) | Customizable statuscolumn                                                                  | [README](https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md) |
| [terminal](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/terminal.lua)         | Create and toggle floating/sp. Uses **float**.                                             | [README](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md)     |
| [toggle](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/toggle.lua)             | Toggle keymaps integrated with which-key icons / colors                                    | [README](https://github.com/folke/snacks.nvim/blob/main/docs/toggle.md)       |
| [win](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/win.lua)                   | Easily create and manage floating windows or splits                                        | [README](https://github.com/folke/snacks.nvim/blob/main/docs/win.md)          |
| [words](https://github.com/folke/snacks.nvim/blob/main/lua/snacks/words.lua)               | Auto-show LSP references, auto-show and quick navigation between them                      | [README](https://github.com/folke/snacks.nvim/blob/main/docs/words.md)        |
