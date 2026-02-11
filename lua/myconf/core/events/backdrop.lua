local M = {}

function M.setup()
   local conf = require("configuration")
   local backdrop_conf = (conf.ui and conf.ui.backdrop) or {}

   local enabled = backdrop_conf.enabled or false
   local blend = backdrop_conf.blend or 95
   local zindex_ref = backdrop_conf.zindex_ref or 50
   local filetypes = backdrop_conf.filetypes or { "TelescopePrompt", "lazygit", "fzf" }

   local function attach_backdrop(bufnr, zindex_ref_)
      local backdrop_name = "BackdropDim"

      local backdrop_bufnr = vim.api.nvim_create_buf(false, true)
      local winnr = vim.api.nvim_open_win(backdrop_bufnr, false, {
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

      vim.api.nvim_set_hl(0, backdrop_name, { bg = "#000000", default = true })
      vim.wo[winnr].winhighlight = "Normal:" .. backdrop_name
      vim.wo[winnr].winblend = blend
      vim.bo[backdrop_bufnr].buftype = "nofile"
      vim.bo[backdrop_bufnr].bufhidden = "wipe"
      vim.bo[backdrop_bufnr].swapfile = false

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
         if vim.api.nvim_buf_is_valid(backdrop_bufnr) then
            pcall(vim.api.nvim_buf_delete, backdrop_bufnr, { force = true })
         end
      end

      vim.api.nvim_create_autocmd({ "WinClosed", "BufWipeout", "BufLeave" }, {
         once = true,
         buffer = bufnr,
         callback = cleanup,
      })
   end

   if enabled then
      local group = vim.api.nvim_create_augroup("CoreBackdrop", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
         group = group,
         pattern = filetypes,
         callback = function(ctx)
            attach_backdrop(ctx.buf, zindex_ref)
         end,
      })
   end
end

return M
