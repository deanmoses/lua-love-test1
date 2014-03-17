--
-- Represents a stream of bullets
--
-- Most of the code comes from the bullet tutorial at:
-- http://yal.cc/love2d-shooting-things/
--

Bullets = {}

-- Constructor
-- @param yFloor the y coord at which the sky ends and the ground begins
function Bullets:new(yFloor)
    -- define our parameters here
    local object = {
	    x = 300,
	    y = 300,
	    xSpeed = 0,
	    ySpeed = 0,
		bullets = { },
		heat = 0, -- how much time should pass before player can shoot again
		heatp = 0.1, -- length of such intervals in general (before player can shoot again) (heatPlus)
		yFloor = yFloor
    }
    setmetatable(object, { __index = Bullets })	
    return object
end

function Bullets:fire(sourceX, sourceY, targetX, targetY)
	if targetY == nil then targetY = love.mouse.getY() end
	if targetX == nil then targetX = love.mouse.getX() end
	
	if self.heat <= 0 then
		local direction = math.atan2(targetY - sourceY, targetX - sourceX)
		table.insert(self.bullets, {
			x = sourceX,
			y = sourceY,
			dir = direction,
			speed = 400
		})
		self.heat = self.heatp
	end
end

function Bullets:update(dt)
	self.heat = math.max(0, self.heat - dt)
	
	-- to understand, see http://yal.cc/love2d-shooting-things/
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

function Bullets:draw()
	love.graphics.setColor(255, 255, 255, 224)
	local i, o
	for i, o in ipairs(self.bullets) do
		love.graphics.circle('fill', o.x, o.y, 10, 8)
	end 
end