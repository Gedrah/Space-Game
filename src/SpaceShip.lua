local ClassSpaceShip = {}
local mt_SpaceShip = { __index = ClassSpaceShip }


function ClassSpaceShip.new()
  local newSpaceShip = {}
  
  newSpaceShip.x = love.graphics.getWidth() / 2
  newSpaceShip.y = love.graphics.getHeight() / 2
  newSpaceShip.vx = 0
  newSpaceShip.vy = 0
  newSpaceShip.angle = 90
  newSpaceShip.speed = 2
  newSpaceShip.img = love.graphics.newImage("media/Sprites/ship.png")
  newSpaceShip.imgEngine = love.graphics.newImage("media/Sprites/engine.png")
  
  return setmetatable(newSpaceShip, mt_SpaceShip)
end

function ClassSpaceShip:move()
  if (love.keyboard.isDown('up')) then
      self.y = self.y + self.speed
  end
end

function ClassSpaceShip:drawSprite()
  love.graphics.draw(self.img, self.x, self.y)
end

return ClassSpaceShip