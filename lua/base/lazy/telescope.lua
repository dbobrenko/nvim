return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
				live_grep_args = {
					auto_quoting = true, -- enable/disable auto-quoting
				}
			},
		})
		local builtin = require("telescope.builtin")

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "live_grep_args")
		vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>ff", builtin.live_grep, { desc = "[F]ind [F]iles with grep" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind in [B]uffers" })
		vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "[F]ind Recent Files (. for repeat)" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind in [D]iagnostics" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind Current [W]ord" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
		vim.keymap.set(
			"n", "<leader>fo",
			function() builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files", }) end,
			{ desc = "[F]ind in [O]pen Files" }
		)
		vim.keymap.set(
			"n", "<leader>fn",
			function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end,
			{ desc = "[F]ind [N]eovim files" }
		)
		-- vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[F]ind [G]it files" })
		-- vim.keymap.set(
		-- 	"n", "<leader>fg",
		-- 	function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end,
		-- 	{ desc = "[F]ind with [G]rep" }
		-- )
		-- vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
	end,
}
