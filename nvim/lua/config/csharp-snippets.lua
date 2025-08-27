local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node

-- Function to get namespace from file path
local function get_namespace()
  local file_path = vim.fn.expand('%:p')
  if file_path == '' then
    return 'MyNamespace'
  end
  
  local file_dir = vim.fn.fnamemodify(file_path, ':h')
  
  -- Find nearest .csproj file
  local csproj = vim.fs.find(function(name) return name:match('%.csproj$') end, {
    path = file_dir,
    upward = true,
    type = 'file'
  })[1]
  
  if not csproj then
    return 'MyNamespace'
  end
  
  local project_root = vim.fn.fnamemodify(csproj, ':h')
  local project_name = vim.fn.fnamemodify(csproj, ':t:r')
  
  -- Get relative path from project root
  local relative_path = file_dir:gsub('^' .. vim.pesc(project_root) .. '/?', '')
  
  if relative_path == '' or relative_path == '.' then
    return project_name
  end
  
  -- Convert path separators to dots
  local namespace_suffix = relative_path:gsub('[/\\]', '.')
  
  return project_name .. '.' .. namespace_suffix
end

-- C# snippets
ls.add_snippets('cs', {
  s('namespace', {
    f(function() return 'namespace ' .. get_namespace() .. ';' end),
    i(0)
  }),
  s('ns', {
    f(function() return 'namespace ' .. get_namespace() .. ';' end),
    i(0)
  }),
  s('getset', {
    t('{ get; set; }'), i(0)
  }),
  s('get', {
    t('{ get; }'), i(0)
  }),
  s('getinit', {
    t('{ get; init; }'), i(0)
  }),
})