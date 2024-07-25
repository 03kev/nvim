vim.cmd("let g:netrw_liststyle = 3")

vim.cmd("let &stc='%=%{v:relnum?v:relnum:v:lnum} '") -- to right aline current relative number
-- disable the top command if you want to use absolute numbers and not relative

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.numberwidth = 4 -- set the width of the number column; default=4

-- opt.autochdir = true -- set the working directory to the parent folder of the buffer file

-- tabs & indentation

-- Set indentation for Lua files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

opt.tabstop = 4 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 4 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- opt.smartindent = true

opt.wrap = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
-- opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- restore terminal cursor when quitting neovim
-- vim.cmd([[
--     augroup RestoreCursorShapeOnExit
--         autocmd!
--         autocmd VimLeave * set guicursor=a:ver1
--     augroup END
-- ]])

opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- opt.formatoptions = {
--   ["1"] = true,
--   ["2"] = true,
--   q = true,
--   c = true,
--   r = true,
--   o = true,
--   n = true,
--   t = false,
--   j = true,
--   l = true,
--   v = true,
-- }
