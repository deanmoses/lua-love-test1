--
-- Paints background of game
--

Background = {}
 
-- Constructor
-- @param yFloor the y coord at which the sky ends and the ground begins
function Background:new(yFloor)
    -- define our parameters here
    local object = {
		yFloor = yFloor,
		bgSky = g.newImage("background/sky.jpg"),
		bgGround = g.newImage("background/ground.jpg"),
		treeLeafColor = {25, 200, 25},
		treeTrunkColor = {139, 69, 19}
    }
    setmetatable(object, { __index = Background })
    return object
end

function Background:draw()
	-- draw the sky
	g.draw(self.bgSky, 0, 0)
  
    -- draw the ground
	g.draw(self.bgGround, 0, self.yFloor)
	
    -- draw a tree!
	g.setColor(self.treeLeafColor)
    g.rectangle("fill", 725, 285, 125, 125)
    g.setColor(self.treeTrunkColor)
    g.rectangle("fill", 770, 410, 40, 90)
end