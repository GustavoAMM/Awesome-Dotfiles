local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local gears = require("gears")
local wibox = require("wibox")

--- Disable popup tooltip on titlebar button hover
awful.titlebar.enable_tooltip = true

local decorations = {}

	if beautiful.border_radius and beautiful.border_radius > 0 then
		client.connect_signal("manage", function(c, startup)
			if not c.fullscreen and not c.maximized then
				c.shape = helpers.ui.rrect(beautiful.border_radius)
			end
		end)

		--- Fullscreen and maximized clients should not have rounded corners
		local function no_round_corners(c)
			if c.fullscreen or c.maximized then
				c.shape = gears.shape.rectangle
			else
				c.shape = helpers.ui.rrect(beautiful.border_radius)
			end
		end

		client.connect_signal("property::fullscreen", no_round_corners)
		client.connect_signal("property::maximized", no_round_corners)

		beautiful.snap_shape = helpers.ui.rrect(beautiful.border_radius * 2)
	else
		beautiful.snap_shape = gears.shape.rectangle
	end


function decorations.init()
	--require("ui.decorations.titlebar")
	--require("ui.decorations.music")
end




return decorations
