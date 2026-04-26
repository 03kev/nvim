return {
   "lervag/vimtex",
   ft = { "tex" },
   init = function()
      local conf = require("configuration")
      local sioyek = (conf.external or {}).sioyek or vim.env.NVIM_SIOYEK_BIN
         or "/Applications/Sioyek.app/Contents/MacOS/sioyek"

      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_view_sioyek_exe = sioyek

      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
         aux_dir = "build",
         out_dir = "",
         callback = 1,
         continuous = 1,
         executable = "latexmk",
         options = {
            "-pdf",
            "-interaction=nonstopmode",
            "-synctex=1",
            "-file-line-error",
         },
      }

      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_matchparen_enabled = 1
      vim.g.vimtex_indent_enabled = 0
   end,

   config = function()
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      vim.api.nvim_create_autocmd("FileType", {
         pattern = "tex",
         callback = function(ev)
            local bopts = vim.tbl_extend("force", opts, { buffer = ev.buf })

            map("n", [[\ll]], "<plug>(vimtex-compile)", vim.tbl_extend("force", bopts, { desc = "LaTeX compile" }))
            map("n", [[\lk]], "<plug>(vimtex-stop)", vim.tbl_extend("force", bopts, { desc = "LaTeX stop compile" }))
            map(
               "n",
               [[\lv]],
               "<plug>(vimtex-view)",
               vim.tbl_extend("force", bopts, { desc = "LaTeX view PDF / forward search" })
            )
            map("n", [[\le]], "<plug>(vimtex-errors)", vim.tbl_extend("force", bopts, { desc = "LaTeX errors" }))
            map("n", [[\lq]], "<plug>(vimtex-log)", vim.tbl_extend("force", bopts, { desc = "LaTeX log" }))
            map("n", [[\lc]], "<plug>(vimtex-clean)", vim.tbl_extend("force", bopts, { desc = "LaTeX clean" }))
            map(
               "n",
               [[\lo]],
               "<plug>(vimtex-compile-output)",
               vim.tbl_extend("force", bopts, { desc = "LaTeX compile output" })
            )
            map(
               "n",
               [[\lt]],
               "<plug>(vimtex-toc-open)",
               vim.tbl_extend("force", bopts, { desc = "LaTeX table of contents" })
            )

            map(
               "x",
               "vxs",
               "<plug>(vimtex-env-surround-visual)",
               vim.tbl_extend("force", bopts, { desc = "LaTeX surround visual selection with environment" })
            )

            map(
               "n",
               "vxc",
               "<plug>(vimtex-cmd-create)",
               vim.tbl_extend("force", bopts, { desc = "LaTeX create command" })
            )
         end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
         pattern = "*.tex",
         callback = function()
            local win = vim.api.nvim_get_current_win()
            if vim.api.nvim_win_is_valid(win) then
               vim.g.vimtex_last_tex_win = win
            end
         end,
      })

      vim.api.nvim_create_autocmd("FileType", {
         pattern = "qf",
         callback = function(ev)
            vim.keymap.set("n", "q", function()
               local target = vim.g.vimtex_last_tex_win

               pcall(vim.cmd, "cclose")
               pcall(vim.cmd, "lclose")

               if target and vim.api.nvim_win_is_valid(target) then
                  vim.api.nvim_set_current_win(target)
               end
            end, {
               buffer = ev.buf,
               silent = true,
               desc = "Close error list and return to TeX window",
            })
         end,
      })
   end,
}
