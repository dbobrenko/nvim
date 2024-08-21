---@diagnostic disable: undefined-global, missing-fields
-- debug.lua

return {
	-- NOTE: Yes, you can install new plugins here!
	"mfussenegger/nvim-dap",
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		-- "leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_setup = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"delve",
			},
		})

		-- Basic debugging keymaps, feel free to change to your liking!
		-- local continue = function()
		-- 	if vim.fn.filereadable(".vscode/launch.json") then
		-- 		require("dap.ext.vscode").load_launchjs()
		-- 	end
		-- 	require("dap").continue()
		-- end
		-- vim.keymap.set("n", "<F5>", dap.ext.vscode.load_launchjs, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		--vim.lsp.buffer_mappings.normal_mode["<F5>"] = { continue, "Debug: Start/Continue" }
		vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Debug: Terminate" })
		vim.keymap.set("n", "<F6>", dap.pause, { desc = "Debug: Pause" })
		vim.keymap.set("n", "<F4>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: REPL" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle [B]reakpoint" })
		vim.keymap.set("n", "<leader>dd", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>dc", dap.clear_breakpoints, { desc = "Debug: [C]lear Breakpoints" })
		vim.keymap.set("n", "<leader>dl", dap.list_breakpoints, { desc = "Debug: [L]ist Breakpoints" })
		vim.keymap.set("n", "<leader>ds", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Debug: [S]et Breakpoint" })

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
			layouts = {
				{
					elements = {
						{
							id = "stacks",
							size = 0.25,
						},
						{
							id = "watches",
							size = 0.25,
						},
						{
							id = "breakpoints",
							size = 0.25,
						},
						{
							id = "terminal",
							size = 0.25,
						},
					},
					position = "right",
					size = 30,
				},
				{
					elements = {
						{
							id = "scopes",
							size = 0.5,
						},
						{
							id = "repl",
							size = 0.5,
						},
					},
					position = "bottom",
					size = 15,
				},
			},
		})

		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

		-- Automatically finds and uses the nearest root directory (e.g., where .git or other project files are)
		local function project_root()
			local util = require("lspconfig/util")
			return util.find_git_ancestor(vim.fn.getcwd()) or vim.fn.getcwd()
		end

		-- Configuration to run the current Python script
		dap.configurations.python = {
		  {
			type = "python", -- the type here defined must match the name of the adapter. `dap-python` configures it as `python`
			request = "launch",
			name = "Launch Current File",
			program = "${file}", -- This will use the current file
			pythonPath = function()
			  return "python"
			end,
			cwd = project_root, -- Use the project root as the working directory
			env = {
				PYTHONPATH = function()
					-- Get existing PYTHONPATH, append project root, and handle the case where PYTHONPATH is not set
					local existing_pythonpath = vim.env.PYTHONPATH or ""
					if existing_pythonpath ~= "" then
						existing_pythonpath = existing_pythonpath .. ":"
					end
					return existing_pythonpath .. project_root()
				end
			},
		  },
		}
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Install golang specific config
		-- require("dap-go").setup()
	end,
}
