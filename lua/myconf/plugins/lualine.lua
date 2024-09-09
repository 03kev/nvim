-- Configuration for the statusline (the bar at the bottom) plugin lualine.nvim

return {
   "nvim-lualine/lualine.nvim",
   --dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      local lualine = require("lualine")
      local lazy_status = require("lazy.status") -- to configure lazy pending updates count

      local black1 = "#10100F" -- "#10100D"
      local err = "#BF6E6A" --diagnostics error color
      local hin = "#BF9C69" --diagnostics hint color
      local white = "#EFECDB"
      local grey1 = "#8D8C78"

      local my_lualine_theme = {
         normal = {
            a = { bg = grey1, fg = black1, gui = "bold" },
            b = { bg = black1, fg = white },
            c = { bg = black1, fg = white },
         },
         insert = {
            a = { bg = grey1, fg = black1, gui = "bold" },
            b = { bg = black1, fg = white },
            c = { bg = black1, fg = white },
         },
         visual = {
            a = { bg = grey1, fg = black1, gui = "bold" },
            b = { bg = black1, fg = white },
            c = { bg = black1, fg = white },
         },
         command = {
            a = { bg = grey1, fg = black1, gui = "bold" },
            b = { bg = black1, fg = white },
            c = { bg = black1, fg = white },
         },
         replace = {
            a = { bg = grey1, fg = black1, gui = "bold" },
            b = { bg = black1, fg = white },
            c = { bg = black1, fg = white },
         },
         inactive = {
            a = { bg = black1, fg = grey1, gui = "bold" },
            b = { bg = black1, fg = grey1 },
            c = { bg = black1, fg = grey1 },
         },
      }

      local function hide_in_nvimtree(str)
         if vim.bo.filetype == "NvimTree" then
            return ""
         end
         return str
      end

      lualine.setup({ -- configure lualine with modified theme
         options = {
            theme = my_lualine_theme,
            component_separators = { left = "|", right = "|" },
            section_separators = { left = "", right = "" },
         },
         sections = {
            lualine_a = {
               {
                  "mode",
                  fmt = function(str)
                     if vim.bo.filetype == "NvimTree" then
                        return "nvim"
                     end
                     return str
                  end,
               },
            },
            lualine_b = {
               {
                  "branch",
               },
            },
            lualine_c = {
               {
                  "filename",
                  fmt = hide_in_nvimtree,
               },
            },
            lualine_x = {
               {
                  --lazy_status.updates,
                  --cond = lazy_status.has_updates,
                  --color = { fg = grey1 },
               },
               {
                  --"filetype",
                  --icons_enabled = false,
                  --color = { fg = white },
               },
               {
                  "diagnostics",
                  diagnostics_color = {
                     error = { fg = err }, --bg = black1 ,
                     hint = { fg = hin }, --bg = black1 ,
                  },
               },
            },
            lualine_y = {
               {
                  "progress",
                  fmt = function(str)
                     return (vim.bo.filetype ~= "NvimTree") and string.lower(str) or ""
                  end,
               },
            },
            lualine_z = {
               {
                  "location",
                  fmt = hide_in_nvimtree,
               },
            },
         },

         inactive_sections = {
            lualine_c = {
               {
                  "filename",
                  fmt = function(str)
                     return (vim.bo.filetype == "NvimTree") and "nvim" or str
                  end,
               },
            },
            lualine_x = {
               {
                  "location",
                  fmt = hide_in_nvimtree,
               },
            },
         },
      })
   end,
}
