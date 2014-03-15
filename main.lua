require "background/Background"
require "player/Player"
require "player/SpriteAnimation"
--require "camera"

function love.load()
    g = love.graphics
	
	-- load background images
	pig = g.newImage("pig.png")
	
	
	width = g.getWidth()
	height = g.getHeight()
	g.setBackgroundColor(85, 85, 85)
	
	yFloor = 500
	
	-- Set up background
	bg = Background:new(yFloor)

	-- Load player animation
	animation = SpriteAnimation:new("player/robosprites.png", 32, 32, 4, 4)
	animation:load(delay)
		
    playerColor = {255,0,128}
 
 
    -- instantiate our player and set initial values
    p = Player:new()
 
    p.x = 300
    p.y = 300
    p.width = 32
	p.height = 32
	p.jumpSpeed = -800
	p.runSpeed = 500

	gravity = 1800
	hasJumped = false
	delay = 120
end

function love.update(dt)
    -- check controls
    if love.keyboard.isDown("right") then
        p:moveRight()
        animation:flip(false, false)
    end
    if love.keyboard.isDown("left") then
        p:moveLeft()
        animation:flip(true, false)
    end
    if love.keyboard.isDown("x") and not(hasJumped) then
        hasJumped = true
        p:jump()
    end
 
    -- update the player's position
    p:update(dt, gravity)
 
    -- stop the player when they hit the borders
    p.x = math.clamp(p.x, 0, width * 2 - p.width)
    if p.y < 0 then p.y = 0 end
    if p.y > yFloor - p.height then
        p:hitFloor(yFloor)
    end
 
    -- update the sprite animation
    if (p.state == "stand") then
        animation:switch(1, 4, 200)
    end
    if (p.state == "moveRight") or (p.state == "moveLeft") then
        animation:switch(2, 4, 120)
    end
    if (p.state == "jump") or (p.state == "fall") then
        animation:reset()
        animation:switch(3, 1, 300)
    end
    animation:update(dt)
end

function love.draw()
	bg:draw()
	
    -- round down our x, y values
    local x = math.floor(p.x)
    local y = math.floor(p.y)
	
	-- draw the player
    g.setColor(255, 255, 255)
    animation:draw(x, y)
		
	-- draw pig
	g.setColor(255, 255, 255)
	g.draw(pig, 200, 200, 0, .5, .5)
 
    -- debug information
    g.setColor(255, 255, 255)
    g.print("Player coordinates: ("..x..","..y..")", 5, 5)
    g.print("Current state: "..p.state, 5, 20)
end
 
function love.keyreleased(key)
    if key == "escape" then
    	love.event.quit()
    end
    if (key == "right") or (key == "left") then
        p:stop()
    end
	if (key == "x") then
        hasJumped = false
    end
end

function math.clamp(x, min, max)
    return x < min and min or (x > max and max or x)
end