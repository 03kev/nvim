local conf = {}

conf.ui = {
   enable_smooth_scrolling = true,
   enable_winbar = true,
}

conf.plugins = {
   enable_copilot_chat = true,
   max_split_size = 10,
}

function conf.ui.theme()
   local m = (vim.env.NVIM_THEME or ""):lower()
   if m == "light" or m == "dark" then
      return m
   end

   return "dark"
end

return conf
