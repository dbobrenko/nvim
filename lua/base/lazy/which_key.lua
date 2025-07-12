return {
	"folke/which-key.nvim",
	event = "VimEnter",
	commit = "4433e5e",
	config = function()
		require("which-key").setup()
		-- Document existing key chains
		require("which-key").register({
			["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
			["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
			["<leader>s"] = { name = "[S]earch and Replace", _ = "which_key_ignore" },
			["<leader>r"] = { name = "[R]efactor", _ = "which_key_ignore" },
			["<leader>h"] = { name = "[H]over diagnostics", _ = "which_key_ignore" },
			["<leader>b"] = { name = "[B]uffers", _ = "which_key_ignore" },
			["<leader>d"] = { name = "[D]ebug", _ = "which_key_ignore" },
			["<leader>u"] = { name = "[U]ndo tree", _ = "which_key_ignore" },
			["<leader>a"] = { name = "[A]ccess LLM", _ = "which_key_ignore" },
			["<leader>g"] = { name = "[G]oto: LSP", _ = "which_key_ignore" },
		})
	end,
}
