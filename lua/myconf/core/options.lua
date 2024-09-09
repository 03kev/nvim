vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

local opts = { noremap = true, silent = true }

vim.o.laststatus = 3

opt.relativenumber = true
opt.number = false
opt.numberwidth = 4

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.wrap = false

local function set_indentation(filetype, tabstop, shiftwidth, expandtab, conceallevel)
   vim.api.nvim_create_autocmd("FileType", {
      pattern = filetype,
      callback = function()
         vim.bo.tabstop = tabstop
         vim.bo.shiftwidth = shiftwidth
         vim.bo.expandtab = expandtab
         if conceallevel then
            vim.wo.conceallevel = conceallevel
         end
      end,
   })
end
set_indentation("lua", 3, 3, true)
set_indentation("json", 2, 2, true)
set_indentation("markdown", 4, 4, true, 1)

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

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

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "YankHighlight" })
  end,
})

-- restore terminal cursor when quitting neovim
-- vim.cmd([[
--     augroup RestoreCursorShapeOnExit
--         autocmd!
--         autocmd VimLeave * set guicursor=a:ver1
--     augroup END
-- ]])


----------------------------- Custom tabline configuration -----------------------------
vim.o.tabline = "%!MyTabLine()"

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

--------------------------- set scrolloff to 20% of the window height ------------------------------

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
