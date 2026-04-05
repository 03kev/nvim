return {
   "stevearc/conform.nvim",
   event = { "BufReadPre", "BufNewFile" },
   config = function()
      local conform = require("conform")
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      local latexindent_config = vim.fn.expand("~/.config/latexindent/config.yaml")

      conform.setup({
         formatters_by_ft = {
            javascript = { "prettier" },
            typescript = { "prettier" },
            javascriptreact = { "prettier" },
            typescriptreact = { "prettier" },
            svelte = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            graphql = { "prettier" },
            liquid = { "prettier" },
            lua = { "stylua" },
            python = { "isort", "black" },
            java = { "clang-format" },
            tex = { "latexindent" },
         },

         formatters = {
            latexindent = {
               inherit = false,
               command = mason_bin .. "/latexindent",
               args = {
                  "-m",
                  "-l=" .. latexindent_config,
                  "-g=/dev/null",
                  "-",
               },
               stdin = true,
            },
         },
      })

      vim.keymap.set({ "n", "v" }, "<leader>fi", function()
         conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 10000,
         })
      end, { desc = "Format file or range (in visual mode)" })
   end,
}
