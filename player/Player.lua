require "player/SpriteAnimation"

Player = {}
 
-- Constructor
function Player:new(yFloor)
    -- define our parameters here
    local object = {
	    x = 300,
	    y = 300,
	    width = 32,
	    height = 32,
	    xSpeed = 0,
	    ySpeed = 0,
	    state = "", -- "moveRight", "moveLeft", "jump", "fall", "stand"
	    jumpSpeed = -800,
	    runSpeed = 500,
	    canJump = false, -- means player is at a resting state where they aren't falling
		gravity = 1800,
		hasJumped = false,
		delay = 120,
		yFloor = yFloor,
		-- Load player animation
		animation = SpriteAnimation:new("player/robosprites.png", 32, 32, 4, 4)
    }
    setmetatable(object, { __index = Player })
	
	object.animation:load(object.delay)
	
    return object
end

function Player:jump()
    if self.canJump then
        self.ySpeed = self.jumpSpeed
        self.canJump = false
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
 
function Player:hitFloor(maxY)
    self.y = maxY - self.height
    self.ySpeed = 0
    self.canJump = true
end

function Player:update(dt)
    -- check controls
    if love.keyboard.isDown("right") then
        self:moveRight()
    end
    if love.keyboard.isDown("left") then
        self:moveLeft()
    end
    if love.keyboard.isDown("x") and not(self.hasJumped) then
        self.hasJumped = true
        self:jump()
    end
	
    -- update the player's position
    self.x = self.x + (self.xSpeed * dt)
    self.y = self.y + (self.ySpeed * dt)
 
    -- apply gravity
    self.ySpeed = self.ySpeed + (self.gravity * dt)
 
    -- update the player's state
    if self.canJump then
        if self.xSpeed > 0 then
            self.state = "moveRight"
        elseif self.xSpeed < 0 then
            self.state = "moveLeft"
        else
            self.state = "stand"
        end
	else
        if self.ySpeed < 0 then
            self.state = "jump"
        elseif self.ySpeed > 0 then
            self.state = "fall"
        end
    end
	
    -- stop the player when they hit the borders
    self.x = math.clamp(self.x, 0, width - self.width)
    if self.y < 0 then self.y = 0 end
    if self.y > self.yFloor - self.height then
        self:hitFloor(self.yFloor)
    end
	
    -- update the sprite animation
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
end

function Player:draw()
    -- round down our x, y values
    local x = math.floor(self.x)
    local y = math.floor(self.y)
	
	-- draw the player
    g.setColor(255, 255, 255)
    self.animation:draw(x, y)
 
    -- debug information
    g.setColor(255, 255, 255)
    g.print("Player coordinates: ("..x..","..y..")", 5, 5)
    g.print("Current state: "..self.state, 5, 20)
end

function Player:keyreleased(key)
    if (key == "right") or (key == "left") then
        self:stop()
    end
	if (key == "x") then
        self.hasJumped = false
    end	
end