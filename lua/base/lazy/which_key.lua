return {
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to "VimEnter"
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()
		-- Document existing key chains
		require("which-key").register({
			["<leader>l"] = { name = "[L]SP", _ = "which_key_ignore" },
			["<leader>f"] = { name = "[F]ind", _ = "which_key_ignore" },
		})
	end,
}
