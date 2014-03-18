tween = require 'lib.tween.tween'
Gamestate = require "lib.Hump.gamestate"
require "gamestates.game.Game"
require "gamestates.menu.Menu"

function love.load()
	g = love.graphics
	width = g.getWidth() -- width of window
	height = g.getHeight() -- height of window
	
	Gamestate.registerEvents()
	Gamestate.switch(Menu)
end

function love.update(dt)
	
end

function love.keyreleased(key)
    if key == "escape" then
    	love.event.quit()
    end
end

function p(o)
	local inspect = require("lib.inspect.inspect")
	print(inspect(o))	
end

-- Clamps a number to within a certain range
-- This adds the function to the built-in math package
function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end