-- Configuration for the statusline (the bar at the bottom) plugin lualine.nvim

return {
   "nvim-lualine/lualine.nvim",
   --dependencies = { "nvim-tree/nvim-web-devicons" },
   config = function()
      local lualine = require("lualine")
      local lazy_status = require("lazy.status") -- to configure lazy pending updates count

      local m = require("configuration").ui.theme()
      local palettes = require("myconf.theme.palette")
      local p = palettes[m]

      local cfg = {
         dark = {
            black1 = p.black1,
            err = p.red1, --diagnostics error color
            hin = p.orange1, --diagnostics hint color
            white = p.white1,
            grey1 = p.grey2,
         },

         light = {
            black1 = p.black1, -- "#10100D"
            err = p.red1, --diagnostics error color
            hin = p.orange1, --diagnostics hint color
            white = p.white1,
            grey1 = p.grey1,
         },
      }

      local c = cfg[m] or cfg.dark
      local black1 = c.black1
      local err = c.err
      local hin = c.hin
      local white = c.white
      local grey1 = c.grey1

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

      local function current_mode() -- add VM mode if in visual multi mode
         local mode = require("lualine.utils.mode").get_mode()
         local vm_info = vim.fn.VMInfos()
         if vm_info and vm_info.status ~= nil then
            mode = "VM " .. mode
         end
         return mode
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
                  current_mode,
                  fmt = function(str)
                     if vim.bo.filetype == "NvimTree" then
                        return ""
                     end
                     return str
                  end,
                  gui = "bold",
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
