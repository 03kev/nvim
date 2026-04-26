local conf = {}

local function first_executable(candidates)
   for _, candidate in ipairs(candidates or {}) do
      if candidate and candidate ~= "" then
         if candidate:find("/", 1, true) then
            if vim.fn.executable(candidate) == 1 then
               return candidate
            end
         else
            local resolved = vim.fn.exepath(candidate)
            if resolved ~= "" then
               return resolved
            end
         end
      end
   end

   return nil
end

conf.ui = {
   smooth_scrolling = { enabled = true },
   scrolloff = { percentage = 15 },

   winbar = { enabled = true },

   backdrop = {
      enabled = true,
      blend = 97,
      zindex_ref = 50,
      filetypes = { "TelescopePrompt", "lazygit", "fzf", "codexfloat" },
   },
}

conf.plugins = {
   copilot_chat = { enabled = true },

   splits = { max_size = 10 },
}

conf.external = {
   zoxide = first_executable({
      vim.env.NVIM_ZOXIDE_BIN,
      "zoxide",
      "/opt/homebrew/bin/zoxide",
   }),
   sioyek = first_executable({
      vim.env.NVIM_SIOYEK_BIN,
      "sioyek",
      "/Applications/Sioyek.app/Contents/MacOS/sioyek",
   }),
}

function conf.ui.theme()
   local m = (vim.env.NVIM_THEME or ""):lower()
   if m == "light" or m == "dark" then
      return m
   end
   return "dark"
end

return conf
