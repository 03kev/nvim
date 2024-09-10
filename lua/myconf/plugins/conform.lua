-- Lightweight yet powerful formatter plugin for Neovim

return {
   "stevearc/conform.nvim",
   event = { "BufReadPre", "BufNewFile" },
   config = function()
      local conform = require("conform")

      conform.setup({
         formatters_by_ft = {
            javascript = {
               "prettier",
               -- options = {
               --   config = 'Users/kevinmuka/.config/nvim/.prettierrc.json'
               --   -- tabWidth = 4,
               --   -- semi = false,
               --   -- useTabs = false,
               --   -- singleQuote = true,
               --   -- trailingComma = "es5",
               -- },
            },
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
         },

         -- format_on_save = {
         --   lsp_fallback = false,
         --   async = false,
         --   timeout_ms = 1000,
         -- },
      })

      vim.keymap.set({ "n", "v" }, "<leader>fi", function()
         conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
         })
      end, { desc = "Format file or range (in visual mode)" })
   end,
}
