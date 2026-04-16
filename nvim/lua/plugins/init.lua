return {
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>q', group = '[Q]uick Session' },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = {
        'markdown',
        'markdown_inline',
        'go',
        'c_sharp',
        'rust',
        'typescript',
        'javascript',
      },
      auto_install = true,
    },
    config = function(_, opts)
      require('nvim-treesitter').setup(opts)
    end,
  },
  {
    'ibhagwan/fzf-lua',
    event = 'VimEnter',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    opts = {
      defaults = {
        previewer = 'bat',
      },
      buffers = {
        formatter = 'path.filename_first',
      },
    },
    config = function(_, opts)
      -- Add ctrl-q action to send results to quickfix
      local actions = require 'fzf-lua.actions'
      opts.actions = opts.actions or {}
      opts.actions.files = opts.actions.files or {}
      opts.actions.files['enter'] = actions.file_edit_or_qf
      opts.actions.files['ctrl-q'] = actions.file_sel_to_qf

      opts.grep = opts.grep or {}

      opts.grep.rg_opts =
        '--column --line-number --smart-case --glob "!node_modules/**" --glob "!build/**" --glob "!dist/**" --glob "!bin/**" --glob "!obj/**" --glob "!.git/**"'

      opts.grep.toggle_flag = '--fixed-strings'
      opts.grep.header_separator = '\n:: '
      opts.grep.actions = opts.grep.actions or {}
      opts.grep.actions['ctrl-r'] = { fn = actions.toggle_flag, header = 'Disable regex' }
      require('fzf-lua').setup(opts)

      local fzf = require 'fzf-lua'

      vim.keymap.set('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ff', fzf.files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>gf', fzf.git_files, { desc = '[G]it [F]iles' })
      vim.keymap.set('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
      vim.keymap.set('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', fzf.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', function()
        -- If current window is a terminal, find a non-terminal window
        if vim.bo.buftype == 'terminal' then
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype ~= 'terminal' then
              vim.api.nvim_set_current_win(win)
              break
            end
          end
        end
        fzf.buffers {
          filter = function(bufnr)
            return vim.bo[bufnr].buftype ~= 'terminal'
          end,
        }
      end, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', fzf.blines, { desc = '[/] Fuzzily search in current buffer' })
      vim.keymap.set('n', '<leader>s/', function()
        fzf.live_grep { resume = true, rg_opts = '--type-add web:*.{html,css,js}' }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        fzf.files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'neovim/nvim-lspconfig' },
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
    opts = {
      ensure_installed = {
        'stylua',
        'ruff',
        'csharpier',
        'yamlfix',
        'netcoredbg',
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
    },
  },
  {
    'seblyng/roslyn.nvim',
    ft = 'cs',
    opts = {},
  },
  {
    'DestopLine/boilersharp.nvim',
    ft = 'cs',
    opts = {},
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff_format', 'ruff_organize_imports' },
        yaml = { 'yamlfix' },
      },
    },
  },
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          'rafamadriz/friendly-snippets',
        },
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = {
        preset = 'enter',
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'lua' },

      signature = { enabled = true },
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin-mocha'
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    opts = {},
  },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.pairs').setup()

      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }

      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup {
        view = {
          width = 40,
          adaptive_size = true,
        },
        filters = {
          dotfiles = true,
          git_ignored = true,
        },
        filesystem_watchers = {
          ignore_dirs = { 'bin', 'obj', 'node_modules', '.git' },
        },
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        on_attach = function(bufnr)
          local api = require 'nvim-tree.api'

          local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
          vim.keymap.set('n', 'l', api.node.open.edit, opts 'Open')
          vim.keymap.set('n', 'Z', api.tree.collapse_all, opts 'Collapse All')
          vim.keymap.set('n', '.', function()
            api.tree.toggle_hidden_filter()
            api.tree.toggle_gitignore_filter()
          end, opts 'Toggle Hidden & Git-ignored Files')
        end,
      }
    end,
    keys = {
      { '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>', desc = 'Toggle file explorer' },
    },
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      suppressed_dirs = { '~/', '~/Downloads' },
      session_lens = { load_on_setup = false },
    },
    keys = {
      { '<leader>qs', '<cmd>SessionSave<cr>', desc = '[Q]uick [S]ession Save' },
      { '<leader>qr', '<cmd>SessionRestore<cr>', desc = '[Q]uick Session [R]estore' },
      { '<leader>qd', '<cmd>SessionDelete<cr>', desc = '[Q]uick Session [D]elete' },
    },
    init = function()
      -- Close terminal buffers before quitting so they aren't saved in the session
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == 'terminal' then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      })
      -- Close nvim-tree before saving session to avoid issues
      vim.api.nvim_create_autocmd('User', {
        pattern = 'SessionSavePre',
        callback = function()
          local ok, api = pcall(require, 'nvim-tree.api')
          if ok then
            api.tree.close()
          end
        end,
      })
      -- After restoring a session, close buffers whose files no longer exist
      vim.api.nvim_create_autocmd('User', {
        pattern = 'SessionLoadPost',
        callback = function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              local name = vim.api.nvim_buf_get_name(buf)
              if name ~= '' and vim.fn.filereadable(name) == 0 then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end
        end,
      })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      current_line_blame_opts = {
        delay = 200,
      },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, 'Blame line')
        map('n', '<leader>hB', gs.toggle_current_line_blame, 'Toggle line blame')
        map('n', ']h', gs.next_hunk, 'Next hunk')
        map('n', '[h', gs.prev_hunk, 'Prev hunk')
        map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hd', gs.diffthis, 'Diff this')
      end,
    },
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      require 'config.nvim-dap'
    end,
    event = 'VeryLazy',
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      require 'config.nvim-dap-ui'
    end,
  },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'Issafalcon/neotest-dotnet',
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-dotnet',
        },
      }
    end,
  },
}
