LSP = {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require("fidget").setup({})`
		{ "j-hui/fidget.nvim", opts = {} },
		-- used for completion, annotations and signatures of Neovim apis
		{ "folke/neodev.nvim", opts = {} },
		-- { "jose-elias-alvarez/null-ls.nvim" },
	},
	config = function()
		-- If you"re wondering about lsp vs treesitter, you can check out the wonderfully
		-- and elegantly composed help section, `:help lsp-vs-treesitter`
		--  This function gets run when an LSP attaches to a particular buffer.
		--    That is to say, every time a new file is opened that is associated with
		--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
		--    function will be executed to configure the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end
				-- Jump to the definition of the word under your cursor.
				--  This is where a variable was first declared, or where a function is defined, etc.
				--  To jump back, press <C-t>.
				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				-- Find references for the word under your cursor.
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				-- Jump to the implementation of the word under your cursor.
				--  Useful when your language has ways of declaring types without an actual implementation.
				-- map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				vim.keymap.set("n", "gi", function()
				  local clients = vim.lsp.get_clients()
				  local support_impl = false
				  for _, client in ipairs(clients) do
					if client.server_capabilities.implementationProvider then
					  support_impl = true
					  break
					end
				  end
				  if support_impl then
					require("telescope.builtin").lsp_implementations()
				  else
					print("Implementation provider not supported by the active language server")
				  end
				end, { desc = "[G]oto [I]mplementation" })

				-- Jump to the type of the word under your cursor.
				--  Useful when you"re not sure what type a variable is and you want to see
				--  the definition of its *type*, not where it was *defined*.
				map("<leader>lt", require("telescope.builtin").lsp_type_definitions, "[T]ype Definition")
				-- Fuzzy find all the symbols in your current document.
				--  Symbols are things like variables, functions, types, etc.
				map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "Document [S]ymbols")
				-- Fuzzy find all the symbols in your current workspace.
				--  Similar to document symbols, except searches over your entire project.
				map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace Symbols")
				-- Rename the variable under your cursor.
				--  Most Language Servers support renaming across files, etc.
				map("<leader>lr", vim.lsp.buf.rename, "[R]ename")
				map("<F2>", vim.lsp.buf.rename, "Rename [F2]>")
				-- Execute a code action, usually your cursor needs to be on top of an error
				-- or a suggestion from your LSP for this to activate.
				map("<leader>la", vim.lsp.buf.code_action, "Code [A]ction")
				-- Opens a popup that displays documentation about the word under your cursor
				--  See `:help K` for why this keymap.
				map("<leader>lh", vim.lsp.buf.hover, "[H]over Documentation")
				--  For example, in C this would take you to the header.
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("<leader>lf", vim.lsp.buf.format, "[F]ormat code")
				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})
				end

				-- The following autocommand is used to enable inlay hints in your
				-- code, if the language server you are using supports them.

				-- This may be unwanted, since they displace some of your code.
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>lh", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[L]SP Toggle Inlay [H]ints")
				end
			end,
		})

		vim.api.nvim_create_autocmd("LspDetach", {
			group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
			callback = function(event)
				vim.lsp.buf.clear_references()

				-- Check if the 'lsp-highlight' group exists before clearing it
				local success, _ = pcall(function()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
				end)

				if not success then
					vim.notify("Failed to clear autocmds for group 'lsp-highlight'", vim.log.levels.WARN)
				end
			end,
		})
		-- vim.api.nvim_create_autocmd("LspDetach", {
		-- 	group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
		-- 	callback = function(event)
		-- 		vim.lsp.buf.clear_references()
		-- 		vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
		-- 	end,
		-- })

		-- LSP servers and clients are able to communicate to each other what features they support.
		--  By default, Neovim doesn"t support everything that is in the LSP specification.
		--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
		--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		-- Enable the following language servers
		--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers = {
			-- clangd = {},
			-- gopls = {},
			-- pyright = {},
			-- rust_analyzer = {},
			-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
			--
			-- Some languages (like typescript) have entire language plugins that can be useful:
			--    https://github.com/pmizio/typescript-tools.nvim
			--
			-- But for many setups, the LSP (`tsserver`) will work just fine
			-- tsserver = {},
			--

			lua_ls = {
				-- cmd = {...},
				-- filetypes = { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						-- You can toggle below to ignore Lua_LS"s noisy `missing-fields` warnings
						-- diagnostics = { disable = { "missing-fields" } },
					},
				},
			},
		}


	-- Make ruff and black respect project settings defined in pyproject.toml
	local lspconfig = require("lspconfig")
	local lspconfig_util = require("lspconfig.util")
	-- Function to determine the root directory
	local function get_root_dir(fname)
		return lspconfig_util.root_pattern("pyproject.toml", ".git", "setup.py")(fname) or lspconfig_util.path.dirname(fname)
	end

	-- Configure the Python LSP server (like `pylsp`) to use `black` and `ruff`
	lspconfig.pylsp.setup({
		root_dir = get_root_dir,
		settings = {
			pylsp = {
				plugins = {
					pycodestyle = { enabled = false },
					flake8 = { enabled = false },
					mypy = { enabled = false },
					pylint = { enabled = false },
					black = {
						enabled = true,
						line_length = 120
					},
					ruff = {
						enabled = true,
						line_length = 120
					},
				},
			},
		},
	})

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		require("mason").setup()

		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"bashls",
			"yamlls",
			"jsonls",
			-- Python
			"debugpy",
			"black",
			"ruff",
			"pyright",
			"isort",
			-- "ruff-lsp",
			-- "python-lsp-server"  -- Supports LSP navigation
			-- "pylint",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}

CONFORM = { -- Autoformat
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>lF",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		-- format_on_save = function(bufnr)
		-- 	-- Disable "format_on_save lsp_fallback" for languages that don"t
		-- 	-- have a well standardized coding style. You can add additional
		-- 	-- languages here or re-enable it for the disabled ones.
		-- 	local disable_filetypes = { c = true, cpp = true }
		-- 	return {
		-- 		timeout_ms = 500,
		-- 		lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		-- 	}
		-- end,
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			-- javascript = { { "prettierd", "prettier" } },
		},
	},
}

CMP = { -- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- This step is not supported in many windows environments.
				-- Remove the below condition to re-enable on windows.
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				-- `friendly-snippets` contains a variety of premade snippets.
				--    See the README about individual language/framework/plugin snippets:
				--    https://github.com/rafamadriz/friendly-snippets
				-- {
				--   "rafamadriz/friendly-snippets",
				--   config = function()
				--     require("luasnip.loaders.from_vscode").lazy_load()
				--   end,
				-- },
			},
		},
		"saadparwaiz1/cmp_luasnip",

		-- Adds other completion capabilities.
		--  nvim-cmp does not ship with all sources by default. They are split
		--  into multiple repos for maintenance purposes.
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
	},
	config = function()
		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		luasnip.config.setup({})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },

			-- For an understanding of why these mappings were
			-- chosen, you will need to read `:help ins-completion`
			--
			-- No, but seriously. Please read `:help ins-completion`, it is really good!
			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<Tab>"] = cmp.mapping.select_next_item(),
				-- ["<C-j>"] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				["<C-p>"] = cmp.mapping.select_prev_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				-- ["<C-k>"] = cmp.mapping.select_prev_item(),

				-- Scroll the documentation window [b]ack / [f]orward
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<CR>"] = cmp.mapping.confirm({ select = true }),

				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don"t need this, because nvim-cmp will display
				--  completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete({}),

				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that"s like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			}),
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
			},
		})
	end,
}

return {
	LSP,
	CONFORM,
	CMP,
}
