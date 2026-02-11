local M = {}
local state = {
   buf = nil,
   win = nil,
   job = nil,
   layout = nil,
   float_hidden = false,
   prev_win = nil,
}

local function is_valid_buf(bufnr)
   return type(bufnr) == "number" and vim.api.nvim_buf_is_valid(bufnr)
end

local function is_valid_win(winnr)
   return type(winnr) == "number" and vim.api.nvim_win_is_valid(winnr)
end

local function is_job_running(jobid)
   if type(jobid) ~= "number" or jobid <= 0 then
      return false
   end
   local status = vim.fn.jobwait({ jobid }, 0)[1]
   return status == -1
end

local function close_window_only()
   if is_valid_win(state.win) then
      pcall(vim.api.nvim_win_close, state.win, true)
   end
   state.win = nil
   state.layout = nil
   state.float_hidden = false
end

local function target_dir()
   local path = require("myconf.core.api").path
   local file_path = path.current_file()
   if file_path == "" then
      return path.cwd()
   end

   local dir = path.current_dir()
   if dir == "" then
      return path.cwd()
   end
   return dir
end

local function parse_layout(raw)
   local arg = (raw or ""):lower()
   if arg == "" or arg == "v" or arg == "vertical" then
      return "vertical"
   end
   if arg == "h" or arg == "horizontal" then
      return "horizontal"
   end
   if arg == "f" or arg == "float" or arg == "floating" then
      return "float"
   end
   return nil
end

local function float_window_config()
   local width = math.floor(vim.o.columns * 0.85)
   local height = math.floor(vim.o.lines * 0.80)
   local row = math.floor((vim.o.lines - height) / 2)
   local col = math.floor((vim.o.columns - width) / 2)
   return {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      style = "minimal",
      border = "rounded",
      focusable = true,
   }
end

local function focus_previous_window()
   if is_valid_win(state.prev_win) and state.prev_win ~= state.win then
      pcall(vim.api.nvim_set_current_win, state.prev_win)
      return
   end

   for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= state.win and vim.api.nvim_win_is_valid(win) then
         pcall(vim.api.nvim_set_current_win, win)
         return
      end
   end
end

local function hide_float_window()
   if not is_valid_win(state.win) then
      return false
   end

   pcall(vim.api.nvim_win_set_config, state.win, { hide = true })
   state.float_hidden = true
   focus_previous_window()
   return true
end

local function show_float_window()
   if not is_valid_win(state.win) then
      return false
   end

   local cfg = float_window_config()
   cfg.hide = false
   pcall(vim.api.nvim_win_set_config, state.win, cfg)
   state.float_hidden = false
   pcall(vim.api.nvim_set_current_win, state.win)
   vim.cmd("startinsert")
   return true
end

local function open_target(layout)
   if layout == "vertical" then
      vim.cmd("rightbelow vnew")
      return vim.api.nvim_get_current_win()
   end
   if layout == "horizontal" then
      vim.cmd("rightbelow new")
      return vim.api.nvim_get_current_win()
   else
      local buf = vim.api.nvim_create_buf(true, false)
      return vim.api.nvim_open_win(buf, true, float_window_config())
   end
end

local function set_unique_terminal_name(bufnr, base_name)
   if not is_valid_buf(bufnr) then
      return
   end

   local unique_name = base_name
   local counter = 1

   local function exists(name)
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
         if vim.fn.bufname(bufnr) == name then
            return true
         end
      end
      return false
   end

   while exists(unique_name) do
      unique_name = base_name .. " (" .. counter .. ")"
      counter = counter + 1
   end

   vim.api.nvim_buf_set_name(bufnr, unique_name)
end

function M.toggle()
   if state.layout == "float" and not state.float_hidden and is_valid_win(state.win) then
      hide_float_window()
      return
   end
   close_window_only()
end

function M.close_session()
   close_window_only()

   if is_job_running(state.job) then
      pcall(vim.fn.jobstop, state.job)
   end
   state.job = nil

   if is_valid_buf(state.buf) then
      pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
   end
   state.buf = nil
