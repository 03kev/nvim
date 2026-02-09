local M = {}

function M.setup()
   local key = vim.keymap
   local conf = require("configuration")

   local ignored_filetypes = {
      "NvimTree",
   }
   local ignored_buftypes = {
      "nofile",
      "quickfix",
      "prompt",
      "terminal",
   }

   local function navigate_or_create_split(direction)
      local current_win = vim.api.nvim_get_current_win()
      local current_buf = vim.api.nvim_get_current_buf()
      local filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")
      local buftype = vim.api.nvim_buf_get_option(current_buf, "buftype")

      local is_ignored = vim.tbl_contains(ignored_filetypes, filetype) or vim.tbl_contains(ignored_buftypes, buftype)

      vim.cmd("wincmd " .. direction)
      if vim.api.nvim_get_current_win() == current_win and not is_ignored then
         local win_count = #vim.api.nvim_list_wins()
         local max_win_count = conf.plugins.splits.max_size

         if win_count < max_win_count then
            if direction == "h" then
               vim.cmd("leftabove vsplit")
            elseif direction == "j" then
               vim.cmd("belowright split")
            elseif direction == "k" then
               vim.cmd("aboveleft split")
            elseif direction == "l" then
               vim.cmd("rightbelow vsplit")
            end
            vim.cmd("wincmd " .. direction)
         else
            vim.api.nvim_echo({ { "Maximum number of splits (" .. tostring(max_win_count) .. ") reached", "WarningMsg" } }, false, {})
            vim.defer_fn(function()
               vim.cmd("echo ''")
            end, 1000)
         end
      end
   end

   key.set("n", "<C-h>", function()
      navigate_or_create_split("h")
   end, { noremap = true, silent = true, desc = "Move to left split or create one" })
   key.set("n", "<C-j>", function()
      navigate_or_create_split("j")
   end, { noremap = true, silent = true, desc = "Move to down split or create one" })
   key.set("n", "<C-k>", function()
      navigate_or_create_split("k")
   end, { noremap = true, silent = true, desc = "Move to up split or create one" })
   key.set("n", "<C-l>", function()
      navigate_or_create_split("l")
   end, { noremap = true, silent = true, desc = "Move to right split or create one" })
   key.set("n", "<C-c>", "<C-w>c")
end

return M
