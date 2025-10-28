-- Bob Neovim version manager integration
return {
  {
    "MordechaiHadad/bob",
    build = function()
      -- Install bob if not already installed
      if vim.fn.executable("bob") == 0 then
        os.execute("curl -sL https://raw.githubusercontent.com/MordechaiHadad/bob/master/install | bash")
      end
    end,
    config = function()
      -- Bob configuration
      vim.g.bob_config = {
        downloads_location = vim.fn.expand("~/.local/share/bob"),
        version_sync_file_location = vim.fn.expand("~/.local/share/bob/nvim-version"),
      }

      -- Add keymaps for bob
      vim.keymap.set("n", "<leader>bv", function()
        vim.ui.input({ prompt = "Neovim version to install: " }, function(version)
          if version then
            vim.cmd("!bob install " .. version)
          end
        end)
      end, { desc = "Install Neovim version with bob" })

      vim.keymap.set("n", "<leader>bu", function()
        vim.ui.input({ prompt = "Neovim version to use: " }, function(version)
          if version then
            vim.cmd("!bob use " .. version)
          end
        end)
      end, { desc = "Switch Neovim version with bob" })

      vim.keymap.set("n", "<leader>bl", "<cmd>!bob ls<cr>", { desc = "List installed Neovim versions" })
    end,
  },
}
