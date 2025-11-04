-- bootstrap lazy.nvim, LazyVim and your plugins
vim.g.loaded_netrwPlugin = 1
require("config.lazy")
vim.opt.sessionoptions:append({ "winpos", "terminal", "folds", "blank" })
vim.opt.clipboard = "unnamedplus"
