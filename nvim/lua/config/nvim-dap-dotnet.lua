local M = {}

-- Find the root directory of a .NET project by searching for .csproj files
function M.find_project_root_by_csproj(start_path)
  local current_path = start_path

  while current_path ~= "/" do
    local csproj_files = vim.fn.glob(current_path .. "/*.csproj", false, true)
    if #csproj_files > 0 then
      return current_path
    end

    -- Go to parent directory
    local parent = vim.fn.fnamemodify(current_path, ":h")
    if parent == current_path then
      return nil
    end
    current_path = parent
  end

  return nil
end

-- Find the highest version of the netX.Y folder within a given path.
function M.get_highest_net_folder(bin_debug_path)
  local dirs = vim.fn.glob(bin_debug_path .. "/net*", false, true) -- Get all folders starting with 'net' in bin_debug_path

  if #dirs == 0 then
    vim.notify("No netX.Y folders found in " .. bin_debug_path, vim.log.levels.ERROR)
    return nil
  end

  table.sort(dirs, function(a, b) -- Sort the directories based on their version numbers
    local ver_a = tonumber(a:match("net(%d+)%.%d+"))
    local ver_b = tonumber(b:match("net(%d+)%.%d+"))
    return ver_a > ver_b
  end)

  return dirs[1]
end

-- Build and return the full path to the .dll file for debugging.
function M.build_dll_path()
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir = vim.fn.fnamemodify(current_file, ":p:h")

  local project_root = M.find_project_root_by_csproj(current_dir)
  if not project_root then
    vim.notify("Could not find project root (no .csproj found)", vim.log.levels.ERROR)
    return nil
  end

  local csproj_files = vim.fn.glob(project_root .. "/*.csproj", false, true)
  if #csproj_files == 0 then
    vim.notify("No .csproj file found in project root", vim.log.levels.ERROR)
    return nil
  end

  local project_name = vim.fn.fnamemodify(csproj_files[1], ":t:r")
  local bin_debug_path = project_root .. "/bin/Debug"

  local highest_net_folder = M.get_highest_net_folder(bin_debug_path)
  if not highest_net_folder then
    return nil
  end

  local dll_path = highest_net_folder .. "/" .. project_name .. ".dll"

  return dll_path
end

return M
