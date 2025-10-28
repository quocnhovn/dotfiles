-- Yazi init.lua for plugin management
-- Based on best practices from dotfiles-docs.vercel.app

-- Git integration plugin
require("git"):setup()

-- Full border plugin for better aesthetics
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

-- Starship prompt integration
require("starship"):setup()

-- Search jump plugin for enhanced navigation
require("searchjump"):setup {
	-- Keybindings for searchjump
	keys = {
		forward = "/",
		backward = "?",
	},
}
