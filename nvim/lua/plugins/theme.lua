return {
	{
		"shreyanshvyas414/lite-ui",
		config = function()
			require("lite-ui").setup({
				theme = "kanagawa", -- or any other theme!

				input = {
					-- CRITICAL: Enable auto-detection for LSP rename to work correctly
					-- This makes the rename dialog prefill with function/variable names
					auto_detect_cword = true,
				},
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "auto",
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				styles = {
					keywords = { italic = false },
				},
				on_colors = function(colors)
					colors.git = {
						-- add = "#82c13e",
						-- change = "#d4902b",
						-- delete = "#f10e38",
						add = colors.green,
						change = colors.yellow,
						delete = colors.red,
					}
				end,
				on_highlights = function(highlights, colors)
					highlights.MatchParen = {
						bg = colors.blue0,
						bold = true,
					}
				end,
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{ "EdenEast/nightfox.nvim" },
	{ "vague2k/vague.nvim" },
}
