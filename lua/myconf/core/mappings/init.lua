local M = {}

function M.setup()
   vim.g.mapleader = " "
   local modules = require("myconf.core.api").modules
   modules.setup_dir("myconf.core.mappings", "mappings", {
      preferred = { "basic", "terminal", "commandline", "special_g", "disabled", "splits" },
   })
end

return M
