local M = {}

function M.setup()
   local core = require("myconf.core.api")
   local path = core.path

   -- `Terminal` command to open a terminal in the directory of the current file using `zsh`
   pcall(vim.api.nvim_del_user_command, "Terminal")
   vim.api.nvim_create_user_command("Terminal", function(opts)
      local file_dir = path.current_dir()
      local split_percentage = tonumber(opts.args) or nil

      if split_percentage then
         if split_percentage < 1 then
            split_percentage = 1
         elseif split_percentage > 100 then
            split_percentage = 100
         end

         local win_height = vim.api.nvim_win_get_height(0)
         local split_size = math.floor(win_height * (split_percentage / 100))
         vim.cmd("rightbelow " .. split_size .. "new")
      else
         vim.cmd("rightbelow new")
      end

      vim.fn.termopen(vim.o.shell, { cwd = file_dir })
      vim.cmd("startinsert")

      local base_name = "zsh - " .. file_dir
      local unique_name = base_name
      local counter = 1
      local is_unique = false
      while not is_unique do
         is_unique = true
         for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            if vim.fn.bufname(bufnr) == unique_name then
               unique_name = base_name .. " (" .. counter .. ")"
               counter = counter + 1
               is_unique = false
               break
            end
         end
      end
      vim.api.nvim_buf_set_name(0, unique_name)
   end, { nargs = "?" })

   -- Keymap to execute the Terminal command with an optional percentage argument
   vim.keymap.set("n", "<leader><S-t>", function()
      local count = vim.v.count
      local percentage = count > 0 and tostring(count) or ""
      vim.cmd("Terminal " .. percentage)
   end, { desc = "Execute Terminal command" })
end

return M
