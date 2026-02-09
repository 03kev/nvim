local M = {}

function M.setup()
   local key = vim.keymap

   -- from terminal to normal mode (not in lazygit)
   vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
         if vim.fn.expand("%:t") ~= "lazygit" and vim.bo.buftype == "terminal" and vim.bo.filetype ~= "lazygit" then
            vim.api.nvim_buf_set_keymap(
               0,
               "t",
               "<ESC>",
               "<C-\\><C-n>",
               { noremap = true, desc = "Terminal to normal mode" }
            )
         end
      end,
   })

   key.set(
      "n",
      "<leader>lt",
      "<cmd>!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>",
      { desc = "Lazy git in new tmux window" }
   )
end

return M
