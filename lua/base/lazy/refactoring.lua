return {
	"ThePrimeagen/refactoring.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("refactoring").setup()
		local ref = require("refactoring")

		vim.keymap.set(
			"x",
			"<leader>re",
			function() ref.refactor("Extract Function") end,
			{ desc = "Refactor: Extract Function" }
		)

		vim.keymap.set(
			"x",
			"<leader>rf",
			function() ref.refactor("Extract Function To File") end,
			{ desc = "Refactor: Extract Function to File" }
		)

		vim.keymap.set(
			"x",
			"<leader>rv",
			function() ref.refactor("Extract Variable") end,
			{ desc = "Refactor: Extract Variable" }
		)

		vim.keymap.set(
			"n",
			"<leader>rI",
			function() ref.refactor("Inline Function") end,
			{ desc = "Refactor: Inline Function" }
		)

		vim.keymap.set(
			{ "n", "x" },
			"<leader>ri",
			function() ref.refactor("Inline Variable") end,
			{ desc = "Refactor: Inline Variable" }
		)

		vim.keymap.set(
			"n",
			"<leader>rb",
			function() ref.refactor("Extract Block") end,
			{ desc = "Refactor: Extract Block" }
		)

		vim.keymap.set(
			"n",
			"<leader>rbf",
			function() ref.refactor("Extract Block To File") end,
			{ desc = "Refactor: Extract Block To File" }
		)

		vim.keymap.set(
			{ "n", "x" },
			"<leader>rr",
			function() require("refactoring").select_refactor() end,
			{ desc = "Refactor Select" }
		)
	end,
}
