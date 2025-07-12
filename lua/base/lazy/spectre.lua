return {
    "nvim-pack/nvim-spectre",
    config = function()
        require("spectre").setup({ is_block_ui_break = true })
        vim.keymap.set(
            "n", "<leader>ss",
            '<cmd>lua require("spectre").toggle()<CR>',
            { desc = "[S]pectre: [S]earch and Replace" }
        )
        vim.keymap.set(
            "n", "<leader>sw",
            '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
            { desc = "[S]pectre: Search and Replace Current [W]ord" }
        )
        vim.keymap.set(
            "v", "<leader>sw",
            '<esc><cmd>lua require("spectre").open_visual()<CR>',
            { desc = "[S]pectre: Search and Replace Current [W]ord" }
        )
        vim.keymap.set(
            "n", "<leader>sf",
            '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
            { desc = "[S]pectre: Search and Replace in [F]ile" }
        )
  end,
}
