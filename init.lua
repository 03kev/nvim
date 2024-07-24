require("myconf.core") -- init.lua
require("myconf.lazy") -- plugins
require("myconf.theme")
require("myconf.plugins-keymaps")

-- set conceallevel=1 for markdown
vim.api.nvim_create_augroup("markdown_conceal", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "markdown_conceal",
  pattern = "markdown",
  command = "setlocal conceallevel=1",
})
