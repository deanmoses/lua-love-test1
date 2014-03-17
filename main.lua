require "background/Background"
require "player/Player"
require "libs/camera"

function love.load()
	g = love.graphics
	width = g.getWidth() -- width of window
	height = g.getHeight() -- height of window
	
	yFloor = 500 -- y position of the floor, where the player rests

	bg = Background:new() -- Set up background
	player = Player:new(yFloor) -- Set up the player
	
	-- Load up the map
    loader = require("libs.AdvTiledLoader.Loader")
    loader.path = "maps/"
    map = loader.load("map01.tmx")
    map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)

    -- restrict the camera
    camera:setBounds(0, 0, map.width * map.tileWidth - width, map.height * map.tileHeight - height)
end

function love.update(dt)
	-- update the player's position and check for collisions
	player:update(dt, gravity, map)
	
    -- center the camera on the player
    camera:setPosition(math.floor(player.x - width / 2), math.floor(player.y - height / 2))
end

function love.draw()
	-- camera:set() takes a snapshot of the camera's position. 
	-- From that point on, it's as if we're subtracting the camera's  
	-- x and y values from the coordinates of everything we draw on screen. 
	-- This means that even if the world is larger than the screen area, 
	-- we don't have to do any kind of operations on the numbers to draw 
	-- them in their proper positions.
	camera:set()
	bg:draw() -- draw the background
	map:draw() -- draw the map
	player:draw() -- draw the player
	camera:unset()
		
	-- debugging
    local tileX = math.floor(player.x / map.tileWidth)
    local tileY = math.floor(player.y / map.tileHeight)
	love.graphics.print("Current tile: ("..tileX..", "..tileY..")", 5, 35)
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