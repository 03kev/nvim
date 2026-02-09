local M = {}

local function list_config_files()
   local path = require("myconf.core.api").path
   local config_dir = path.config_dir()
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

local function edit_config_file(target_path)
   local path = require("myconf.core.api").path
   local config_dir = path.config_dir()
   local target = target_path ~= "" and target_path or "init.lua"
   if string.sub(target, 1, 1) ~= "/" then
      target = config_dir .. "/" .. target
   end
   vim.cmd("edit " .. vim.fn.fnameescape(target))
end

local function reload_config(flag)
   if flag == "w" then
      vim.cmd("write")
   end

   local modules_to_unload = {
      "configuration",
      "myconf.theme.theme",
      "myconf.ui.winbar",
   }

   for _, module in ipairs(modules_to_unload) do
      package.loaded[module] = nil
   end

   require("configuration")
   require("myconf.theme.theme")
   pcall(require, "myconf.ui.winbar")

   vim.notify(
      "Config ricaricata. Per plugin spec/core profondi usa :Lazy sync o riavvia Neovim.",
      vim.log.levels.INFO
   )
end

function M.setup()
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

   vim.api.nvim_create_user_command("ReloadConfig", function(opts)
      reload_config(opts.args)
   end, { nargs = "?" })

   vim.keymap.set("n", "<leader>ve", "<cmd>ConfigEdit<CR>", { desc = "Edit Neovim config file" })
   vim.keymap.set("n", "<leader>vv", "<cmd>ConfigVars<CR>", { desc = "Edit configuration values" })
   vim.keymap.set("n", "<leader>vr", "<cmd>ReloadConfig w<CR>", { desc = "Write and reload config" })
end

return M
