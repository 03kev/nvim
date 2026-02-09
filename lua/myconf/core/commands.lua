local function shell_join(args)
   if not args or #args == 0 then
      return ""
   end
   local escaped = vim.tbl_map(vim.fn.shellescape, args)
   return table.concat(escaped, " ")
end

-- `Open` command
vim.api.nvim_create_user_command("Open", function(opts)
   local op_args = shell_join(opts.fargs)
   local script = "source ~/.zshrc; op"
   if op_args ~= "" then
      script = script .. " " .. op_args
   end
   vim.system({ "zsh", "-lc", script }):wait()
end, { nargs = "*", complete = "file" })

-- `Finder` to reveal the current file in Finder
vim.api.nvim_create_user_command("Finder", function(opts)
   local file_path = opts.args
   if file_path == "" then
      local bufname = vim.api.nvim_buf_get_name(0)
      if string.find(bufname, "NvimTree_") then
         file_path = vim.fn.getcwd()
      else
         file_path = vim.fn.expand("%:p")
      end
   end
   vim.system({ "open", "-R", file_path }):wait()
end, { nargs = "?", complete = "file" })

-- `Code` command to open files or directories in Visual Studio Code
vim.api.nvim_create_user_command("Code", function(opts)
   local cmd = vim.list_extend({ "code" }, opts.fargs)
   vim.system(cmd):wait()
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
   local result = vim.system({ "/opt/homebrew/bin/zoxide", "query", opts.args }, { text = true }):wait()
   local path = string.gsub(result.stdout or "", "\n$", "")
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
   local split_percentage = tonumber(opts.args) or nil -- Get the percentage from the argument or nil

   if split_percentage then
      -- Ensure the percentage is within a reasonable range
      if split_percentage < 1 then
         split_percentage = 1
      elseif split_percentage > 100 then
         split_percentage = 100
      end

      vim.cmd("split")
      local win_height = vim.api.nvim_win_get_height(0)
      local split_size = math.floor(win_height * (split_percentage / 100))
      vim.cmd("resize " .. split_size)
   else
      -- Default behavior: split equally
      vim.cmd("split")
   end

   vim.fn.termopen({ "zsh", "-i" }, { cwd = file_dir })
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
   vim.cmd("file " .. vim.fn.fnameescape(unique_name))
end, { nargs = "?" })

-- Keymap to execute the Terminal command with an optional percentage argument
vim.keymap.set("n", "<leader><S-t>", function()
   local count = vim.v.count
   local percentage = count > 0 and tostring(count) or ""
   vim.cmd("Terminal " .. percentage)
end, { desc = "Execute Terminal command" })

local function list_config_files()
   local config_dir = vim.fn.stdpath("config")
   local prefix = config_dir .. "/"
   local files = vim.fn.globpath(config_dir, "**/*", false, true)
   local result = {}

   for _, file in ipairs(files) do
      if vim.fn.isdirectory(file) == 0 then
         if string.sub(file, 1, #prefix) == prefix then
            table.insert(result, string.sub(file, #prefix + 1))
         else
            table.insert(result, file)
         end
      end
   end

   table.sort(result)
   return result
end

local function edit_config_file(path)
   local config_dir = vim.fn.stdpath("config")
   local target = path ~= "" and path or "init.lua"
   if string.sub(target, 1, 1) ~= "/" then
      target = config_dir .. "/" .. target
   end
   vim.cmd("edit " .. vim.fn.fnameescape(target))
end

vim.api.nvim_create_user_command("ConfigEdit", function(opts)
   if opts.args ~= "" then
      edit_config_file(opts.args)
      return
   end

   local files = list_config_files()
   if #files == 0 then
      vim.notify("No config files found", vim.log.levels.WARN)
      return
   end

   vim.ui.select(files, { prompt = "Edit config file:" }, function(choice)
      if choice then
         edit_config_file(choice)
      end
   end)
end, {
   nargs = "?",
   desc = "Open a Neovim config file",
   complete = function(arglead)
      local matches = {}
      for _, file in ipairs(list_config_files()) do
         if string.sub(file, 1, #arglead) == arglead then
            table.insert(matches, file)
         end
      end
      return matches
   end,
})

vim.api.nvim_create_user_command("ConfigVars", function()
   edit_config_file("lua/configuration.lua")
end, { desc = "Open lua/configuration.lua" })

vim.keymap.set("n", "<leader>ve", "<cmd>ConfigEdit<CR>", { desc = "Edit Neovim config file" })
vim.keymap.set("n", "<leader>vv", "<cmd>ConfigVars<CR>", { desc = "Edit configuration values" })
vim.keymap.set("n", "<leader>vr", "<cmd>ReloadConfig w<CR>", { desc = "Write and reload config" })

-- Function to reload specific parts of the Neovim configuration
local function reload_config(flag)
   if flag == "w" then
      vim.cmd("write")
   end

   -- lazy.nvim does not support re-running setup() by re-sourcing init.
   -- Keep reload focused on modules that are safe to refresh at runtime.
   local modules_to_unload = {
      "configuration",
      "myconf.theme.theme",
      "myconf.winbar",
   }

   for _, module in ipairs(modules_to_unload) do
      package.loaded[module] = nil
   end

   require("configuration")
   require("myconf.theme.theme")
   pcall(require, "myconf.winbar")

   vim.notify(
      "Config ricaricata (safe reload). Per plugin spec/core profondi usa :Lazy sync o riavvia Neovim.",
      vim.log.levels.INFO
   )
end
-- Create a command to call the reload function with an optional flag
vim.api.nvim_create_user_command("ReloadConfig", function(opts)
   reload_config(opts.args)
end, { nargs = "?" })

--

-- Function to export the current file to PDF using Pandoc
vim.api.nvim_create_user_command("PandocExport", function()
   vim.cmd("write")
   local in_f = vim.fn.expand("%:p")
   local out_f = vim.fn.expand("%:r") .. ".pdf"
   -- esegui e cattura output
   local result = vim.system({ "mypandoc", in_f, "--highlight-style=tango", "-o", out_f }, { text = true }):wait()
   if result.code ~= 0 then
      local err = result.stderr or ""
      if err == "" then
         err = result.stdout or ""
      end
      -- errore: stampalo in rosso
      vim.api.nvim_echo({
         { "❌ Errore durante l’esportazione:\n", "ErrorMsg" },
         { err, "ErrorMsg" },
      }, true, {})
   else
      -- successo
      vim.api.nvim_echo({
         { "✅ Esportato → ", "Directory" },
         { out_f, "Directory" },
      }, true, {})
   end
end, {})

vim.keymap.set("n", "<leader>xp", ":PandocExport<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("PandocOpen", function()
   local out_f = vim.fn.expand("%:r") .. ".pdf"
   if vim.fn.filereadable(out_f) == 0 then
      vim.api.nvim_echo({ { "❌ Non trovo " .. out_f, "ErrorMsg" } }, true, {})
      return
   end
   local opener
   if vim.fn.has("macunix") == 1 then
      opener = { "open", out_f }
   elseif vim.fn.has("win32") + vim.fn.has("win64") > 0 then
      opener = { "cmd.exe", "/c", "start", "", out_f }
   else
      opener = { "xdg-open", out_f }
   end
   vim.fn.jobstart(opener, { detach = true })
end, {})

vim.keymap.set("n", "<leader>xo", ":PandocOpen<CR>", { noremap = true, silent = true })
