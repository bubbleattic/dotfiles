-- Options

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.shiftwidth = 0
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.writebackup = false
vim.o.undofile = true

vim.g.mapleader = " "
vim.o.mouse = "a"
vim.o.mousemoveevent = true

-- Plugins

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "vcpkg/", "node_modules/", "%.git/" },
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer,
						},
						n = {
							["<C-d>"] = actions.delete_buffer,
							["dd"] = actions.delete_buffer,
						},
					},
				},
			})
		end,
		keys = {
			{ "<Leader><Leader>", "<Cmd>Telescope find_files<CR>", desc = "Find files" },
			{ "<Leader>,", "<Cmd>Telescope buffers<CR>", desc = "Find buffers" },
			{ "<Leader>/", "<Cmd>Telescope live_grep<CR>", desc = "Search project" },
		},
	},

	{
		"https://github.com/stevearc/oil.nvim",
		dependencies = {
			{
				"3rd/image.nvim",
				opts = {
					backend = "kitty",
					processor = "magick_cli",
					hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
				},
			},
		},
		config = function()
			require("oil").setup({
				preview_win = {
					update_on_cursor_moved = true,
					preview_method = "fast_scratch",
				},
			})
		end,
		keys = {
			{ "-", "<Cmd>Oil<CR>", desc = "Browse files from here" },
		},
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"Shatur/neovim-ayu",
		priority = 1000,
		config = function()
			require("ayu").setup({
				mirage = false, -- false = dark, true = mirage (slightly lighter)
			})
			vim.cmd.colorscheme("ayu-dark")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end
				map("n", "]h", gs.next_hunk, "Next hunk")
				map("n", "[h", gs.prev_hunk, "Prev hunk")
				map("n", "<Leader>hp", gs.preview_hunk, "Preview hunk")
				map("n", "<Leader>hr", gs.reset_hunk, "Reset hunk")
				map("n", "<Leader>hb", gs.blame_line, "Blame line")
			end,
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- Run :TSInstall c cpp lua python typescript javascript tsx json yaml bash
		-- Highlighting is enabled by default in treesitter 1.0+
	},
	-- TODO: Consider adding later:
	-- "echasnovski/mini.surround" - change/add/delete surrounding quotes, brackets
	-- "ThePrimeagen/harpoon" - quick marks for frequently accessed files
	{
		"https://github.com/windwp/nvim-autopairs",
		event = "InsertEnter", -- Only load when you enter Insert mode
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"https://github.com/numToStr/Comment.nvim",
		event = "VeryLazy", -- Special lazy.nvim event for things that can load later and are not important for the initial UI
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"https://github.com/tpope/vim-sleuth",
		event = { "BufReadPost", "BufNewFile" }, -- Load after your file content
	},
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"shellcheck",
				"prettier",
				"eslint_d",
				"ruff",
				"clang-format",
				-- add other tools here
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"lua_ls",
				"ts_ls",
				"pyright",
				-- ... other LSPs
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
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
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
				opts = {},
			},
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "default",

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},

			sources = {
				default = { "lsp", "path", "snippets" },
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
	{
		"soulis-1256/eagle.nvim",
		opts = {
			--override the default values found in config.lua
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				python = { "ruff_format" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				json = { "prettier" },
				jsonc = { "prettier" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"github/copilot.vim",
		event = "InsertEnter",
	},
	{
		"vim-airline/vim-airline",
	},
})

-- TypeScript/JavaScript: 2 spaces
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

-- Copy relative path to clipboard
vim.keymap.set("n", "<Leader>yp", function()
	local path = vim.fn.expand("%")
	-- Handle Oil paths (oil:///absolute/path -> relative/path)
	if path:match("^oil://") then
		path = path:gsub("^oil://", "")
		path = vim.fn.fnamemodify(path, ":.")
	end
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Yank relative path" })

-- Copy visual selection with file:lines context (for AI agents)
vim.keymap.set("v", "<Leader>yc", function()
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	local path = vim.fn.expand("%")
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
	local header = path .. ":" .. start_line .. "-" .. end_line
	local content = header .. "\n" .. table.concat(lines, "\n")
	vim.fn.setreg("+", content)
	vim.notify("Copied: " .. header)
end, { desc = "Yank selection with context" })

-- Delete all buffers except current (skip unsaved)
vim.keymap.set("n", "<Leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	local deleted = 0
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
			if not vim.bo[buf].modified then
				vim.api.nvim_buf_delete(buf, {})
				deleted = deleted + 1
			end
		end
	end
	vim.notify("Deleted " .. deleted .. " buffer(s)")
end, { desc = "Delete other buffers" })
