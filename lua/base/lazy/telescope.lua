return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	config = function()
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you"re looking for is in `:help telescope.setup()`
			--
			-- defaults = {
			--   mappings = {
			--     i = { ["<c-enter>"] = "to_fuzzy_refine" },
			--   },
			-- },
			-- pickers = {}
			extensions = {
				["ui-select"] = { require("telescope.themes").get_dropdown() },
			},
		})
		local builtin = require("telescope.builtin")

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[F]ind [G]it files" })
		vim.keymap.set("n", "<leader>fg", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "[F]ind with [G]rep" })
		vim.keymap.set("n", "<leader>ff", builtin.live_grep, { desc = "[F]ind [F]iles with grep" })
		vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "Find existing [B]uffers" })
		vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "[F]ind Recent Files (. for repeat)" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
		vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
		vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
		-- It"s also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>fo", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[F]ind in [O]pen Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })
		-- vim.keymap.set("n", "<leader>pws", function()
		-- 	local word = vim.fn.expand("<cword>")
		-- 	builtin.grep_string({ search = word })
		-- end)
		-- vim.keymap.set("n", "<leader>pWs", function()
		-- 	local word = vim.fn.expand("<cWORD>")
		-- 	builtin.grep_string({ search = word })
		-- end)
		-- vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
	end,
}
