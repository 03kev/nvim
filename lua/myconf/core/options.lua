vim.cmd("let g:netrw_liststyle = 3")

vim.cmd("let &stc='%=%{v:relnum?v:relnum:v:lnum} '") -- to right aline current relative number
-- disable the top command if you want to use absolute numbers and not relative

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.numberwidth = 4 -- set the width of the number column; default=4

-- opt.autochdir = true -- set the working directory to the parent folder of the buffer file

-- tabs & indentation
opt.tabstop = 4 -- 4 spaces for tabs (prettier default)
opt.shiftwidth = 4 -- 4 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "lua", "json" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

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

-- cursor settings moved in theme.lua for applying colorscheme
-- opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

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

------------------------------------ set scrolloff to 20% of the window height ------------------------------------

-- Function to set scrolloff based on a percentage of the window height
local function set_scrolloff_percentage(percentage)
  local win_height = vim.api.nvim_win_get_height(0)
  local scrolloff_value = math.floor(win_height * (percentage / 100))
  vim.opt.scrolloff = scrolloff_value
end

-- Set initial scrolloff value (e.g., 10% of the window height)
set_scrolloff_percentage(15)

-- Update scrolloff value when the window is resized
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    set_scrolloff_percentage(15)
  end,
})

-- Mapping to temporarily disable scrolloff when using the mouse
vim.api.nvim_set_keymap(
  "n",
  "<LeftMouse>",
  ":let temp=&scrolloff<CR>:let &scrolloff=0<CR><LeftMouse>:let &scrolloff=temp<CR>",
  { noremap = true, silent = true }
)

-------------------------------------------------------------------------------------------------------------------
