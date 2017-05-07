local ClassSpaceShip = {}
local mt_SpaceShip = { __index = ClassSpaceShip }


local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()

function ClassSpaceShip.new()
  local newSpaceShip = {}
  
  newSpaceShip.x = love.graphics.getWidth() / 2
  newSpaceShip.y = love.graphics.getHeight() / 2
  newSpaceShip.vx = 0
  newSpaceShip.vy = 0
  newSpaceShip.angle = 1
  newSpaceShip.speed = 3
  newSpaceShip.On = false
  newSpaceShip.tirs = {}
  newSpaceShip.img = love.graphics.newImage("media/Sprites/ship.png")
  newSpaceShip.imgEngine = love.graphics.newImage("media/Sprites/engine.png")
  
  return setmetatable(newSpaceShip, mt_SpaceShip)
end

function ClassSpaceShip:applyInertie(dt)
  local angle_radian = math.rad(self.angle)
  local force_x = math.cos(angle_radian) * (self.speed * dt)
  local force_y = math.sin(angle_radian) * (self.speed * dt)
  self.vx = self.vx + force_x
  self.vy = self.vy + force_y
end

function ClassSpaceShip:gravity(grav, dt)
  self.vy = self.vy + (grav * dt)
  self.x = self.x + self.vx
  self.y = self.y + self.vy
end

function ClassSpaceShip:move(dt)
  if (love.keyboard.isDown('up')) then
      self:applyInertie(dt)
      self.On = true
    else
      self.On = false
  end
  if (love.keyboard.isDown('left')) then
    self.angle = self.angle - (90 * dt) 
    if (self.angle < 0) then
      self.angle = 360
    end      
  end
  if (love.keyboard.isDown('right')) then
    self.angle = self.angle + (90 * dt)
    if (self.angle > 360) then
      self.angle = 0
    end
  end
end

function ClassSpaceShip:collision()
  if (self.x < 0 or self.x > love.graphics.getWidth()) then
    love.event.quit()
  end
  if (self.y < 0 or self.y > love.graphics.getHeight()) then
    love.event.quit()
  end
end

function ClassSpaceShip:shot()
  for i=#self.tirs, 1, -1 do
    self.tirs[i].y = self.tirs[i].y + self.tirs[i].vy
    self.tirs[i].x = self.tirs[i].x + self.tirs[i].vx
    if (self.tirs[i].y <  0 or self.tirs[i].y > Height) then
      table.remove(self.tirs, i)
    end
  end
end

function ClassSpaceShip:drawSprite()
  love.graphics.draw(self.img, self.x, self.y, math.rad(self.angle), 2, 2, self.img:getWidth() / 2, self.img:getHeight() / 2)
  if (self.On == true) then
    love.graphics.draw(self.imgEngine, self.x, self.y, math.rad(self.angle), 2, 2, self.imgEngine:getWidth() / 2, self.imgEngine:getHeight() / 2)
  end
  for i=1, #self.tirs do
    love.graphics.draw(self.tirs[i].img, self.tirs[i].x, self.tirs[i].y)
  end
  love.graphics.print(tostring(self.angle))
end

return ClassSpaceShip