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
	    canJump = false, -- true: player is at a resting state where they aren't falling
		gravity = 1800,
		hasJumped = false,
		delay = 120,
		bullets = { },
		heat = 0, -- how much time should pass before player can shoot again
		heatp = 0.1, -- length of such intervals in general (before player can shoot again) (heatPlus)
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
	self.heat = math.max(0, self.heat - dt)
	
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
	if love.keyboard.isDown(" ") and self.heat <= 0 then
		local direction = math.atan2(love.mouse.getY() - self.y, love.mouse.getX() - self.x)
		table.insert(self.bullets, {
			x = self.x,
			y = self.y,
			dir = direction,
			speed = 400
		})
		self.heat = self.heatp
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
	
	-- update the bullets
	local i, o
	for i, o in ipairs(self.bullets) do
		o.x = o.x + math.cos(o.dir) * o.speed * dt
		o.y = o.y + math.sin(o.dir) * o.speed * dt
		if (o.x < -10) or (o.x > love.graphics.getWidth() + 10)
		or (o.y < -10) or (o.y > love.graphics.getHeight() + 10) then
			table.remove(self.bullets, i)
		end
	end
end

function Player:draw()
    -- round down our x, y values
    local x = math.floor(self.x)
    local y = math.floor(self.y)
	
	-- draw the player
    g.setColor(255, 255, 255)
    self.animation:draw(x, y)
	
	-- draw the bullets
	love.graphics.setColor(255, 255, 255, 224)
	local i, o
	for i, o in ipairs(self.bullets) do
		love.graphics.circle('fill', o.x, o.y, 10, 8)
	end
 
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