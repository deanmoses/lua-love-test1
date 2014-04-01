require "lib.spriteanimation.SpriteAnimation"
require "gamestates.game.bullets.Bullets"

Player = {}
 
-- Constructor
function Player:new(intitialX, initialY)
    -- define our parameters here
    local object = {
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
		gravity = 1800,--1800,
		hasJumped = false,
		delay = 120,
		bullets = { },
		bullets = Bullets:new(),
		-- Load player animation
		animation = SpriteAnimation:new("gamestates/game/player/robosprites.png", 32, 32, 4, 4)
    }
    setmetatable(object, { __index = Player })
	
	object.animation:load(object.delay)
	
	-- add the player to the collider
	object.playerShape = collider:addRectangle(intitialX + (object.width/2), initialY + (object.height/2), object.width, object.height)
		
    return object
end

function Player:update(dt, gravity, map)
	--print("Player:update onFloor: " .. tostring(self.onFloor))
	
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
		self:fire()
	end
	
	--
    -- update the player's speed and position
	--
	
    -- apply gravity
    self.ySpeed = self.ySpeed + (self.gravity * dt)
 	
	-- limit the player's speed
	self.xSpeed = math.clamp(self.xSpeed, -self.xSpeedMax, self.xSpeedMax)
	self.ySpeed = math.clamp(self.ySpeed, -self.ySpeedMax, self.ySpeedMax)
	
	-- set player's position
	local nextY = math.floor(self:y() + (self.ySpeed * dt))
	local nextX = math.floor(self:x() + (self.xSpeed * dt))
	
	--print("x: "..self:x().." y: "..self:y().." xAccel: "..(self.xSpeed * dt).." nextX: "..nextX)
	
	
	-- only do the move if the player's position has actually changed
	if (self:x() ~= nextX or self:y() ~= nextY) then
		-- print("x: "..self:x()..", nextX: "..nextX.." y: "..self:y()..", nextY: "..nextY)
		
		if (self:y() < nextY) then
			-- if I'm moving downwards, turn onFloor to false
			-- onFloor will be turned back to true if there is a collision when moving down
			--self.onFloor = false
		end
		
		self:moveTo(nextX, nextY)
	end
	
	--
	-- update dependent objects
	--
	
	-- update the player's animation
	self:updateAnimation(dt)
	
	-- update the player's bullets
	self.bullets:update(dt)
end

-- Do various things when the player hits a tile
function Player:on_collide(mtv_x, mtv_y)
	--print("Player:on_collide("..mtv_x..", "..mtv_y..")")
	
	-- i'm getting a lot of zero x,y in collide(). ignore them
	if (not(mtv_x > 0 or mtv_x < 0 or mtv_y > 0 or mtv_y < 0)) then
		--print("zero x,y.  not moving: "..mtv_x..","..mtv_y)
		return
	end
	
	-- collided with floor
    if mtv_y < 0 then
        self.ySpeed = 0
        self.onFloor = true
	-- collided with ceiling
    elseif mtv_y > 0 then
        self.ySpeed = 0
    end
	
	-- collided right into wall
    if mtv_x < 0 then
		--print("stopped against right wall")
        self.xSpeed = 0	
	-- collided left into wall
    elseif mtv_x > 0 then
		--print("stopped against left wall")
        self.xSpeed = 0
    end

	-- move player out of tile
	if (mtv_x > 0 or mtv_x < 0 or mtv_y > 0 or mtv_y < 0) then
		--print("collided.  moving: "..mtv_x..","..mtv_y)
		self:move(mtv_x, mtv_y)
	end
end

function Player:updateAnimation(dt)
	--
    -- update the player's state
	--
	
	self.state = self:getState()
	--print("Player:updateAnimation() state: " .. self.state)
	
	--
    -- update the sprite animation
	--
	
    if (self.state == "stand") then
		--print("Player:updateAnimation(): stand")
        self.animation:switch(1, 4, 200)
    end
    if (self.state == "moveRight") or (self.state == "moveLeft") then
		--print("Player:updateAnimation(): moveRight or Left")
        self.animation:switch(2, 4, 120)
    end
    if (self.state == "jump") or (self.state == "fall") then
		--print("Player:updateAnimation(): jump or fall")
        self.animation:reset()
        self.animation:switch(3, 1, 300)
    end
    self.animation:update(dt)	
	
end

function Player:draw()
    -- round down our x, y values
    local x = math.floor(self:x())
    local y = math.floor(self:y())
	
	-- draw the player's shape in the collider, for debugging
	--self.playerShape:draw("fill")
	
	-- draw the player
    g.setColor(255, 255, 255)
	local x1,y1, x2,y2 = self.playerShape:bbox()
    self.animation:draw(x1, y1)
	
	-- draw the bullets
	self.bullets:draw();
end

function Player:keyreleased(key)
    if (key == "right") or (key == "left") then
        self:stopX()
    end
	if (key == "x") then
        self.hasJumped = false
    end	
end

function Player:jump()
    if self.onFloor then
		--print("jump!")
        self.ySpeed = self.jumpSpeed
        self.onFloor = false
	else
		--print("not on floor, can't jump")
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
 
function Player:stopX()
    self.xSpeed = 0
end

function Player:fire()
	local targetX, targetY = love.mouse.getPosition()
	self.bullets:fire(self:x(), self:y(), targetX, targetY)
end

function Player:center()
	return self.playerShape:center()	
end

function Player:x()
	local x,y = self.playerShape:center()
	return x
end

function Player:y()
	local x,y = self.playerShape:center()
	return y
end

function Player:move(x, y)
	self.playerShape:move(x,y)
end

function Player:moveTo(x, y)
	self.playerShape:moveTo(x,y)
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
	elseif self.ySpeed < 0 then
        myState = "jump"
    elseif self.ySpeed >= 0 then
        myState = "fall"
    end
    return myState
end