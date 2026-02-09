require("myconf.core") -- init.lua
require("myconf.lazy") -- plugins
require("myconf.theme.theme")
require("myconf.ui.winbar")

-- Change configuration variables 

-- local config_file_path = "/Users/kevinmuka/.config/nvim/lua/configuration.lua"
--
-- local conf = dofile(config_file_path)
--
-- function set_conf_values()
--   local keys = {}
--   for key, _ in pairs(conf) do
--     table.insert(keys, key)
--   end
--
--   vim.ui.select(keys, { prompt = "Select a variable to change:" }, function(selected_key)
--     if selected_key then
--       local current_value = tostring(conf[selected_key])
--       vim.cmd(string.format("let new_value = input('Enter new value for %s: ', '%s')", selected_key, current_value))
--       local new_value = vim.api.nvim_get_var("new_value")
--       if new_value == "true" then
--         conf[selected_key] = true
--       elseif new_value == "false" then
--         conf[selected_key] = false
--       elseif tonumber(new_value) then
--         conf[selected_key] = tonumber(new_value)
--       else
--         conf[selected_key] = new_value
--       end
--
--       -- Write the updated conf table back to the file
--       local file = io.open(config_file_path, "w")
--       file:write("local conf = {}\n\n")
--       for key, value in pairs(conf) do
--         if type(value) == "string" then
--           file:write(string.format('conf.%s = "%s"\n', key, value))
--         else
--           file:write(string.format("conf.%s = %s\n", key, tostring(value)))
--         end
--       end
--       file:write("\nreturn conf\n")
--       file:close()
--     end
--   end)
-- end
--
-- -- Create the SetConf command
-- vim.cmd("command! SetConf lua set_conf_values()")
--
-- vim.keymap.set("n", "<leader>st", ":SetConf<CR>", { noremap = true, silent = true, desc = "Set configuration variables" })
