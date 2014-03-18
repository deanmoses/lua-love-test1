require "lib.spriteanimation.SpriteAnimation"
require "gamestates.game.bullets.Bullets"

Player = {}
 
-- Constructor
function Player:new()
    -- define our parameters here
    local object = {
	    x = 300,
	    y = 300,
	    width = 32,
	    height = 32,
	    xSpeed = 0,
	    ySpeed = 0,
		-- xSpeedMax, ySpeedMax: the player's max velocity. Because the player can fall long distances and be accelerated by gravity the whole time, we must make sure his speed doesn't exceed these maximums. If they do, then the player would be moving too fast for our collision detection to keep up. If the player moves more than one tile of distance in between cycles, that's bad. So the maximum values prevent this. onFloor now takes the place of the canJump boolean, so we can trim that out as well.
		xSpeedMax = 800, 
		ySpeedMax = 800,
	    state = "", -- "moveRight", "moveLeft", "jump", "fall", "stand"
	    jumpSpeed = -800,
	    runSpeed = 500,
	    onFloor = false, -- true: player is at a resting state where they aren't falling
		gravity = 1800,
		hasJumped = false,
		delay = 120,
		bullets = { },
		bullets = Bullets:new(),
		-- Load player animation
		animation = SpriteAnimation:new("gamestates/game/player/robosprites.png", 32, 32, 4, 4)
    }
    setmetatable(object, { __index = Player })
	
	object.animation:load(object.delay)
	
    return object
end

function Player:jump()
    if self.onFloor then
        self.ySpeed = self.jumpSpeed
        self.onFloor = false
    end
end
 
function Player:moveRight()
    self.xSpeed = self.runSpeed
    self.state = "moveRight"
	self.animation:flip(false, false)
end
 
function Player:moveLeft()
    self.xSpeed = -1 * (self.runSpeed)
    self.state = "moveLeft"
	self.animation:flip(true, false)
end
 
function Player:stop()
    self.xSpeed = 0
end
 
-- Do various things when the player hits a tile
function Player:collide(event)
    if event == "floor" then
        self.ySpeed = 0
        self.onFloor = true
    end
    if event == "ceiling" then
        self.ySpeed = 0
    end
end

function Player:fire()
	local targetX, targetY = love.mouse.getPosition()
	self.bullets:fire(self.x, self.y, targetX, targetY)
end

function Player:update(dt, gravity, map)
	
	--
    -- check controls
	--
	
	-- move right
    if love.keyboard.isDown("right") then
        self:moveRight()
    end
	-- move left
    if love.keyboard.isDown("left") then
        self:moveLeft()
    end
	-- jump
    if love.keyboard.isDown("x") and not(self.hasJumped) then
        self.hasJumped = true
        self:jump()
    end
	-- fire
	if love.keyboard.isDown(" ") then
		self.bullets:fire(self.x, self.y, self.direction)
	end
	
	--
    -- update the player's speed and position
	--
	
    -- apply gravity
    self.ySpeed = self.ySpeed + (self.gravity * dt)
 
	-- limit the player's speed
	self.xSpeed = math.clamp(self.xSpeed, -self.xSpeedMax, self.xSpeedMax)
	self.ySpeed = math.clamp(self.ySpeed, -self.ySpeedMax, self.ySpeedMax)
	
	-- calculate vertical position and adjust if needed
	local nextY = math.floor(self.y + (self.ySpeed * dt))
	
	local halfX = self.width / 2
	local halfY = self.height / 2
	
	if self.ySpeed < 0 then -- check upward
        if not(self:isColliding(map, self.x - halfX, nextY - halfY))
            and not(self:isColliding(map, self.x + halfX - 1, nextY - halfY)) then
            -- no collision, move normally
            self.y = nextY
            self.onFloor = false
        else
            -- collision, move to nearest tile border
            self.y = nextY + map.tileHeight - ((nextY - halfY) % map.tileHeight)
            self:collide("ceiling")
        end			
    elseif self.ySpeed > 0 then -- check downward
        if not(self:isColliding(map, self.x - halfX, nextY + halfY))
            and not(self:isColliding(map, self.x + halfX - 1, nextY + halfY)) then
            -- no collision, move normally
            self.y = nextY
            self.onFloor = false
        else
            -- collision, move to nearest tile border
            self.y = nextY - ((nextY + halfY) % map.tileHeight)
            self:collide("floor")
        end
    end
			
    -- calculate horizontal position and adjust if needed
    local nextX = math.floor(self.x + (self.xSpeed * dt))
    if self.xSpeed > 0 then -- check right
        if not(self:isColliding(map, nextX + halfX, self.y - halfY))
            and not(self:isColliding(map, nextX + halfX, self.y + halfY - 1)) then
            -- no collision
            self.x = nextX
        else
            -- collision, move to nearest tile
            self.x = nextX - ((nextX + halfX) % map.tileWidth)
        end
    elseif self.xSpeed < 0 then -- check left
        if not(self:isColliding(map, nextX - halfX, self.y - halfY))
            and not(self:isColliding(map, nextX - halfX, self.y + halfY - 1)) then
            -- no collision
            self.x = nextX
        else
            -- collision, move to nearest tile
            self.x = nextX + map.tileWidth - ((nextX - halfX) % map.tileWidth)
        end
    end
	
	--
    -- update the player's state
	--
	
	self.state = self:getState()
	
	--
    -- update the sprite animation
	--
	
    if (self.state == "stand") then
        self.animation:switch(1, 4, 200)
    end
    if (self.state == "moveRight") or (self.state == "moveLeft") then
        self.animation:switch(2, 4, 120)
    end
    if (self.state == "jump") or (self.state == "fall") then
        self.animation:reset()
        self.animation:switch(3, 1, 300)
    end
    self.animation:update(dt)
	
	--
	-- update the bullets
	--
	self.bullets:update(dt)
end

function Player:draw()
    -- round down our x, y values
    local x = math.floor(self.x)
    local y = math.floor(self.y)
	
	-- draw the player
    g.setColor(255, 255, 255)
    self.animation:draw(x, y)
	
	-- draw the bullets
	self.bullets:draw();
end

function Player:keyreleased(key)
    if (key == "right") or (key == "left") then
        self:stop()
    end
	if (key == "x") then
        self.hasJumped = false
    end	
end

-- returns player's state as a string
function Player:getState()
    local myState = ""
    if self.onFloor then
        if self.xSpeed > 0 then
            myState = "moveRight"
        elseif self.xSpeed < 0 then
            myState = "moveLeft"
        else
            myState = "stand"
        end
    end
    if self.ySpeed < 0 then
        myState = "jump"
    elseif self.ySpeed > 0 then
        myState = "fall"
    end
    return myState
end

--
-- returns true if the given coordinates given intersect a tile on the given map
--
function Player:isColliding(map, x, y)
	-- Convert the game world x and y (measured in pixels), to the map's x and y (measured in tiles) by dividing the x and y by the map's tile sizes and then round off the decimals. 
	local tileX, tileY = math.floor(x / map.tileWidth), math.floor(y / map.tileHeight)
   
	-- Grab the tile at given point.  If there's no tile at those coordinates, this will return nil.
	local tile = map("Walls")(tileX, tileY)

	-- Return true if the point overlaps a solid tile.
	return not(tile == nil)
end