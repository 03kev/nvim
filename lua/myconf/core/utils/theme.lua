local M = {}

function M.current_mode()
   local mode = (vim.env.NVIM_THEME or ""):lower()
   if mode == "light" or mode == "dark" then
      return mode
   end

   return require("configuration").ui.theme()
end

function M.job_env()
   local mode = M.current_mode()

   -- Shell children read ZSH_THEME_MODE, so keep it aligned with Neovim's current theme.
   return {
      NVIM_THEME = mode,
      ZSH_THEME_MODE = mode,
   }
end

function M.sync_process_env()
   local mode = M.current_mode()
   vim.env.NVIM_THEME = mode
   vim.env.ZSH_THEME_MODE = mode
   return mode
end

return M
