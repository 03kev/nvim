local M = {}

function M.setup()
   local modules = require("myconf.core.api").modules
   modules.setup_dir("myconf.core.cmd", "cmd", {
      preferred = { "system", "terminal", "config" },
   })
end

return M
