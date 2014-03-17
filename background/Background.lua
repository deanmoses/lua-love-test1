--
-- Paints background of game
--

Background = {}
 
-- Constructor
-- @param yFloor the y coord at which the sky ends and the ground begins
function Background:new()
    -- define our parameters here
    local object = {
		bgSky = g.newImage("background/sky.jpg")
    }
    setmetatable(object, { __index = Background })
    return object
end

function Background:draw()
	-- draw the sky
	g.draw(self.bgSky, 0, 0)
end