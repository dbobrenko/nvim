return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup()
		local ref = require("refactoring")
		vim.keymap.set("x", "<leader>re", function()
			ref.refactor("Extract Function")
		end)
		vim.keymap.set("x", "<leader>rf", function()
			ref.refactor("Extract Function To File")
		end)
		-- Extract function supports only visual mode

		vim.keymap.set("x", "<leader>rv", function()
			ref.refactor("Extract Variable")
		end)
		-- Extract variable supports only visual mode

		vim.keymap.set("n", "<leader>rI", function()
			ref.refactor("Inline Function")
		end)
		-- Inline func supports only normal

		vim.keymap.set({ "n", "x" }, "<leader>ri", function()
			ref.refactor("Inline Variable")
		end)
		-- Inline var supports both normal and visual mode

		vim.keymap.set("n", "<leader>rb", function()
			ref.refactor("Extract Block")
		end)
		vim.keymap.set("n", "<leader>rbf", function()
			ref.refactor("Extract Block To File")
		end)
		-- Extract block supports only normal mode

		-- prompt for a refactor to apply when the remap is triggered
		vim.keymap.set({ "n", "x" }, "<leader>rr", function()
			require("refactoring").select_refactor()
		end, { desc = "Refactor Select" })
		-- Note that not all refactor support both normal and visual mode
	end,
}
