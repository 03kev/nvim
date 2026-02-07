return {
   "folke/tokyonight.nvim",
   priority = 1000,
   lazy = false,

   config = function()
      local m = require("configuration").ui.theme()
      local palettes = require("myconf.theme.palette")
      local p = palettes[m]

      local cfg = {
         dark = {
            transparent = false,
            black1 = p.black1,
            bg_high = p.line,
            white = p.white1,
            grey1 = p.grey2,
            comment = p.comment,
            green = p.green1,
            orange1 = p.orange1,
            blue1 = p.blue1,
            test1 = p.test1,
            test2 = p.test2,
            style = "night",
         },

         light = {
            transparent = false,
            black1 = p.black1,
            bg_high = p.line,
            white = p.white1,
            grey1 = p.grey1,
            comment = p.comment,
            green = p.green1,
            orange1 = p.orange1,
            blue1 = p.blue1,
            test1 = p.test1,
            test2 = p.test2,
            style = "day",
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

            colors.blue0 = c.test1
         end,
      })

      vim.cmd.colorscheme("tokyonight")
   end,
}
