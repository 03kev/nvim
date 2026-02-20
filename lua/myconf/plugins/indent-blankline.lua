return {
   "lukas-reineke/indent-blankline.nvim",
   event = { "BufReadPre", "BufNewFile" },
   main = "ibl",
   opts = {
      indent = {
         char = "▏", -- left edge guide (VSCode-like)
         highlight = { "indentlinecolor" },
      },
      scope = { -- marked indent line for scope
         enabled = true,
         char = "▏",
         show_start = false, -- shows an underline on the first line of the scope
         show_end = false, -- shows an underline on the last line of the scope
         highlight = { "indentscopelinecolor" },
      },
   },

   config = function(_, opts)
      local ibl = require("ibl")
      ibl.setup(opts)

      local term_program = (vim.env.TERM_PROGRAM or ""):lower()
      local is_iterm = (term_program == "iterm.app") or (vim.env.ITERM_SESSION_ID ~= nil)
      local is_neovide = vim.g.neovide == true

      if is_iterm and not is_neovide then
         local hooks = require("ibl.hooks")
         local conf = require("ibl.config")
         local scp = require("ibl.scope")
         local indent = require("ibl.indent")
         local utils = require("ibl.utils")

         if vim.g.ibl_iterm_skip_line_hook then
            pcall(hooks.clear, vim.g.ibl_iterm_skip_line_hook)
            vim.g.ibl_iterm_skip_line_hook = nil
         end

         if vim.g.ibl_iterm_scope_active_hook then
            pcall(hooks.clear, vim.g.ibl_iterm_scope_active_hook)
         end

         if vim.g.ibl_iterm_cursor_mask_hook then
            pcall(hooks.clear, vim.g.ibl_iterm_cursor_mask_hook)
         end

         local function cursor_on_scope_column(bufnr)
            local cfg = conf.get_config(bufnr)
            local scope = scp.get(bufnr, cfg)
            if not scope or scope:start() < 0 then
               return false
            end

            local scope_start, _, scope_end = scope:range()
            local scope_start_line = vim.api.nvim_buf_get_lines(bufnr, scope_start, scope_start + 1, false)[1] or ""
            local scope_end_line = vim.api.nvim_buf_get_lines(bufnr, scope_end, scope_end + 1, false)[1] or ""

            local indent_opts = {
               tabstop = vim.api.nvim_get_option_value("tabstop", { buf = bufnr }),
               vartabstop = vim.api.nvim_get_option_value("vartabstop", { buf = bufnr }),
               shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = bufnr }),
               smart_indent_cap = cfg.indent.smart_indent_cap,
            }

            local ws_start = utils.get_whitespace(scope_start_line)
            local ws_end = utils.get_whitespace(scope_end_line)
            local ws_tbl_start = indent.get(ws_start, indent_opts, false, nil)
            local ws_tbl_end = indent.get(ws_end, indent_opts, false, nil)
            local ws_tbl = (#ws_tbl_end < #ws_tbl_start) and ws_tbl_end or ws_tbl_start

            local left_offset = utils.get_offset(bufnr)
            ws_tbl = utils.fix_horizontal_scroll(ws_tbl, left_offset)

            local scope_col = #ws_tbl
            local cursor_col = vim.fn.virtcol(".") - 1
            return cursor_col == scope_col
         end

         vim.g.ibl_iterm_scope_active_hook = hooks.register(hooks.type.SCOPE_ACTIVE, function(bufnr)
            if bufnr ~= vim.api.nvim_get_current_buf() then
               return true
            end

            local mode = vim.fn.mode(1)
            if not mode:match("^[iR]") then
               return true
            end

            return not cursor_on_scope_column(bufnr)
         end)

         vim.g.ibl_iterm_cursor_mask_hook = hooks.register(hooks.type.VIRTUAL_TEXT, function(_, bufnr, row, virt_text)
            if bufnr ~= vim.api.nvim_get_current_buf() then
               return virt_text
            end

            local mode = vim.fn.mode(1)
            if not mode:match("^[iR]") then
               return virt_text
            end

            local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
            if row ~= cursor_row then
               return virt_text
            end

            local on_scope_column = cursor_on_scope_column(bufnr)
            if on_scope_column then
               local scope_to_indent = function(group)
                  if type(group) ~= "string" then
                     return group
                  end

                  local idx = group:match("^@ibl%.scope%.char%.(%d+)$")
                  if idx then
                     return ("@ibl.indent.char.%s"):format(idx)
                  end

                  return group
               end

               for i, chunk in ipairs(virt_text) do
                  local hl = chunk[2]
                  if type(hl) == "string" then
                     virt_text[i][2] = scope_to_indent(hl)
                  elseif type(hl) == "table" then
                     for j, group in ipairs(hl) do
                        hl[j] = scope_to_indent(group)
                     end
                  end
               end
            end

            local cursor_col = vim.fn.virtcol(".") - 1
            local col = 0

            for i, chunk in ipairs(virt_text) do
               local ch = chunk[1] or " "
               local width = vim.fn.strdisplaywidth(ch)
               if width < 1 then
                  width = 1
               end

               if cursor_col >= col and cursor_col < (col + width) then
                  virt_text[i] = { " ", chunk[2] }
                  break
               end

               col = col + width
            end

            return virt_text
         end)

         local group = vim.api.nvim_create_augroup("ItermIblCursorRowRefresh", { clear = true })
         vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CursorMovedI", "CursorMoved", "BufEnter", "WinEnter" }, {
            group = group,
            callback = vim.schedule_wrap(function()
               if vim.api.nvim_buf_is_valid(0) then
                  ibl.debounced_refresh(0)
               end
            end),
         })
      end
   end,
}
