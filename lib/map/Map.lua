--
-- Utilities to work with Tiled maps
--

Map = {}

-- 
-- Add all solid tiles to the collider
--
function Map:addSolidTilesToCollider(map, layerName)	
  	local w = map.tileWidth
	local h = map.tileHeight
    local collidable_tiles = {}
	
	-- Iterate over all tiles in a layer
	for x, y, tile in map(layerName):iterate() do
		if tile and tile.properties.solid then
			local ctile = collider:addRectangle(x*w, y*h, w, h)
			ctile.type = "tile"
			collider:addToGroup("tiles", ctile)
			collider:setPassive(ctile)
			table.insert(collidable_tiles, ctile)
   		end	   
	end
	
    return collidable_tiles
end