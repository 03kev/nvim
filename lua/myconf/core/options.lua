vim.cmd("let g:netrw_liststyle = 3")

vim.cmd("let &stc='%=%{v:relnum?v:relnum:v:lnum} '") -- to right aline current relative number
-- disable the top command if you want to use absolute numbers and not relative

local opt = vim.opt

local opts = { noremap = true, silent = true }

-- disable arrow keys and mouse
vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "", opts)
vim.api.nvim_set_keymap("n", "<S-ScrollWheelUp>", "", opts)
vim.api.nvim_set_keymap("n", "<C-ScrollWheelUp>", "", opts)
vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "", opts)
vim.api.nvim_set_keymap("n", "<S-ScrollWheelDown>", "", opts)
vim.api.nvim_set_keymap("n", "<C-ScrollWheelDown>", "", opts)
vim.api.nvim_set_keymap("n", "<ScrollWheelLeft>", "", opts)
vim.api.nvim_set_keymap("n", "<S-ScrollWheelLeft>", "", opts)
vim.api.nvim_set_keymap("n", "<C-ScrollWheelLeft>", "", opts)
vim.api.nvim_set_keymap("n", "<ScrollWheelRight>", "", opts)
vim.api.nvim_set_keymap("n", "<S-ScrollWheelRight>", "", opts)
vim.api.nvim_set_keymap("n", "<C-ScrollWheelRight>", "", opts)
vim.opt.mouse = ""
vim.api.nvim_set_keymap("n", "<Up>", "", opts)
vim.api.nvim_set_keymap("n", "<Down>", "", opts)
vim.api.nvim_set_keymap("n", "<Left>", "", opts)
vim.api.nvim_set_keymap("n", "<Right>", "", opts)
vim.api.nvim_set_keymap("v", "<Up>", "", opts)
vim.api.nvim_set_keymap("v", "<Down>", "", opts)
vim.api.nvim_set_keymap("v", "<Left>", "", opts)
vim.api.nvim_set_keymap("v", "<Right>", "", opts)
vim.api.nvim_set_keymap("i", "<Up>", "", opts)
vim.api.nvim_set_keymap("i", "<Down>", "", opts)
vim.api.nvim_set_keymap("i", "<Left>", "", opts)
vim.api.nvim_set_keymap("i", "<Right>", "", opts)

vim.o.laststatus = 3

-- _G.get_winbar = function()
--    local file_path = vim.fn.expand("%:p")
--    if file_path == "" or vim.bo.buftype ~= "" then
--       return ""
--    end
--
--    local file_window_count = 0
--    for _, win in ipairs(vim.api.nvim_list_wins()) do
--       local buf = vim.api.nvim_win_get_buf(win)
--       local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
--       if buftype == "" then
--          file_window_count = file_window_count + 1
--       end
--    end
--
--    if file_window_count <= 1 then
--       return ""
--    else
--       return file_path
--    end
-- end
--
-- vim.o.winbar = "%{%v:lua.get_winbar()%}"

--

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
   pattern = { "json" },
   callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = { "lua" },
   callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 3
      vim.bo.tabstop = 3
   end,
})

-- set conceallevel=1 for markdown
vim.api.nvim_create_augroup("markdown_conceal", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
   group = "markdown_conceal",
   pattern = "markdown",
   command = "setlocal conceallevel=1",
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
