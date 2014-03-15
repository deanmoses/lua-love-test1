require "pig/Pig"
require "background/Background"
require "player/Player"

function love.load()
    g = love.graphics
	width = g.getWidth() -- width of window
	height = g.getHeight() -- height of window
	g.setBackgroundColor(85, 85, 85)
	
	yFloor = 500 -- y position of the floor, where the player rests
	
	-- Set up background
	bg = Background:new(yFloor)
	
    -- Set up our player
    p = Player:new(yFloor)
	
	-- Set up the pig
	pig = Pig:new()
end

function love.update(dt)
    p:update(dt) -- update the player
end

function love.draw()
	bg:draw() -- draw the background
	p:draw() -- draw the player
	pig:draw() -- draw the pig
end
 
function love.keyreleased(key)
    if key == "escape" then
    	love.event.quit()
    end
	
	p:keyreleased(key)
end

-- add a useful function to the built-in math package
function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end