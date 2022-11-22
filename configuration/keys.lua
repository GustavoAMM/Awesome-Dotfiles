local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local decorations = require("ui.decorations")
local bling = require("modules.bling")
local playerctl_daemon = require("signal.playerctl")
local machi = require("modules.layout-machi")
local helpers = require("helpers")
local apps = require("configuration.apps")

--- Make key easier to call

mod = "Mod4"
alt = "Mod1"
ctrl = "Control"
shift = "Shift"

--- Global key bindings

awful.keyboard.append_global_keybindings({

	-- Terminal
	awful.key({ mod }, "Return", function()
		awful.spawn(apps.default.terminal)
	end, { description = "open terminal", group = "app" }),

	--- App launcher
	awful.key({ mod }, "d", function()
		awful.spawn.with_shell(apps.default.app_launcher)
	end, { description = "open app launcher", group = "app" }),

	--- File manager
	awful.key({ mod }, "e", function()
		awful.spawn(apps.default.file_manager)
	end, { description = "open file manager", group = "app" }),

	--- Web browser
	awful.key({ mod }, "w", function()
		awful.spawn(apps.default.web_browser)
	end, { description = "open web browser", group = "app" }),

  --- Private web browser
  awful.key({mod , shift}, "w", function()
    awful.spawn(apps.default.private_browser)
  end, {description = "open private web browser", group = "app"}),

	--- Restart awesome
	awful.key({ mod, ctrl }, "r", awesome.restart, { description = "reload awesome", group = "WM" }),

	--- Quit awesome
	awful.key({ mod, ctrl }, "q", awesome.quit, { description = "quit awesome", group = "WM" }),

	--- Show help
	awful.key({ mod }, "F1", hotkeys_popup.show_help, { description = "show Help", group = "WM" }),

	--- Client
	--- Focus client by direction

  awful.key({ mod }, "Up", function()
		awful.client.focus.bydirection("up")
		bling.module.flash_focus.flashfocus(client.focus)
	end, { description = "focus up", group = "client" }),

	awful.key({ mod }, "Down", function()
		awful.client.focus.bydirection("down")
		bling.module.flash_focus.flashfocus(client.focus)
	end, { description = "focus down", group = "client" }),

	awful.key({ mod }, "Left", function()
		awful.client.focus.bydirection("left")
		bling.module.flash_focus.flashfocus(client.focus)
	end, { description = "focus left", group = "client" }),

	awful.key({ mod }, "Right", function()
		awful.client.focus.bydirection("right")
		bling.module.flash_focus.flashfocus(client.focus)
	end, { description = "focus right", group = "client" }),

	--- Resize focused client

	awful.key({ mod, ctrl }, "Up", function(c)
		helpers.client.resize_client(client.focus, "up")
	end, { description = "resize to the up", group = "client" }),
	awful.key({ mod, ctrl }, "Down", function(c)
		helpers.client.resize_client(client.focus, "down")
	end, { description = "resize to the down", group = "client" }),
	awful.key({ mod, ctrl }, "Left", function(c)
		helpers.client.resize_client(client.focus, "left")
	end, { description = "resize to the left", group = "client" }),
	awful.key({ mod, ctrl }, "Right", function(c)
		helpers.client.resize_client(client.focus, "right")
	end, { description = "resize to the right", group = "client" }),

	--- Bling
	--- ~~~~~

	--- Brightness Control

	awful.key({mod}, "F12", function()
		awful.spawn("brightnessctl set 5%+ -q", false)
		awesome.emit_signal("widget::brightness")
		awesome.emit_signal("module::brightness_osd:show", true)
	end, { description = "increase brightness", group = "hotkeys" }),

	awful.key({mod}, "F11", function()
		awful.spawn("brightnessctl set 5%- -q", false)
		awesome.emit_signal("widget::brightness")
		awesome.emit_signal("module::brightness_osd:show", true)
	end, { description = "decrease brightness", group = "hotkeys" }),

	--- Volume control

	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("amixer sset Master 5%+", false)
		awesome.emit_signal("widget::volume")
		awesome.emit_signal("module::volume_osd:show", true)
	end, { description = "increase volume", group = "hotkeys" }),

	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("amixer sset Master 5%-", false)
		awesome.emit_signal("widget::volume")
		awesome.emit_signal("module::volume_osd:show", true)
	end, { description = "decrease volume", group = "hotkeys" }),

	awful.key({}, "XF86AudioMute", function()
		awful.spawn("amixer sset Master toggle", false)
    --awesome.emit_signal("widget::volume")
    awesome.emit_signal("module::volume_osd:show",true)
	end, { description = "mute volume", group = "hotkeys" }),

	--- Screenshots
	awful.key({}, "Print", function()
		awful.spawn.easy_async_with_shell(apps.utils.full_screenshot, function() end)
	end, { description = "take a full screenshot", group = "hotkeys" }),

	awful.key({ alt }, "Print", function()
		awful.spawn.easy_async_with_shell(apps.utils.area_screenshot, function() end)
	end, { description = "take a area screenshot", group = "hotkeys" }),

	--- Lockscreen
	awful.key({ mod }, "l", function()
		lock_screen_show()
	end, { description = "lock screen", group = "hotkeys" }),

	--- Exit screen
	awful.key({ mod }, "x", function()
		awesome.emit_signal("module::exit_screen:show")
	end, { description = "exit screen", group = "hotkeys" }),
})

