return {
   "windwp/nvim-autopairs",
   event = { "InsertEnter" },
   dependencies = {
      "hrsh7th/nvim-cmp",
   },
   config = function()
      -- import nvim-autopairs
      local autopairs = require("nvim-autopairs")

      -- configure autopairs
      autopairs.setup({
         check_ts = true, -- enable treesitter
         ts_config = {
            lua = { "string" }, -- don't add pairs in lua string treesitter nodes
            javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
            java = false, -- don't check treesitter on java
         },
      })

      -- import nvim-autopairs completion functionality
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      -- import nvim-cmp plugin (completions plugin)
      local cmp = require("cmp")

      -- make autopairs and completion work together
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      local autopairs_enabled = true
      local function toggle_autopairs()
         if autopairs_enabled then
            autopairs.disable()
            print("Auto-pairs disabled")
         else
            autopairs.enable()
            print("Auto-pairs enabled")
         end
         autopairs_enabled = not autopairs_enabled
      end

      -- map keybinding to toggle autopairs
      vim.keymap.set("n", "<leader>at", toggle_autopairs, { desc = "Toggle autopairs" })
   end,
}
