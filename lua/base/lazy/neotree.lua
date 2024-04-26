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
			-- make a group to be able to delete it later
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
					always_show = { -- remains visible even if other settings would normally hide it
						".vscode",
						".jenkinsfiles",
					},
					never_show = {
						".git",
						".github",
					},
				},
			},
		})
	end,
	-- vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>')
	vim.keymap.set("n", "<leader>e", "<Cmd>Neotree float<CR>"),
}
