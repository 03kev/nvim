local M = {}
local icons = {
   error = "",
   success = "",
}

function M.setup()
   local shell = require("myconf.core.api").shell

   -- Function to export the current file to PDF using Pandoc
   vim.api.nvim_create_user_command("PandocExport", function()
      vim.cmd("write")
      local in_f = vim.fn.expand("%:p")
      local out_f = vim.fn.expand("%:r") .. ".pdf"
      local result = shell.system({ "mypandoc", "--highlight-style=tango", in_f, out_f }, { text = true })
      if result.code ~= 0 then
         local err = result.stderr or ""
         if err == "" then
            err = result.stdout or ""
         end
         vim.api.nvim_echo({
            { icons.error .. " Errore durante l’esportazione:\n", "ErrorMsg" },
            { err, "ErrorMsg" },
         }, true, {})
      else
         vim.api.nvim_echo({
            { icons.success .. " Esportato → ", "Directory" },
            { out_f, "Directory" },
         }, true, {})
      end
   end, {})

   vim.keymap.set("n", "<leader>xp", ":PandocExport<CR>", { noremap = true, silent = true })

   vim.api.nvim_create_user_command("PandocOpen", function()
      local out_f = vim.fn.expand("%:r") .. ".pdf"
      if vim.fn.filereadable(out_f) == 0 then
         vim.api.nvim_echo({ { icons.error .. " Non trovo " .. out_f, "ErrorMsg" } }, true, {})
         return
      end
      shell.open_external(out_f)
   end, {})

   vim.keymap.set("n", "<leader>xo", ":PandocOpen<CR>", { noremap = true, silent = true })
end

return M
