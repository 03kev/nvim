local M = {}

function M.setup()
   local core = require("myconf.core.api")
   local path = core.path
   local shell = core.shell

   -- `Open` command
   vim.api.nvim_create_user_command("Open", function(opts)
      local op_args = shell.join_args(opts.fargs)
      local script = "source ~/.zshrc; op"
      if op_args ~= "" then
         script = script .. " " .. op_args
      end
      shell.zsh_login(script)
   end, { nargs = "*", complete = "file" })

   -- `Finder` to reveal the current file in Finder
   vim.api.nvim_create_user_command("Finder", function(opts)
      local file_path = opts.args
      if file_path == "" then
         if path.is_nvimtree_buffer() then
            file_path = path.cwd()
         else
            file_path = path.current_file()
         end
      end
      shell.open_in_finder(file_path)
   end, { nargs = "?", complete = "file" })

   -- `Code` command to open files or directories in Visual Studio Code
   vim.api.nvim_create_user_command("Code", function(opts)
      local cmd = vim.list_extend({ "code" }, opts.fargs)
      shell.system(cmd)
   end, { nargs = "*", complete = "file" })

   -- `Cwd` command to change the working directory to the directory of the current file
   vim.api.nvim_create_user_command("Cwd", function()
      vim.cmd("cd %:p:h")
   end, {})

   -- `Path` command to show the path of the current file
   vim.api.nvim_create_user_command("Path", function()
      local file_path = vim.fn.expand("%:p")
      print(file_path)
   end, {})

   vim.api.nvim_create_user_command("Cpath", function()
      local file_path = vim.fn.expand("%:p")
      vim.fn.setreg("+", file_path)
      vim.notify('Copied "' .. file_path .. '" to the clipboard')
   end, {})

   -- `Z` command to use zoxide for changing directories
   vim.api.nvim_create_user_command("Z", function(opts)
      local result = shell.system({ "/opt/homebrew/bin/zoxide", "query", opts.args }, { text = true })
      local z_path = string.gsub(result.stdout or "", "\n$", "")
      if string.sub(z_path, 1, 7) == "zoxide:" then
         print(z_path)
      else
         if z_path ~= "" then
            vim.cmd("cd " .. vim.fn.fnameescape(z_path))
         else
            print("zoxide: No matching directory found")
         end
      end
   end, { nargs = "*", desc = "Use zoxide to change directories" })
end

return M
