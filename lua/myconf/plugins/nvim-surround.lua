return {
   "kylechui/nvim-surround",
   version = "^3.0.0",
   event = "VeryLazy",
   config = function()
      require("nvim-surround").setup({
         surrounds = {
            ["c"] = {
               add = function()
                  local cmd = vim.fn.input("LaTeX command: ")
                  if cmd == nil or cmd == "" then
                     return nil
                  end
                  return { { "\\" .. cmd .. "{" }, { "}" } }
               end,

               find = function()
                  return require("nvim-surround.config").get_selection({
                     pattern = [[\\%a+%b{}]],
                  })
               end,

               delete = function()
                  return require("nvim-surround.config").get_selections({
                     char = "c",
                     pattern = [[^\\%a+()%b{}()$]],
                  })
               end,

               change = {
                  target = [[^\\(%a+)()%b{}()$]],
                  replacement = function()
                     local cmd = vim.fn.input("New LaTeX command: ")
                     if cmd == nil or cmd == "" then
                        return nil
                     end
                     return { { cmd }, { "" } }
                  end,
               },
            },
         },
      })
   end,
}
