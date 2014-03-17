coin = {}
 
-- Constructor
function coin:new(coinX, coinY)
    local object = {
    x = coinX,
    y = coinY,
    width = 32,
    height = 32,
    frame = math.random(1,20),
    delay = 200,
    delta = 0,
    maxDelta = 10
    }
    setmetatable(object, { __index = coin } )
    return object
end

function coin:update(dt)
    self.delta = self.delta + self.delay * dt
   
    -- if maxDelta is reached, advance one frame
    if self.delta >= self.maxDelta then
        self.frame = self.frame % 20 + 1
        self.delta = 0
    end
end

-- returns true if the tile given is empty
function coin:isColliding(map)
    -- get tile coordinates
    local tileX, tileY = math.floor(self.x / map.tileWidth), math.floor(self.y / map.tileHeight)
   
    -- grab the tile, if any, at given point in Walls layer of tilemap
	local tile = map("Walls")(tileX, tileY)
   
    -- return true if the point overlaps a solid tile
    return not(tile == nil)
end

-- returns true if the object intersects this coin
function coin:touchesObject(object)
    local cx1, cx2 = self.x - self.width / 2, self.x + self.width / 2 - 1
    local cy1, cy2 = self.y - self.height / 2, self.y + self.height / 2 - 1
    local px1, px2 = object.x - object.width / 2, object.x + object.width / 2 - 1
    local py1, py2 = object.y - object.height / 2, object.y + object.height / 2 - 1
   
    return ((cx2 >= px1) and (cx1 <= px2) and (cy2 >= py1) and (cy1 <= py2))
end

-- Place random coins around the map
function placeCoins(map, numCoins)	
   math.randomseed(os.time())
   numCoins = numCoins or 25
   coins = {}
   for i = 1, numCoins do
       local coinCollides = true
       while coinCollides do -- try to place a coin on a random spot around the map
           local coinX = math.random(1, map.width - 1) * map.tileWidth + map.tileWidth / 2
           local coinY = math.random(1, map.height - 1) * map.tileHeight + map.tileHeight / 2
           coins[i] = coin:new(coinX, coinY)
       
           -- if tile is occupied, try again
           coinCollides = coins[i]:isColliding(map)
       end
   end	
end