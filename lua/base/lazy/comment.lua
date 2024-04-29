-- "gc" to comment visual regions/lines
return {
	"numToStr/Comment.nvim",
	lazy = false,
	config = function()
		require("Comment").setup()
		local comment = require("Comment")
		---@diagnostic disable-next-line: missing-fields
		comment.setup({
			toggler = {
				line = "<leader>/",
				block = "<leader>\\",
			},
			opleader = {
				line = "<leader>/",
				block = "<leader>\\",
			},
		})
	end,
}
