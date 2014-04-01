--
-- The main game
--
Collider = require "lib.hardoncollider" -- collision detection library
require "lib.camera.camera"
require "lib.map.Map"
require "gamestates.game.background.Background"
require "gamestates.game.player.Player"
require "gamestates.game.coin.Coins"

Game = {}

function Game:enter()
	-- load the map
    local loader = require("lib.AdvTiledLoader.Loader")
    loader.path = "maps/"
    map = loader.load("map01.tmx")
    map:setDrawRange(0, 0, map.width * map.tileWidth, map.height * map.tileHeight)

	
	-- load HardonCollider, set callback to on_collide and size of 100
	collider = Collider.new(150, on_collide)
	
	-- add all the tiles that we can collide with to the collider
	Map:addSolidTilesToCollider(map, "Walls")
	
	-- set up the game objects
	bg = Background:new() -- Set up background
	player = Player:new(300, 300) -- Set up the player
	coins = Coins:new(map, player) -- Set up the coins
	
	-- add all the coins to collision detection
	coins:addCoinsToCollider()
		
    -- restrict the area in which the camera can move
    camera:setBounds(0, 0, map.width * map.tileWidth - width, map.height * map.tileHeight - height)   
end

function Game:update(dt)
	-- update the player
	player:update(dt)
	
    -- update coins
	coins:update(dt)
	
	-- update collision detection
	collider:update(dt)
	
    -- center the camera on the player
    camera:setPosition(math.floor(player:x() - width / 2), math.floor(player:y()- height / 2))
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
    local tileX = math.floor(player:x() / map.tileWidth)
    local tileY = math.floor(player:y() / map.tileHeight)
    g.print("Player x,y: ("..player:x()..","..player:y()..")", 5, 5)
    g.print("Player state: "..player.state..", on floor: " ..tostring(player.onFloor), 5, 20)
	g.print("Player tile: ("..tileX..", "..tileY..")", 5, 35)
	--g.print("Player speed: ("..player.xSpeed..","..player.ySpeed..")", 5, 50)
end
 
function Game:keyreleased(key)
    if key == "escape" then
    	love.event.quit()
    end
	
	player:keyreleased(key)
end

-- callback for hardon collider, letting us know that
-- two things have collided
function on_collide(dt, shape_a, shape_b, mtv_x, mtv_y)
    -- figure out which shape is our player
	local other_shape
	if shape_a == player.playerShape then
		other_shape = shape_b
	elseif shape_b == player.playerShape then
		other_shape = shape_a
	else
		--print("Game.on_collide(): neither shape is player")
        return
    end
	
	if other_shape.type == "tile" then
		player:on_collide(mtv_x, mtv_y)
	elseif other_shape.type == "coin" then
		coins:collect(other_shape)
	else
		--print("Game.on_collide(): unknown type of other shape")
        return
	end	
end