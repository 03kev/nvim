-- lua/myconf/theme/mode.lua
local M = {}

function M.get()
  local m = (vim.env.NVIM_THEME or ""):lower()
  if m == "light" or m == "dark" then return m end
  return "dark"
end

return M
