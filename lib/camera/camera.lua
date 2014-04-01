--
--  This is the camera library from BlackBulletIV's camera tutorials,
--
--  The camera controls which portion of the game world is rendered to screen
--
-- Add the following to love.load(), after the animations are loaded:
--
--    camera:setBounds(0, 0, width, math.floor(height / 8))
--
-- To figure out the bounds for our camera (or anything, for that matter), we look at the maximum possible values for it. 
-- When the camera is resting in the corner, as shown, the value of the camera's x-coordinate will be the map width minus the display width. Since our world is twice as long as the screen width, our camera should stop when it hits (width * 2) - width, or just width for short.
-- The height bounds are set to be one eighth of the display height: our world is only going to be one screen high anyway, so this will give the camera just enough "wiggle" that we feel like we're jumping. See? Not too intimidating after all.
-- 
-- more info:
-- http://www.explodingrabbit.com/forum/entries/l%C3%B6ve-platform-game-programming-tutorial-03-5.718/

camera = {}
camera._x = 0
camera._y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
 
function camera:set()
  love.graphics.push()
  love.graphics.rotate(-self.rotation)
  love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
  love.graphics.translate(-self._x, -self._y)
end
 
function camera:unset()
  love.graphics.pop()
end
 
function camera:move(dx, dy)
  self._x = self._x + (dx or 0)
  self._y = self._y + (dy or 0)
end
 
function camera:rotate(dr)
  self.rotation = self.rotation + dr
end
 
function camera:scale(sx, sy)
  sx = sx or 1
  self.scaleX = self.scaleX * sx
  self.scaleY = self.scaleY * (sy or sx)
end
 
function camera:setX(value)
  if self._bounds then
    self._x = math.clamp(value, self._bounds.x1, self._bounds.x2)
  else
    self._x = value
  end
end
 
function camera:setY(value)
  if self._bounds then
    self._y = math.clamp(value, self._bounds.y1, self._bounds.y2)
  else
    self._y = value
  end
end
 
function camera:setPosition(x, y)
  if x then self:setX(x) end
  if y then self:setY(y) end
end
 
function camera:setScale(sx, sy)
  self.scaleX = sx or self.scaleX
  self.scaleY = sy or self.scaleY
end
 
function camera:getBounds()
  return unpack(self._bounds)
end
 
function camera:setBounds(x1, y1, x2, y2)
  self._bounds = { x1 = x1, y1 = y1, x2 = x2, y2 = y2 }
end