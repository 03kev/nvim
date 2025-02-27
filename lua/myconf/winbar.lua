local conf = require("configuration")

if not conf.ui.enable_winbar then
   return
end

local M = {}

local status_navic_ok, navic = pcall(require, "nvim-navic")
if not status_navic_ok then
   return
end

local enable_winbar = require("configuration").enable_winbar
if enable_winbar == "barbecue" or enable_winbar == "none" then
   return
end

local function isempty(s)
   return s == nil or s == ""
end

local icons = require("icons").misc

M.filename = function()
   local filename = vim.fn.expand("%:t")
   local file_path = vim.fn.expand("%:p")
   local relative_path = vim.fn.expand("%:~:.")
   local parent_dir = string.match(file_path, ".*/([^/]+)/[^/]+$")
   local extension = ""
   local file_icon = ""
   local file_icon_color = ""
   local default_file_icon = ""
   local default_file_icon_color = ""

   if not isempty(filename) then
      extension = vim.fn.expand("%:e")

      local default = false

      if isempty(extension) then
         extension = ""
         default = true
      end

      file_icon, file_icon_color =
         require("nvim-web-devicons").get_icon_color(filename, extension, { default = default })

      extension = extension:gsub("[^%w]", "_") -- sanitize extension for hl_group

      local hl_group = "FileIconColor" .. extension

      vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
      if file_icon == nil then
         file_icon = ""
         file_icon_color = ""
      end

      -- Return filename if relative path doesn't exist
      if relative_path == nil or relative_path == "" then
         if isempty(file_icon) then
            return " " .. "%#WinbarColor#" .. filename .. "%*"
         else
            return " " .. "%#WinbarColor#" .. file_icon .. "%*" .. " " .. "%#WinbarColor#" .. filename .. "%*"
         end
      end
      -- Return relative path
      if isempty(file_icon) then
         return " " .. "%#WinbarColor#" .. relative_path .. "%*"
      else
         return " " .. "%#WinbarColor#" .. file_icon .. "%*" .. " " .. "%#WinbarColor#" .. relative_path .. "%*"
      end
   end
end

M.gps = function()
   local status_ok, navic_location = pcall(navic.get_location, {})
   if not status_ok then
      return
   end

   if not navic.is_available() then -- Returns boolean value indicating whether a output can be provided
      return
   end

   local retval = M.filename()

   if navic_location == "error" then
      return ""
   else
      if not isempty(navic_location) then
         local hl_group = "WinbarColor"
         return retval .. " " .. "%#" .. hl_group .. "#" .. icons.caretRight .. "%*" .. " " .. navic_location
      else
         return retval
      end
   end
end

vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost", "WinEnter", "WinNew" }, {
   callback = function()
      local winbar_filetype_exclude = {
         "help",
         "startify",
         "dashboard",
         "packer",
         "neogitstatus",
         "NvimTree",
         "Trouble",
         "alpha",
         "lir",
         "Outline",
         "spectre_panel",
         "TelescopePrompt",
         "DressingInput",
         "DressingSelect",
         "neotest-summary",
         "toggleterm",
      }

      local winbar_buftype_exclude = {
         "nofile",
         "terminal",
         "quickfix",
         "prompt",
      }

      if vim.api.nvim_win_get_config(0).relative ~= "" then
         return
      end

      if vim.bo.filetype == "dapui_watches" then
         local hl_group = "EcovimSecondary"
         vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.watch .. "Watches" .. "%*"
         return
      end

      if vim.bo.filetype == "dapui_stacks" then
         local hl_group = "EcovimSecondary"
         vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.git .. "Stacks" .. "%*"
         return
      end

      if vim.bo.filetype == "dapui_breakpoints" then
         local hl_group = "EcovimSecondary"
         vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.bigCircle .. "Breakpoints" .. "%*"
         return
      end

      if vim.bo.filetype == "dapui_scopes" then
         local hl_group = "EcovimSecondary"
         vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.telescope .. "Scopes" .. "%*"
         return
      end

      if vim.bo.filetype == "dap-repl" then
         local hl_group = "EcovimSecondary"
         vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.consoleDebug .. "Debug Console" .. "%*"
         return
      end

      if vim.bo.filetype == "dapui_console" then
         local hl_group = "EcovimSecondary"
         vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.console .. "Console" .. "%*"
         return
      end

      if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
         vim.opt_local.winbar = nil
         return
      end

      if vim.tbl_contains(winbar_buftype_exclude, vim.bo.buftype) then
         vim.opt_local.winbar = nil
         return
      end

      if vim.bo.filetype == "GitBlame" then
         local hl_group = "EcovimSecondary"
         vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. icons.git .. "Blame" .. "%*"
         return
      end

      local winbar_present, winbar = pcall(require, "myconf/winbar")
      if not winbar_present or type(winbar) == "boolean" then
         vim.opt_local.winbar = nil
         return
      end

      local value = winbar.gps()

      if value == nil then
         value = winbar.filename()
      end

      vim.opt_local.winbar = value
   end,
})

return M
