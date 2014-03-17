--
-- The main game
--
require "libs.camera"
require "gamestates.game.background.Background"
require "gamestates.game.player.Player"
require "gamestates.game.coin.Coins"

Game = {}

function Game:enter()
	-- load the map
    local loader = require("libs.AdvTiledLoader.Loader")
    loader.path = "maps/"
    map = loader.load("map01.tmx")
    map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)
	
	-- set up the game objects
	bg = Background:new() -- Set up background
	player = Player:new() -- Set up the player
	coins = Coins:new(map, player) -- Set up the coins

    -- restrict the camera
    camera:setBounds(0, 0, map.width * map.tileWidth - width, map.height * map.tileHeight - height)   
end

function Game:update(dt)
	-- update the player's position and check for collisions with map
	player:update(dt, gravity, map)
	
    -- update coin animations and check for collisions with player
	coins:update(dt)
	
    -- center the camera on the player
    camera:setPosition(math.floor(player.x - width / 2), math.floor(player.y - height / 2))
end

function Game:draw()
	-- camera:set() takes a snapshot of the camera's position. 
	-- From that point on, it's as if we're subtracting the camera's  
	-- x and y values from the coordinates of everything we draw on screen. 
	-- This means that even if the world is larger than the screen area, 
	-- we don't have to do any kind of operations on the numbers to draw 
	-- them in their proper positions.
	camera:set()
	bg:draw() -- draw the background
	map:draw() -- draw the map
	coins:draw() -- draw the coins
	player:draw() -- draw the player
	camera:unset()
	
	-- draw the score
	g.setColor(255, 255, 255)
	local font = g.newFont("fonts/orangejuice20.ttf", 24) 
	g.setFont(font)	
	love.graphics.print("Score: "..coins:getScore(), 700, 5)
	
	-- debugging
	local font = g.newFont(12) 
	g.setFont(font)	
	g.setColor(255, 255, 255)
    local tileX = math.floor(player.x / map.tileWidth)
    local tileY = math.floor(player.y / map.tileHeight)
    g.print("Player coordinates: ("..player.x..","..player.y..")", 5, 5)
    g.print("Player state: "..player.state, 5, 20)
	g.print("Player tile: ("..tileX..", "..tileY..")", 5, 35)
end
 
function Game:keyreleased(key)
	player:keyreleased(key)
end