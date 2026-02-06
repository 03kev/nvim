-- lua/myconf/winbar.lua

local conf = require("configuration")

if conf.ui and conf.ui.enable_winbar == false then
   return {}
end

local M = {}

local ok_navic, navic = pcall(require, "nvim-navic")
if not ok_navic then
   return M
end

local icons = require("icons").misc

local function isempty(s)
   return s == nil or s == ""
end

-- Cache devicons highlights by extension so we don't set them on every CursorHold
local icon_hl_cache = {}

M.filename = function()
   local filename = vim.fn.expand("%:t")
   local relative_path = vim.fn.expand("%:~:.")
   local extension = ""
   local file_icon = ""
   local file_icon_color = ""

   if isempty(filename) then
      return
   end

   extension = vim.fn.expand("%:e")
   local default = false
   if isempty(extension) then
      extension = ""
      default = true
   end

   file_icon = require("nvim-web-devicons").get_icon(filename, extension, { default = default })
   if file_icon == nil then
      file_icon = ""
   end

   if file_icon == nil then
      file_icon = ""
      file_icon_color = ""
   end

   -- sanitize extension for hl_group
   local ext_key = extension:gsub("[^%w]", "_")
   local hl_group = "WinbarFileIcon_" .. ext_key

   if not icon_hl_cache[hl_group] and not isempty(file_icon_color) then
      vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
      icon_hl_cache[hl_group] = true
   end

   local target = (relative_path and relative_path ~= "") and relative_path or filename

   if isempty(file_icon) then
    return " " .. "%#WinbarColor#" .. target .. "%*"
  else
    return " " .. "%#WinbarColor#" .. file_icon .. "%*" .. " " .. "%#WinbarColor#" .. target .. "%*"
  end
end

M.gps = function()
   if not navic.is_available() then
      return
   end

   local ok_loc, navic_location = pcall(navic.get_location, {})
   if not ok_loc then
      return
   end

   local retval = M.filename()
   if not retval then
      retval = ""
   end

   if navic_location == "error" then
      return ""
   end

   if not isempty(navic_location) then
      local hl_group = "WinbarColor"
      return retval .. " " .. "%#" .. hl_group .. "#" .. icons.caretRight .. "%*" .. " " .. navic_location
   end

   return retval
end

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

local function set_special(title, icon_key)
   local hl_group = "EcovimSecondary"
   vim.opt_local.winbar = " " .. "%#" .. hl_group .. "#" .. (icons[icon_key] or "") .. title .. "%*"
end

local function update_winbar()
   -- ignore floating windows
   if vim.api.nvim_win_get_config(0).relative ~= "" then
      return
   end

   -- special DAP UI cases
   if vim.bo.filetype == "dapui_watches" then
      set_special("Watches", "watch")
      return
   end

   if vim.bo.filetype == "dapui_stacks" then
      set_special("Stacks", "git")
      return
   end

   if vim.bo.filetype == "dapui_breakpoints" then
      set_special("Breakpoints", "bigCircle")
      return
   end

   if vim.bo.filetype == "dapui_scopes" then
      set_special("Scopes", "telescope")
      return
   end

   if vim.bo.filetype == "dap-repl" then
      set_special("Debug Console", "consoleDebug")
      return
   end

   if vim.bo.filetype == "dapui_console" then
      set_special("Console", "console")
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
      set_special("Blame", "git")
      return
   end

   local value = M.gps()
   if value == nil then
      value = M.filename()
   end

   vim.opt_local.winbar = value
end

local aug = vim.api.nvim_create_augroup("MyWinbar", { clear = true })

vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost", "WinEnter", "WinNew" }, {
   group = aug,
   callback = update_winbar,
})

return M

