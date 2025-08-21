return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "c_sharp",
        "lua",
        "html",
        "css",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "csharpier",
        "html-lsp",
        "css-lsp",
        "prettier",
        "json-lsp",
        "netcoredbg",
        "typescript-language-server",
      },
    },
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },
  {
    "MonsieurTib/neonuget",
    config = function()
      require("neonuget").setup({
        -- Optional configuration
        dotnet_path = "dotnet", -- Path to dotnet CLI
        default_project = nil, -- Auto-detected, or specify path like "./MyProject/MyProject.csproj"
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
