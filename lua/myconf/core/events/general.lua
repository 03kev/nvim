local M = {}

function M.setup()
   local yank_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
   vim.api.nvim_create_autocmd("TextYankPost", {
      desc = "Highlight yanked text",
      group = yank_group,
      callback = function()
         vim.highlight.on_yank({ timeout = 250, higroup = "YankHighlight" })
      end,
   })

   local md_group = vim.api.nvim_create_augroup("MarkdownBrConceal", { clear = true })
   vim.api.nvim_create_autocmd("FileType", {
      group = md_group,
      pattern = "markdown",
      callback = function()
         vim.opt_local.conceallevel = 2
         vim.opt_local.concealcursor = ""
         vim.schedule(function()
            vim.cmd([[
               syntax match mdLineBreak /\s\zs\s$/ conceal cchar=↓
               highlight default link mdLineBreak SpecialChar
            ]])
         end)
      end,
   })
end

return M
