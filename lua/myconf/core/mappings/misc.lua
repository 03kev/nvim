local M = {}

function M.setup()
   local key = vim.keymap

   -- command-line helpers
   local function insert_file_path_into_cmd_line()
      local file_path = vim.fn.expand("%:p")
      vim.api.nvim_feedkeys(": " .. file_path, "n", true)
      for _ = 1, #file_path + 2 do
         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", true)
      end
   end

   key.set("n", "<leader>:", insert_file_path_into_cmd_line, { noremap = true, silent = false })

   -- terminal behavior
   local term_group = vim.api.nvim_create_augroup("CoreMappingsTerminal", { clear = true })
   vim.api.nvim_create_autocmd("TermOpen", {
      group = term_group,
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

   -- git/tmux shortcuts
   key.set(
      "n",
      "<leader>lt",
      "<cmd>!tmux new-window -c " .. vim.fn.getcwd() .. " -- lazygit <CR><CR>",
      { desc = "Lazy git in new tmux window" }
   )
end

return M
