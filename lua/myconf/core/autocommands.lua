vim.api.nvim_create_autocmd("TextYankPost", {
   desc = "Highlight yanked text",
   group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
   callback = function()
      vim.highlight.on_yank({ timeout = 250, higroup = "YankHighlight" })
   end,
})

-- restore terminal cursor when quitting neovim
-- vim.cmd([[
--     augroup RestoreCursorShapeOnExit
--         autocmd!
--         autocmd VimLeave * set guicursor=a:ver1
--     augroup END
-- ]])