--- Client key bindings
--- ~~~~~~~~~~~~~~~~~~~
client.connect_signal("request::default_keybindings", function()

	awful.keyboard.append_client_keybindings({

		-- Move or swap by direction

		awful.key({ mod, shift }, "Up", function(c)
			helpers.client.move_client(c, "up")
		end),
		awful.key({ mod, shift }, "Down", function(c)
			helpers.client.move_client(c, "down")
		end),
		awful.key({ mod, shift }, "Left", function(c)
			helpers.client.move_client(c, "left")
		end),
		awful.key({ mod, shift }, "Right", function(c)
			helpers.client.move_client(c, "right")
		end),

		--- Toggle floating 
		awful.key({ mod, ctrl }, "space", awful.client.floating.toggle),

		--- Toggle fullscreen   
		awful.key({ mod }, "f", function()
			client.focus.fullscreen = not client.focus.fullscreen
			client.focus:raise()
		end),

		--- Close window
		awful.key({ mod }, "q", function()
			client.focus:kill()
		end),

		--- Center window
		awful.key({ mod }, "c", function()
			awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
		end),

		--- Window switcher
		awful.key({ alt }, "Tab", function()
			awesome.emit_signal("window_switcher::turn_on")
		end),
	})
end)

--- Move through workspaces
--- ~~~~~~~~~~~~~~~~~~~~~~~
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod },
		keygroup = "numrow",
		description = "only view tag",
		group = "tags",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { mod, shift },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tags",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
})

---- Mouse bindings on desktop
--- ~~~~~~~~~~~~~~~~~~~~~~~~~
local main_menu = require("ui.main-menu")
awful.mouse.append_global_mousebindings({
	--- Right click
	awful.button({
		modifiers = {},
		button = 3,
		on_press = function()
			main_menu:toggle()
		end,
	}),
})

awful.mouse.append_global_mousebindings({
	--- Left click
	awful.button({}, 1, function()
		naughty.destroy_all_notifications()
	end),

	--- Middle click
	awful.button({}, 2, function()
		awesome.emit_signal("central_panel::toggle", awful.screen.focused())
	end),
})

--- Mouse buttons on the client
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~~
client.connect_signal("request::default_mousebindings", function()
	awful.mouse.append_client_mousebindings({
		awful.button({}, 1, function(c)
			c:activate({ context = "mouse_click" })
		end),
		awful.button({ mod }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ mod }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end)
