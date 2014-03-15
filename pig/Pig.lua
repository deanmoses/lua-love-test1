--
-- A pig
--

Pig = {}
 
-- Constructor
function Pig:new()
    -- define our parameters here
    local object = {
		pig = g.newImage("pig/pig.png"),
		pigBgColor = {255, 255, 255},
		x = 200,
		y = 200,
		scale = .5, -- how big the pig is relative to the original pig image
		rotation = 0 -- how much to rotate the pig
    }
    setmetatable(object, { __index = Pig })
    return object
end

function Pig:draw()
	-- draw pig
	g.setColor(self.pigBgColor)
	g.draw(self.pig, self.x, self.y, self.rotation, self.scale, self.scale)	
end