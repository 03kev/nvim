return {
   "folke/tokyonight.nvim",
   priority = 1000,
   lazy = false,

   config = function()
      local m = require("myconf.theme.mode").get()

      local cfg = {
         dark = {
            transparent = false,
            black1 = "#10100F",
            bg_high = "#1D1D19",
            white = "#EFECDB",
            grey1 = "#8D8C78",
            comment = "#996645",
            green = "#88BF39",
            orange1 = "#BF7F26",
            blue1 = "#124EED",
            dark1 = "#6D601B",
            test1 = "#00A0FF",
            test2 = "#9900FF",
            style = "night",
         },

         light = {
            transparent = false,
            black1 = "#f7f7f1",
            bg_high = "#e4e4d1",
            white = "#11110a",
            grey1 = "#8D8C78",
            comment = "#996645",
            green = "#88BF39",
            orange1 = "#BF7F26",
            blue1 = "#124EED",
            dark1 = "#6D601B",
            test1 = "#00A0FF",
            test2 = "#9900FF",
            style = "day", -- se vuoi più “nativo”: "day"
         },
      }

      local c = cfg[m] or cfg.dark

      require("tokyonight").setup({
         style = c.style,
         transparent = c.transparent,
         styles = {
            sidebars = "dark",
            floats = "dark",
         },
         on_colors = function(colors)
            colors.bg = c.black1
            colors.bg_dark = c.black1
            colors.bg_float = c.black1
            colors.bg_highlight = c.bg_high
            colors.bg_popup = c.black1
            colors.bg_search = c.blue1
            colors.bg_sidebar = c.black1
            colors.bg_statusline = c.black1
            colors.bg_visual = c.grey1
            colors.border = c.grey1
            colors.fg = c.white
            colors.fg_dark = c.white
            colors.fg_float = c.white
            colors.fg_gutter = c.grey1
            colors.fg_sidebar = c.white

            colors.comment = c.comment
            colors.blue1 = c.grey1 --types
            colors.magenta = c.grey1 -- keywords golang builtin like append, len etc.
            colors.cyan = c.grey1 -- go keywoards, c directives
            colors.blue5 = c.white -- punct
            colors.purple = c.grey1 -- c return keyword
            colors.yellow = c.white -- var names in function arguments
            colors.blue = c.white -- c func name

            colors.orange = c.green
            colors.green = c.green
            colors.green1 = c.white
            colors.magenta2 = c.orange1

            colors.blue2 = c.test2
            colors.blue6 = c.test1
            colors.blue7 = c.grey1
            colors.red = c.orange1
            colors.red1 = c.orange1
            colors.dark3 = c.dark1
            colors.dark5 = c.dark1

            colors.blue0 = c.test1
            --colors.orange = c.dark1 -- digits
            --colors.green2 = c.dark1
            --colors.teal = c.dark1
         end,
      })

      vim.cmd.colorscheme("tokyonight")
   end,
}

