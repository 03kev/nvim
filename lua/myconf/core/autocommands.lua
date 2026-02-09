vim.api.nvim_create_autocmd("TextYankPost", {
   desc = "Highlight yanked text",
   group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
   callback = function()
      vim.highlight.on_yank({ timeout = 250, higroup = "YankHighlight" })
   end,
})

-- special char after two spaces line break
local md_group = vim.api.nvim_create_augroup("MarkdownBrConceal", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
   group = md_group,
   pattern = "markdown",
   callback = function()
      vim.opt_local.conceallevel = 2
      vim.opt_local.concealcursor = ""
      vim.schedule(function()
         vim.cmd([[
            syntax match mdLineBreak /\s\zs\s$/ conceal cchar=↓
            highlight default link mdLineBreak SpecialChar
         ]])
      end)
   end,
})

-- restore terminal cursor when quitting neovim
-- vim.cmd([[
--     augroup RestoreCursorShapeOnExit
--         autocmd!
--         autocmd VimLeave * set guicursor=a:ver1
--     augroup END
-- ]])

--

-- Backdrop per finestre/prompt

local conf = require("configuration")
local backdrop_conf = (conf.ui and conf.ui.backdrop) or {}

local enabled = backdrop_conf.enabled or false
local blend = backdrop_conf.blend or 95
local zindex_ref = backdrop_conf.zindex_ref or 50
local filetypes = backdrop_conf.filetypes or { "TelescopePrompt", "lazygit", "fzf" }

local function attach_backdrop(bufnr, zindex_ref_)
   local backdropName = "BackdropDim"

   local backdropBufnr = vim.api.nvim_create_buf(false, true)
   local winnr = vim.api.nvim_open_win(backdropBufnr, false, {
      relative = "editor",
      border = "none",
      row = 0,
      col = 0,
      width = vim.o.columns,
      height = vim.o.lines,
      focusable = false,
      style = "minimal",
      zindex = (zindex_ref_ or zindex_ref) - 1,
   })

   vim.api.nvim_set_hl(0, backdropName, { bg = "#000000", default = true })
   vim.wo[winnr].winhighlight = "Normal:" .. backdropName
   vim.wo[winnr].winblend = blend
   vim.bo[backdropBufnr].buftype = "nofile"
   vim.bo[backdropBufnr].bufhidden = "wipe"
   vim.bo[backdropBufnr].swapfile = false

   local resize_au = vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
         if vim.api.nvim_win_is_valid(winnr) then
            vim.api.nvim_win_set_config(winnr, {
               relative = "editor",
               row = 0,
               col = 0,
               width = vim.o.columns,
               height = vim.o.lines,
            })
         end
      end,
   })

   local function cleanup()
      pcall(vim.api.nvim_del_autocmd, resize_au)
      if vim.api.nvim_win_is_valid(winnr) then
         pcall(vim.api.nvim_win_close, winnr, true)
      end
      if vim.api.nvim_buf_is_valid(backdropBufnr) then
         pcall(vim.api.nvim_buf_delete, backdropBufnr, { force = true })
      end
   end

   vim.api.nvim_create_autocmd({ "WinClosed", "BufWipeout", "BufLeave" }, {
      once = true,
      buffer = bufnr,
      callback = cleanup,
   })
end

if enabled then
   vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function(ctx)
         attach_backdrop(ctx.buf, zindex_ref)
      end,
   })
end
