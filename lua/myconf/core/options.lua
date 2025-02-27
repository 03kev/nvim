vim.cmd("let g:netrw_liststyle = 3")

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

opt.relativenumber = true
opt.number = false
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

opt.diffopt:append("vertical")

-- restore terminal cursor when quitting neovim
-- vim.cmd([[
--     augroup RestoreCursorShapeOnExit
--         autocmd!
--         autocmd VimLeave * set guicursor=a:ver1
--     augroup END
-- ]])


-- Custom tabline configuration
vim.o.tabline = '%!MyTabLine()'

-- Define the MyTabLine function in Vimscript
vim.cmd([[
function! MyTabLine()
  " Loop over pages and define labels for them, then get label for each tab
  " page use MyTabLabel(). See :h 'statusline' for formatting, e.g., T, %, #, etc.
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      " use hl-TabLineSel for current tabpage
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number, for mouse clicks
    let s .= '%' . (i + 1) . 'T'

    " call MyTabLabel() to make the label
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " After last tab fill with hl-TabLineFill and reset tab page nr with %T
  let s .= '%#TabLineFill#%T'

  " Right-align (%=) hl-TabLine (%#TabLine#) style and use %999X for a close
  " current tab mark, with 'X' as the character
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif

  return s
endfunction

function! MyTabLabel(n)
  " Give tabpage number n create a string to display on tabline
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  " Get the file name only
  let bufname = bufname(buflist[winnr - 1])
  if empty(bufname)
    return '[No Name]'
  else
    return fnamemodify(bufname, ':t')
  endif
endfunction
]])

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
