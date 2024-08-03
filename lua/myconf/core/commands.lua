-- `Open` command
vim.api.nvim_create_user_command("Open", function(opts)
  -- Ensure the shell command sources .zshrc before running the `op` function
  vim.fn.system("zsh -c 'source ~/.zshrc; op " .. opts.args .. "'")
end, { nargs = "*", complete = "file" })

-- `Finder` to reveal the current file in Finder
vim.api.nvim_create_user_command("Finder", function()
  local bufname = vim.api.nvim_buf_get_name(0) -- Get the current buffer's name
  local filePath
  if string.find(bufname, "NvimTree_") then
    -- Assuming NvimTree root is the current working directory
    filePath = vim.fn.getcwd()
  else
    filePath = vim.fn.expand("%:p") -- Get the full path of the current file
  end
  os.execute("open -R " .. vim.fn.shellescape(filePath))
end, {})

-- Use the `Code` command to open files or directories in Visual Studio Code
vim.api.nvim_create_user_command("Code", function(opts)
  local escapedArgs = vim.fn.shellescape(opts.args)
  vim.fn.system("code " .. escapedArgs)
end, { nargs = "*", complete = "file" })

-- `Cwd` command to change the working directory to the directory of the current file
vim.api.nvim_create_user_command("Cwd", function()
  vim.cmd("cd %:p:h")
end, {})

-- `Path` command to show the path of the current file
vim.api.nvim_create_user_command("Path", function()
  local filePath = vim.fn.expand("%:p") -- Get the full path of the current file
  print(filePath) -- Print the path to the command line
end, {})

-- `Z` command to use zoxide for changing directories
vim.api.nvim_create_user_command("Z", function(opts)
  -- Execute zoxide query with the provided arguments to get the path
  local path = vim.fn.system("/opt/homebrew/bin/zoxide query " .. vim.fn.shellescape(opts.args))
  -- Trim the newline character from the path
  path = string.gsub(path, "\n$", "")

  -- Check if the path starts with "zoxide:" indicating an error message
  if string.sub(path, 1, 7) == "zoxide:" then
    -- Print the error message from zoxide
    print(path)
  else
    -- Only change the directory if a valid path is returned
    if path ~= "" then
      vim.cmd("cd " .. vim.fn.fnameescape(path))
    else
      print("zoxide: No matching directory found")
    end
  end
end, { nargs = "*", desc = "Use zoxide to change directories" })

-- `Terminal` command to open a terminal in the directory of the current file using `zsh`
vim.api.nvim_create_user_command("Terminal", function(opts)
  local file_dir = vim.fn.expand("%:p:h")
  vim.cmd('split | terminal zsh -c "cd \\"' .. file_dir .. '\\" && zsh"') -- opens it in lower half

  -- Generate a unique buffer name
  local base_name = "zsh - " .. file_dir
  local unique_name = base_name
  local counter = 1
  local is_unique = false

  while not is_unique do
    is_unique = true -- Assume the name is unique until proven otherwise
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if vim.fn.bufname(bufnr) == unique_name then
        unique_name = base_name .. " (" .. counter .. ")"
        counter = counter + 1
        is_unique = false -- Found a matching name, so the assumed unique name isn't actually unique
        break -- Exit the for-loop to try the next unique_name
      end
    end
  end

  -- Set the buffer's name to the unique name
  vim.cmd("file " .. unique_name)
end, {})

-- `Terminal` command to open a terminal in the directory of the current file using `zsh`
-- vim.api.nvim_create_user_command("Terminal", function(opts)
--     -- Get the directory of the current file
--     local file_dir = vim.fn.expand('%:p:h')
--     -- Open a terminal and execute the zsh shell, ensuring it starts in the directory of the current file
--     vim.cmd('split | terminal zsh -c "cd ' .. file_dir .. ' && zsh"') -- opens it in lower half
--     -- Rename the terminal buffer to a custom name, e.g., "MyTerminal"
--     vim.cmd('file zsh - ' .. file_dir)
-- end, {})

-- commands to handle mistyping
vim.cmd("command! Qa qa")
vim.cmd("command! Qaa qa!")
vim.cmd("command! Q q")
vim.cmd("command! Wq wq")
vim.cmd("command! W w")


