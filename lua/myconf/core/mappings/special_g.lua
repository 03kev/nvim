local M = {}

function M.setup()
   local function has_gap()
      local last_line = vim.fn.line("$")
      local screen_height = vim.fn.winheight(0)
      local cursor_line = vim.fn.line(".")
      return (last_line - cursor_line) < screen_height
   end

   local function update_keymap()
      local buftype = vim.bo.buftype
      if buftype == "" and not has_gap() then
         vim.api.nvim_buf_set_keymap(0, "n", "G", "G<c-e><c-e>", { noremap = true, silent = true, desc = "Last line" })
      else
         pcall(vim.api.nvim_buf_del_keymap, 0, "n", "G")
      end
   end

   vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "CursorMoved" }, {
      pattern = "*",
      callback = update_keymap,
   })

   vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
         vim.api.nvim_buf_set_keymap(0, "n", "G", "G", { noremap = true, silent = true, desc = "Last line" })
      end,
   })

   vim.api.nvim_create_autocmd("VimEnter", {
      pattern = "*",
      callback = update_keymap,
   })

   vim.api.nvim_create_autocmd("WinLeave", {
      pattern = "*",
      callback = function()
         pcall(vim.api.nvim_buf_del_keymap, 0, "n", "G")
      end,
   })
end

return M
