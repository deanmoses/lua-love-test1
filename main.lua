require "pig/Pig"
require "background/Background"
require "player/Player"

function love.load()
	g = love.graphics
	width = g.getWidth() -- width of window
	height = g.getHeight() -- height of window
	
	yFloor = 500 -- y position of the floor, where the player rests

	bg = Background:new(yFloor) -- Set up background
	player = Player:new(yFloor) -- Set up our player
	pig = Pig:new() -- Set up the pig
end

function love.update(dt)
    player:update(dt) -- update the player
end

function love.draw()
	bg:draw() -- draw the background
	player:draw() -- draw the player
	pig:draw() -- draw the pig
end
 
function love.keyreleased(key)
    if key == "escape" then
    	love.event.quit()
    end
	
	player:keyreleased(key)
end

-- Clamps a number to within a certain range
-- This adds the function to the built-in math package
function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end