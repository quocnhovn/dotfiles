-- Keybindings optimized for Deepin OS and development workflow
-- Enhanced for fullstack PHP, Go, Vue.js development

return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        -- Development workflow keybindings
        { "<leader>d", group = "Debug/Development" },
        { "<leader>dp", "<cmd>lua require('dap').toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
        { "<leader>dc", "<cmd>lua require('dap').continue()<cr>", desc = "Continue Debug" },
        { "<leader>ds", "<cmd>lua require('dap').step_over()<cr>", desc = "Step Over" },
        { "<leader>di", "<cmd>lua require('dap').step_into()<cr>", desc = "Step Into" },
        { "<leader>do", "<cmd>lua require('dap').step_out()<cr>", desc = "Step Out" },
        { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "Open REPL" },

        -- Project management
        { "<leader>p", group = "Project" },
        { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>pg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
        { "<leader>pb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>pr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
        { "<leader>ps", "<cmd>Telescope projects<cr>", desc = "Switch Project" },

        -- Laravel specific (when in PHP projects)
        { "<leader>l", group = "Laravel" },
        { "<leader>la", "<cmd>Laravel artisan<cr>", desc = "Artisan Commands", ft = "php" },
        { "<leader>lr", "<cmd>Laravel routes<cr>", desc = "Show Routes", ft = "php" },
        { "<leader>lm", "<cmd>!php artisan make:", desc = "Make Component", ft = "php" },

        -- Go specific commands
        { "<leader>g", group = "Go" },
        { "<leader>gt", "<cmd>GoTest<cr>", desc = "Run Tests", ft = "go" },
        { "<leader>gr", "<cmd>GoRun<cr>", desc = "Run", ft = "go" },
        { "<leader>gb", "<cmd>GoBuild<cr>", desc = "Build", ft = "go" },
        { "<leader>gf", "<cmd>GoFmt<cr>", desc = "Format", ft = "go" },
        { "<leader>gi", "<cmd>GoImports<cr>", desc = "Organize Imports", ft = "go" },

        -- Terminal management
        { "<leader>t", group = "Terminal" },
        { "<leader>tt", "<cmd>ToggleTerm direction=tab<cr>", desc = "Terminal Tab" },
        { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal Horizontal" },
        { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "Terminal Vertical" },
        { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Terminal Float" },

        -- Git workflow
        { "<leader>G", group = "Git" },
        { "<leader>Gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        { "<leader>Gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
        { "<leader>Gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
        { "<leader>Gs", "<cmd>Telescope git_status<cr>", desc = "Status" },

        -- Database management
        { "<leader>D", group = "Database" },
        { "<leader>Dt", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
        { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB Buffer" },
        { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },

        -- Code actions and refactoring
        { "<leader>c", group = "Code" },
        { "<leader>cr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
        { "<leader>cd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
        { "<leader>ci", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
        { "<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>cw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },

        -- File explorer
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
        { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Focus Explorer" },

        -- Window management
        { "<leader>w", group = "Windows" },
        { "<leader>wh", "<C-w>h", desc = "Go to left window" },
        { "<leader>wj", "<C-w>j", desc = "Go to lower window" },
        { "<leader>wk", "<C-w>k", desc = "Go to upper window" },
        { "<leader>wl", "<C-w>l", desc = "Go to right window" },
        { "<leader>ws", "<C-w>s", desc = "Split window below" },
        { "<leader>wv", "<C-w>v", desc = "Split window right" },
        { "<leader>wd", "<C-w>c", desc = "Delete window" },
        { "<leader>wo", "<C-w>o", desc = "Close other windows" },

        -- Buffer management
        { "<leader>b", group = "Buffers" },
        { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Switch Buffer" },
        { "<leader>bd", "<cmd>bdelete<cr>", desc = "Delete Buffer" },
        { "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
        { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous Buffer" },
        { "<leader>bD", "<cmd>%bdelete|edit#|bdelete#<cr>", desc = "Delete All But Current" },
      },
    },
  },

  -- Enhanced movement and navigation
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = true,
        },
        char = {
          enabled = true,
          jump_labels = true,
        },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