end

local function set_buffer_keys(bufnr)
   vim.keymap.set("n", "q", function()
      require("myconf.core.cmd.codex").toggle()
   end, {
      buffer = bufnr,
      silent = true,
      nowait = true,
      desc = "Hide Codex window",
   })

   vim.keymap.set("n", "<C-c>", function()
      require("myconf.core.cmd.codex").close_session()
   end, {
      buffer = bufnr,
      silent = true,
      nowait = true,
      desc = "Close Codex session",
   })
end

local function open_codex(layout, opts)
   local toggle_mode = opts and opts.toggle

   if vim.fn.executable("codex") == 0 then
      vim.notify("`codex` non trovato nel PATH", vim.log.levels.ERROR)
      return
   end

   if toggle_mode and is_valid_win(state.win) then
      if state.layout == "float" then
         if state.float_hidden then
            if layout == "float" then
               show_float_window()
               return
            end
            close_window_only()
         else
            hide_float_window()
            return
         end
      else
         close_window_only()
         return
      end
   end

   state.prev_win = vim.api.nvim_get_current_win()
   local win = open_target(layout)
   state.win = win
   state.layout = layout
   state.float_hidden = false

   if is_valid_buf(state.buf) and is_job_running(state.job) then
      vim.api.nvim_win_set_buf(win, state.buf)
      vim.api.nvim_set_current_win(win)
      if layout == "float" then
         vim.bo[state.buf].filetype = "codexfloat"
      end
      set_buffer_keys(state.buf)
      vim.cmd("startinsert")
      return
   end

   local cwd = target_dir()
   state.buf = vim.api.nvim_win_get_buf(win)
   vim.bo[state.buf].bufhidden = "hide"
   state.job = vim.fn.termopen({ "codex" }, {
      cwd = cwd,
      on_exit = function()
         state.job = nil
      end,
   })
   if layout == "float" then
      vim.bo[state.buf].filetype = "codexfloat"
   end
   set_buffer_keys(state.buf)
   vim.schedule(function()
      set_unique_terminal_name(state.buf, "codex")
   end)
   vim.cmd("startinsert")
end

function M.setup()
   pcall(vim.api.nvim_del_user_command, "CodexHere")
   pcall(vim.api.nvim_del_user_command, "CodexHereV")
   pcall(vim.api.nvim_del_user_command, "CodexHereH")
   pcall(vim.api.nvim_del_user_command, "CodexHereF")

   vim.api.nvim_create_user_command("CodexHere", function(opts)
      local layout = parse_layout(opts.args)
      if not layout then
         vim.notify("Uso: :CodexHere [v|h|f]", vim.log.levels.ERROR)
         return
      end
      open_codex(layout, { toggle = true })
   end, {
      nargs = "?",
      desc = "Open Codex in a split at current file directory",
      complete = function(arglead)
         local choices = { "v", "h", "f", "vertical", "horizontal", "float" }
         local out = {}
         for _, item in ipairs(choices) do
            if vim.startswith(item, arglead) then
               table.insert(out, item)
            end
         end
         return out
      end,
   })

   vim.api.nvim_create_user_command("CodexHereV", function()
      open_codex("vertical", { toggle = true })
   end, { desc = "Open Codex in vertical split" })

   vim.api.nvim_create_user_command("CodexHereH", function()
      open_codex("horizontal", { toggle = true })
   end, { desc = "Open Codex in horizontal split" })

   vim.api.nvim_create_user_command("CodexHereF", function()
      open_codex("float", { toggle = true })
   end, { desc = "Open Codex in floating window" })

   vim.keymap.set("n", "<leader>cdv", "<cmd>CodexHereV<CR>", { desc = "Codex vertical split" })
   vim.keymap.set("n", "<leader>cdh", "<cmd>CodexHereH<CR>", { desc = "Codex horizontal split" })
   vim.keymap.set("n", "<leader>cdf", "<cmd>CodexHereF<CR>", { desc = "Codex floating window" })
end

return M

