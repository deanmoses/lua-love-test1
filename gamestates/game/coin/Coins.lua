--
-- all the coins on the map
--

require "gamestates.game.coin.Coin"

Coins = {}
 
-- Constructor
function Coins:new(map, player, spriteAnimationDelay, numCoins)
    local object = {
		coins,
		coinSprites,
		map = map,
		player = player,
		score = 0
    }
    setmetatable(object, { __index = Coins } )
	
    -- create coin animation
   object.coinSprites = SpriteAnimation:new("gamestates/game/coin/coin.png", 32, 32, 20, 1)
   object.coinSprites:load(spriteAnimationDelay)
   
	-- place randomly generated coins around the map
	object:placeCoins(numCoins)
	
    return object
end

-- Add coins to the collision detection system
function Coins:addCoinsToCollider()
    for i in ipairs(self.coins) do
		local coin = self.coins[i]
		local shape = collider:addCircle(coin.x, coin.y, coin.width)
		shape.type = "coin"
		shape.coin = coin
		collider:addToGroup("coins", shape)
		collider:setPassive(ctile)
    end
end

-- Player has collided with coin. 
-- Remove coin, increment score
function Coins:collect(coinShape)
    for i in ipairs(self.coins) do
        if coinShape.coin == self.coins[i] then
			-- increment score
			self.score = self.score + 1
			
			-- remove from list of coins
			table.remove(self.coins, i)
			
			-- remove from collider
			collider:remove(coinShape)
			return
		end
    end
end

-- Update all coin animations
function Coins:update(dt)
    for i in ipairs(self.coins) do
        self.coins[i]:update(dt)
    end
end

-- Draw all coins
function Coins:draw()
    for i in ipairs(self.coins) do
        self.coinSprites:start(self.coins[i].frame)
        self.coinSprites:draw(self.coins[i].x - self.coins[i].width / 2, self.coins[i].y - self.coins[i].height / 2)
    end
end

-- Get game score (# coins collected by player)
function Coins:getScore()
	return self.score
end

-- Place random coins around the map
function Coins:placeCoins(numCoins)	
   math.randomseed(os.time())
   numCoins = numCoins or 25
   self.coins = {}
   for i = 1, numCoins do
       local coinCollides = true
       while coinCollides do -- try to place a coin on a random spot around the map
           local coinX = math.random(1, self.map.width - 1) * self.map.tileWidth + self.map.tileWidth / 2
           local coinY = math.random(1, self.map.height - 1) * self.map.tileHeight + self.map.tileHeight / 2
           self.coins[i] = Coin:new(coinX, coinY)
       		   
           -- if tile is occupied, try again
           coinCollides = self.coins[i]:isColliding(self.map)
       end
   end
end