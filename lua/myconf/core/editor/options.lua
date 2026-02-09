local M = {}

function M.setup()
   vim.cmd("let g:netrw_liststyle = 3")

   local conf = require("configuration")
   local opt = vim.opt
   local core = require("myconf.core.api")
   local autocmd = core.autocmd

   vim.o.laststatus = 3

   opt.relativenumber = true
   opt.number = true
   opt.numberwidth = 4

   -- tabs & indentation
   opt.tabstop = 4
   opt.shiftwidth = 4
   opt.expandtab = true
   opt.autoindent = true
   opt.wrap = false

   local function set_indentation(filetype, tabstop, shiftwidth, expandtab)
      autocmd.create("FileType", {
         pattern = filetype,
         callback = function()
            vim.bo.tabstop = tabstop
            vim.bo.shiftwidth = shiftwidth
            vim.bo.expandtab = expandtab
         end,
      })
   end

   set_indentation("lua", 3, 3, true)
   set_indentation("json", 2, 2, true)
   set_indentation("markdown", 4, 4, true)

   autocmd.create("FileType", {
      pattern = { "markdown", "text" },
      callback = function()
         vim.opt_local.wrap = true
         vim.opt_local.linebreak = true
         vim.wo.colorcolumn = "120"
      end,
   })

   -- search settings
   opt.ignorecase = true
   opt.smartcase = true

   opt.cursorline = true

   opt.termguicolors = true
   opt.background = "dark"
   opt.signcolumn = "yes"

   opt.backspace = "indent,eol,start"

   -- split windows
   opt.splitright = true
   opt.splitbelow = true

   opt.diffopt:append("vertical")

   opt.swapfile = false

   opt.fillchars = {
      vert = "│",
      horiz = "─",
      horizup = "┴",
      horizdown = "┬",
      vertleft = "┤",
      vertright = "├",
      verthoriz = "┼",
   }

   local function set_scrolloff_percentage(percentage)
      local win_height = vim.api.nvim_win_get_height(0)
      local scrolloff_value = math.floor(win_height * (percentage / 100))
      vim.opt.scrolloff = scrolloff_value
   end

   local scrolloff_percentage = tonumber((((conf.ui or {}).scrolloff or {}).percentage)) or 15
   set_scrolloff_percentage(scrolloff_percentage)

   autocmd.create("VimResized", {
      callback = function()
         set_scrolloff_percentage(scrolloff_percentage)
      end,
   })

   vim.api.nvim_set_keymap(
      "n",
      "<LeftMouse>",
      ":let temp=&scrolloff<CR>:let &scrolloff=0<CR><LeftMouse>:let &scrolloff=temp<CR>",
      { noremap = true, silent = true }
   )
end

return M
