--
-- Paints background of game
--

Background = {}
 
-- Constructor
function Background:new(yFloor)
    -- define our parameters here
    local object = {
		yFloor = yFloor, -- the y coord at which the sky ends and the ground begins
		bgSky = g.newImage("background/sky.jpg"),
		bgGround = g.newImage("background/ground.jpg"),
		groundColor = {25, 200, 25},
		trunkColor = {139, 69, 19}
    }
    setmetatable(object, { __index = Background })
    return object
end

function Background:draw()
	-- draw the sky
	g.draw(self.bgSky, 0, 0)
  
    -- draw the ground
    g.setColor(self.groundColor)
    g.rectangle("fill", 0, self.yFloor, 800, 100)
	g.draw(self.bgGround, 0, self.yFloor)
	
    -- draw a tree!
    g.rectangle("fill", 725, 285, 125, 125)
    g.setColor(self.trunkColor)
    g.rectangle("fill", 770, 410, 40, 90)
end