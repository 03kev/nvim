local conf = {}

conf.ui = {
   smooth_scrolling = { enabled = true },
   scrolloff = { percentage = 15 },

   winbar = { enabled = true },

   backdrop = {
      enabled = true,
      blend = 97,
      zindex_ref = 50,
      filetypes = { "TelescopePrompt", "lazygit", "fzf" },
   },
}

conf.plugins = {
   copilot_chat = { enabled = true },

   splits = { max_size = 10 },
}

function conf.ui.theme()
   local m = (vim.env.NVIM_THEME or ""):lower()
   if m == "light" or m == "dark" then
      return m
   end
   return "dark"
end

return conf
