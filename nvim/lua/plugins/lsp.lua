return {
	{ "saghen/blink.compat", version = "2.*", lazy = true, opts = {} },
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets" },
		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- Custom keymap for VS Code-like behavior
			keymap = {
				preset = "enter", -- Use enter preset as base
				["<CR>"] = { "accept", "fallback" }, -- Enter to accept
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" }, -- Tab to select next
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" }, -- Shift+Tab to select previous
				["<Down>"] = { "select_next", "fallback" }, -- Arrow down
				["<Up>"] = { "select_prev", "fallback" }, -- Arrow up
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" }, -- Ctrl+Space to toggle
				["<D-Space>"] = { "show", "show_documentation", "hide_documentation" }, -- Cmd+Space to toggle
				["<C-e>"] = { "hide", "fallback" }, -- Ctrl+e to hide (VS Code style)
				["<Esc>"] = { "hide", "fallback" }, -- Escape to hide
				["<C-d>"] = { "scroll_documentation_down", "fallback" }, -- Scroll down in docs
				["<C-u>"] = { "scroll_documentation_up", "fallback" }, -- Scroll up in docs
				["<C-k>"] = { "show_documentation", "hide_documentation" }, -- Toggle docs
			},
			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},
			-- Automatic completion menu like VS Code
			completion = {
				-- Show menu automatically when typing
				menu = {
					auto_show = true, -- Automatically show menu while typing
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
					},
				},
				-- Show documentation automatically
				documentation = {
					auto_show = true, -- Show docs automatically when item is selected
					auto_show_delay_ms = 500, -- Delay before showing docs
				},
				-- Ghost text for inline suggestions
				ghost_text = {
					enabled = true, -- Show ghost text for the first completion item
				},
			},
			signature = { enabled = true },
			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			---------------------------------------------------------------------------
			-- LSP attach keymaps (for non-Rust LSPs)
			---------------------------------------------------------------------------
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- Skip if it's rust-analyzer (handled by rustaceanvim)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.name == "rust_analyzer" then
						return
					end

					local map = function(keys, func, desc, mode)
						vim.keymap.set(mode or "n", keys, func, {
							buffer = event.buf,
							desc = "LSP: " .. desc,
						})
					end

					map("grr", require("fzf-lua").lsp_references, "References")
					map("gri", require("fzf-lua").lsp_implementations, "Implementations")
					map("grd", require("fzf-lua").lsp_definitions, "Definitions")
					map("<leader>cr", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
				end,
			})

			-- Diagnostics UI
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				},
				virtual_text = { spacing = 2, prefix = "●" },
				underline = true,
				update_in_insert = false,
			})

			-- Capabilities
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			pcall(function()
				capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
			end)

			-- Servers (NO rust_analyzer - handled by rustaceanvim)
			local servers = {
				bashls = {},
				marksman = {},
				lua_ls = {},
			}

			-- Ensure tools installed
			-- ⚠️ rust-analyzer NOT included - use rustup or Homebrew instead
			local ensure_installed = vim.tbl_keys(servers)
			vim.list_extend(ensure_installed, {
				"stylua",
				"shellcheck",
				"prettierd", -- Used to format javascript and tyscript files
				-- ✅ NO 'rust-analyzer' here
				-- Install via: rustup component add rust-analyzer
				-- OR: brew install rust-analyzer
			})

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			-- Mason LSP setup (rust-analyzer completely excluded)
			require("mason-lspconfig").setup({
				-- Only ensure non-Rust servers are installed
				ensure_installed = vim.tbl_keys(servers),

				handlers = {
					function(server_name)
						-- Skip rust_analyzer - rustaceanvim handles it
						if server_name == "rust_analyzer" then
							return
						end

						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}
