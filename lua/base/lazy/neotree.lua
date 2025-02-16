-- https://github.com/nvim-neo-tree/neo-tree.nvim
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  init = function()
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
      callback = function()
        local f = vim.fn.expand("%:p")
        if vim.fn.isdirectory(f) ~= 0 then
          vim.cmd("Neotree current dir=" .. f)
          -- neo-tree is loaded now, delete the init autocmd
          vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
        end
      end,
    })
  end,
  config = function()
    require("neo-tree").setup({
      filesystem = {
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_hidden = false,
          hide_gitignored = false,
          always_show = { ".vscode", ".jenkinsfiles" },
          never_show = { ".git", ".github" },
        },
        window = {
          mappings = {
            -- Copy the relative path of the selected file (Shift + Y)
            ["Y"] = function(state)
              local node = state.tree:get_node()
              if node and node.path then
                local relative_path = vim.fn.fnamemodify(node.path, ":.")
                vim.fn.setreg("+", relative_path)
                vim.notify("Copied relative path: " .. relative_path)
              end
            end,
            -- Copy the absolute path of the selected file (Shift + Ctrl + Y)
            ["<C-Y>"] = function(state)
              local node = state.tree:get_node()
              if node and node.path then
                vim.fn.setreg("+", node.path)
                vim.notify("Copied absolute path: " .. node.path)
              end
            end,
          },
        },
      },
    })
  end,
  -- Toggle neo-tree with <leader>e in a floating window (default view)
  vim.keymap.set("n", "<leader>e", "<Cmd>Neotree float<CR>"),
  -- Open neo-tree in buffers view (same as switching to buffers tab with >) using <leader>b
  vim.keymap.set("n", "<leader>b", "<Cmd>Neotree float source=buffers<CR>"),
}
