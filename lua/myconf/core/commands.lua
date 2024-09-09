-- Commands to handle mistyping
vim.cmd("command! Qa qa")
vim.cmd("command! Qaa qa!")
vim.cmd("command! Q q")
vim.cmd("command! Wq wq")
vim.cmd("command! W w")

-- `Open` command
vim.api.nvim_create_user_command("Open", function(opts)
   vim.fn.system("zsh -c 'source ~/.zshrc; op " .. opts.args .. "'")
end, { nargs = "*", complete = "file" })

-- `Finder` to reveal the current file in Finder
vim.api.nvim_create_user_command("Finder", function()
   local bufname = vim.api.nvim_buf_get_name(0)
   local filePath
   if string.find(bufname, "NvimTree_") then
      filePath = vim.fn.getcwd()
   else
      filePath = vim.fn.expand("%:p")
   end
   os.execute("open -R " .. vim.fn.shellescape(filePath))
end, {})

-- `Code` command to open files or directories in Visual Studio Code
vim.api.nvim_create_user_command("Code", function(opts)
   local escapedArgs = vim.fn.shellescape(opts.args)
   vim.fn.system("code " .. escapedArgs)
end, { nargs = "*", complete = "file" })

-- `Cwd` command to change the working directory to the directory of the current file
vim.api.nvim_create_user_command("Cwd", function()
   vim.cmd("cd %:p:h")
end, {})

-- `Path` command to show the path of the current file
vim.api.nvim_create_user_command("Path", function()
   local filePath = vim.fn.expand("%:p")
   print(filePath)
end, {})

vim.api.nvim_create_user_command("Cpath", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify('Copied "' .. path .. '" to the clipboard')
end, {}) 

-- `Z` command to use zoxide for changing directories
vim.api.nvim_create_user_command("Z", function(opts)
   local path = vim.fn.system("/opt/homebrew/bin/zoxide query " .. vim.fn.shellescape(opts.args))
   path = string.gsub(path, "\n$", "")
   if string.sub(path, 1, 7) == "zoxide:" then
      print(path)
   else
      if path ~= "" then
         vim.cmd("cd " .. vim.fn.fnameescape(path))
      else
         print("zoxide: No matching directory found")
      end
   end
end, { nargs = "*", desc = "Use zoxide to change directories" })

-- `Terminal` command to open a terminal in the directory of the current file using `zsh`
vim.api.nvim_create_user_command("Terminal", function(opts)
   local file_dir = vim.fn.expand("%:p:h")
   vim.cmd('split | terminal zsh -c "cd \\"' .. file_dir .. '\\" && zsh"')
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
   vim.cmd("file " .. unique_name)
end, {})

-- Function to reload specific parts of the Neovim configuration
function ReloadConfig(flag)
   if flag == "w" then
      vim.cmd("write")
   end
   local modules_to_reload = {
      "myconf.core",
      "myconf.lazy",
      "myconf.theme",
   }
   for _, module in ipairs(modules_to_reload) do
      package.loaded[module] = nil
   end
   for _, module in ipairs(modules_to_reload) do
      require(module)
   end
   print("Configuration reloaded!")
end
-- Create a command to call the ReloadConfig function with an optional flag
vim.api.nvim_command("command! -nargs=? ReloadConfig lua ReloadConfig(<f-args>)")
