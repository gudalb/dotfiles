# Migrating LSP config to native Neovim 0.11+

Neovim 0.11 introduced `vim.lsp.config` and `vim.lsp.enable`, making `nvim-lspconfig`
and `mason-lspconfig` unnecessary. This document explains how to migrate your current
setup to use the built-in API.

---

## What changes

| Before | After |
|---|---|
| `neovim/nvim-lspconfig` | removed |
| `williamboman/mason-lspconfig.nvim` | removed |
| `lspconfig[name].setup({})` | `vim.lsp.config('name', {})` + `vim.lsp.enable('name')` |
| capabilities set per-server | set once globally via `vim.lsp.config('*', {})` |

**Keep:** `mason.nvim`, `mason-tool-installer.nvim`, `fidget.nvim`, `blink.cmp`

---

## How vim.lsp.config works

```lua
-- Configure a server (does not start it)
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = { ... },
})

-- Enable it (starts when a matching filetype is opened)
vim.lsp.enable('lua_ls')
```

The `'*'` wildcard applies config to **all** servers — use this for capabilities:

```lua
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})
```

---

## Migrating each server

### lua_ls

```lua
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
    },
  },
})
vim.lsp.enable('lua_ls')
```

> `filetypes` can be omitted — lua_ls ships its own default filetype list.

### rust_analyzer

```lua
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      check = { command = 'clippy' },
    },
  },
})
vim.lsp.enable('rust_analyzer')
```

### eslint

The `on_attach` forcing `documentFormattingProvider` becomes an autocmd filter:

```lua
vim.lsp.config('eslint', {
  filetypes = {
    'javascript', 'javascriptreact',
    'typescript', 'typescriptreact',
    'vue', 'html', 'css', 'scss', 'json',
  },
  settings = { format = true },
})
vim.lsp.enable('eslint')

-- Replace the on_attach override
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'eslint' then
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
    end
  end,
})
```

### Servers with no custom config (html, css, json, ts, angular, gopls, svelte)

These only need `enable`:

```lua
vim.lsp.enable({
  'html',
  'cssls',
  'jsonls',
  'ts_ls',          -- typescript-language-server
  'angularls',
  'gopls',
  'svelte',
})
```

> **Mason package name vs LSP server name** — they differ. See the table below.

---

## Mason package name → LSP server name

| Mason package | vim.lsp.enable name |
|---|---|
| `lua-language-server` | `lua_ls` |
| `rust-analyzer` | `rust_analyzer` |
| `eslint-lsp` | `eslint` |
| `html-lsp` | `html` |
| `css-lsp` | `cssls` |
| `json-lsp` | `jsonls` |
| `typescript-language-server` | `ts_ls` |
| `angular-language-server` | `angularls` |
| `gopls` | `gopls` |
| `svelte-language-server` | `svelte` |

> `roslyn` is handled by `seblj/roslyn.nvim` — leave that plugin as-is.

---

## Resulting plugin block

Replace the entire `neovim/nvim-lspconfig` block (and remove `mason-lspconfig`
from dependencies) with:

```lua
{
  'williamboman/mason.nvim',
  opts = {
    registries = {
      'github:mason-org/mason-registry',
      'github:Crashdummyy/mason-registry',
    },
  },
},
{
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  dependencies = { 'williamboman/mason.nvim' },
  config = function()
    require('mason-tool-installer').setup {
      ensure_installed = {
        -- formatters / linters
        'stylua', 'ruff', 'csharpier', 'yamlfix',
        -- debuggers
        'netcoredbg',
        -- LSP servers (mason package names)
        'lua-language-server',
        'rust-analyzer',
        'eslint-lsp',
        'html-lsp',
        'css-lsp',
        'json-lsp',
        'typescript-language-server',
        'angular-language-server',
        'roslyn',
        'gopls',
        'svelte-language-server',
      },
    }
  end,
},
{
  'j-hui/fidget.nvim',
  opts = {},
},
```

Then in `init.lua` (or a dedicated `lua/config/lsp.lua`), add:

```lua
-- Inject blink.cmp capabilities into every LSP server
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Server configs
vim.lsp.config('lua_ls', {
  settings = { Lua = { completion = { callSnippet = 'Replace' } } },
})

vim.lsp.config('rust_analyzer', {
  settings = { ['rust-analyzer'] = { check = { command = 'clippy' } } },
})

vim.lsp.config('eslint', {
  filetypes = {
    'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
    'vue', 'html', 'css', 'scss', 'json',
  },
  settings = { format = true },
})

-- Enable all servers
vim.lsp.enable({
  'lua_ls', 'rust_analyzer', 'eslint',
  'html', 'cssls', 'jsonls', 'ts_ls',
  'angularls', 'gopls', 'svelte',
})

-- eslint formatting override (replaces the old on_attach)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == 'eslint' then
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
    end
  end,
})
```

The existing `LspAttach` autocmd in your config (keymaps, document highlight,
inlay hints) does **not** need to change — it already uses the correct 0.11+ API.

---

## Notes

- `vim.lsp.config` configs can also live in `~/.config/nvim/lsp/<name>.lua` —
  Neovim auto-loads them. Useful if you want one file per server.
- `mason-lspconfig` is what bridged Mason installs to `lspconfig.setup()`. Without
  it, Mason still installs binaries; `vim.lsp.enable` finds them via `$PATH` (Mason
  adds its bin dir to PATH automatically).
- The `client_supports_method` compatibility shim in your current config can be
  simplified to just `client:supports_method(method, bufnr)` on 0.11+.
