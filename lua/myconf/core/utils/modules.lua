local M = {}

local path = require("myconf.core.utils.path")

local function discover(dir)
   local root = path.config_dir() .. "/lua/myconf/core/" .. dir
   local files = vim.fn.globpath(root, "*.lua", false, true)
   local names = {}

   for _, file in ipairs(files) do
      local name = vim.fn.fnamemodify(file, ":t:r")
      if name ~= "init" then
         table.insert(names, name)
      end
   end

   table.sort(names)
   return names
end

local function with_preferred_order(names, preferred)
   local ordered = {}
   local seen = {}

   for _, name in ipairs(preferred or {}) do
      if vim.tbl_contains(names, name) and not seen[name] then
         table.insert(ordered, name)
         seen[name] = true
      end
   end

   for _, name in ipairs(names) do
      if not seen[name] then
         table.insert(ordered, name)
      end
   end

   return ordered
end

function M.setup_dir(namespace, dir, opts)
   local cfg = opts or {}
   local names = discover(dir)
   local ordered = with_preferred_order(names, cfg.preferred)

   for _, name in ipairs(ordered) do
      local mod = require(namespace .. "." .. name)
      if type(mod) == "table" and type(mod.setup) == "function" then
         mod.setup(cfg.context)
      elseif type(mod) == "function" then
         mod(cfg.context)
      end
   end

   return ordered
end

return M
