return {
	{ "tpope/vim-sleuth" },
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{ "mrcjkb/rustaceanvim", version = "^7", lazy = false },
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			vim.g.rainbow_delimiters = {
				highlight = {
					"RainbowDelimiterYellow",
					"RainbowDelimiterViolet",
					"RainbowDelimiterBlue",
				},
			}
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
