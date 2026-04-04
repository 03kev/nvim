return {
   "numToStr/Comment.nvim",
   event = { "BufReadPre", "BufNewFile" },
   dependencies = {
      {
         "JoosepAlviste/nvim-ts-context-commentstring",
         ft = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "html",
            "css",
            "scss",
            "svelte",
            "vue",
         },
      },
   },

   config = function()
      local ok_ts, ts_context_commentstring = pcall(
         require,
         "ts_context_commentstring.integrations.comment_nvim"
      )

      require("Comment").setup({
         pre_hook = ok_ts and ts_context_commentstring.create_pre_hook() or nil,

         toggler = {
            line = "gcc",
            block = "gbc",
         },
      })
   end,
}
