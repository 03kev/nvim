local M = {}

function M.setup()
   local modules = require("myconf.core.api").modules
   modules.setup_dir("myconf.core.events", "events", {
      preferred = { "general" },
   })
end

return M
