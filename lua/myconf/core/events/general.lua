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

   local ns = vim.api.nvim_create_namespace("markdown_linebreak_marks")
   local group = vim.api.nvim_create_augroup("MarkdownLineBreakMarks", { clear = true })

   local function render_md_linebreak_marks(bufnr)
      if not vim.api.nvim_buf_is_valid(bufnr) then
         return
      end

      if vim.bo[bufnr].filetype ~= "markdown" then
         return
      end

      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      for i, line in ipairs(lines) do
         if line:match("%s%s$") then
            vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, #line, {
               virt_text = { { "↓", "SpecialChar" } },
               virt_text_pos = "eol",
               hl_mode = "combine",
            })
         end
      end
   end

   vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "InsertLeave" }, {
      group = group,
      pattern = "*.md",
      callback = function(args)
         render_md_linebreak_marks(args.buf)
      end,
   })

   vim.api.nvim_create_autocmd("BufWinEnter", {
      group = group,
      pattern = "*.md",
      callback = function(args)
         vim.schedule(function()
            render_md_linebreak_marks(args.buf)
         end)
      end,
   })
end

return M
