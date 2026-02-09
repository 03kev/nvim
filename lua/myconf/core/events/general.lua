local M = {}

function M.setup()
   local core = require("myconf.core.api")
   local autocmd = core.autocmd

   autocmd.create("TextYankPost", {
      desc = "Highlight yanked text",
      group = autocmd.group("YankHighlight", { clear = true }),
      callback = function()
         vim.highlight.on_yank({ timeout = 250, higroup = "YankHighlight" })
      end,
   })

   local md_group = autocmd.group("MarkdownBrConceal", { clear = true })
   autocmd.create("FileType", {
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
