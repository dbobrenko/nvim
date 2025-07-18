vim.g.mapleader = " "
vim.g.maplocalleader = " "
local map = vim.keymap.set

-- Move selected rows with J/K.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected rows down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected rows up" })

vim.keymap.set("n", "<S-h>", "<C-o>", { desc = "Move backward" })
vim.keymap.set("n", "<M-h>", "<C-o>", { desc = "Move backward" })
vim.keymap.set("n", "<S-l>", "<C-i>", { desc = "Move forward" })
vim.keymap.set("n", "<M-l>", "<C-i>", { desc = "Move forward" })

-- Prevent stripping EOL on save
--vim.api.nvim_command("autocmd BufNewFile,BufRead,BufWritePost * setlocal fixeol")
-- vim.opt_global.fixeol = true
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufWritePost" }, {
-- 	group = "_formatting",
-- 	pattern = "*",
-- 	command = "setl fixeol",
-- })

-- Resize with arrows.
local resize_up = function()
	require("smart-splits").resize_up(2)
end
vim.keymap.set({ "n", "i" }, "<M-Up>", resize_up, { desc = "Resize split up" })
vim.keymap.set({ "n", "i" }, "<M-k>", resize_up, { desc = "Resize split up" })

local resize_down = function()
	require("smart-splits").resize_down(2)
end
vim.keymap.set({ "n", "i" }, "<M-Down>", resize_down, { desc = "Resize split down" })
vim.keymap.set({ "n", "i" }, "<M-j>", resize_down, { desc = "Resize split down" })

local resize_left = function()
	require("smart-splits").resize_left(2)
end
vim.keymap.set({ "n", "i" }, "<M-Left>", resize_left, { desc = "Resize split left" })
vim.keymap.set({ "n", "i" }, "<M-h>", resize_left, { desc = "Resize split left" })

local resize_right = function()
	require("smart-splits").resize_right(2)
end
vim.keymap.set({ "n", "i" }, "<M-Right>", resize_right, { desc = "Resize split right" })
vim.keymap.set({ "n", "i" }, "<M-l>", resize_right, { desc = "Resize split right" })

-- Diagnostic keymaps.
vim.keymap.set("n", "<leader>hm", "<cmd>messages<cr>", { desc = "Show neovim [M]essages" })
vim.keymap.set("n", "<leader>hl", vim.diagnostic.setloclist, { desc = "Diagnostic Quickfix [L]ist" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous Diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next Diagnostic message" })
vim.keymap.set("n", "<leader>hh", vim.diagnostic.open_float, { desc = "Diagnostic [H]over error" })
vim.api.nvim_set_keymap(
	"n",
	"<leader>he",
	"<cmd>lua vim.diagnostic.open_float()<CR><cmd>lua vim.diagnostic.open_float()<CR>",
	{ noremap = true, silent = true, desc = "Diagnostic [E]nter error" }
)

-- Buffers.
-- map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous Buffer" })
-- map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<M-j>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<M-k>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Cursor stay at its location while joining line.
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })

-- Half-page down/up moves cursor to the middle of the screen.
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center" })

-- Search terms stay in the middle of the screen.
vim.keymap.set("n", "n", "nzzzv", { desc = "Move to next search match and center" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Move to previous search match and center" })

-- Reset highlights on search.
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })

-- Replace selected characters with paste, without replacing current clipboard.
-- Replace characters with paste, without replacing current clipboard.
vim.keymap.set("x", "p", [["_dP]], { desc = "Replace selection without affecting register" })
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Replace selection without affecting register" })

-- Copy to system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y"]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y"]], { desc = "Yank line to system clipboard" })

-- Delete without clipboard.
vim.keymap.set({ "n", "v" }, "<leader>D", [["_d"]], { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>X", [["_x"]], { desc = "Cut without yanking" })

-- Disable vim Q keybinding.
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "Next Quickfix item" })
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "Previous Quickfix item" })
