local M = {}

function M.setup()
   local key = vim.keymap

   local function insert_file_path_into_cmd_line()
      local file_path = vim.fn.expand("%:p")
      vim.api.nvim_feedkeys(": " .. file_path, "n", true)
      for _ = 1, #file_path + 2 do
         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Left>", true, false, true), "n", true)
      end
   end

   key.set("n", "<leader>:", insert_file_path_into_cmd_line, { noremap = true, silent = false })
end

return M
