local ClassEnemy = {}

local enemy_mt = { __index = ClassEnemy }

local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()

function ClassEnemy.new()
  newEnemy = {}
  
  newEnemy.x = 500
  newEnemy.y = 0
  newEnemy.vx = 0
  newEnemy.vy = 2
  newEnemy.angle = 90
  newEnemy.tirs = {}
  newEnemy.dead = false
  newEnemy.delay = 0
  newEnemy.speed = 2
  newEnemy.laserSound = love.audio.newSource("media/Sounds/shot.wav", "static")
  newEnemy.img = love.graphics.newImage("media/Sprites/enemy1.png")
  return setmetatable(newEnemy, enemy_mt)
end

function ClassEnemy:move(dt)
    self.y = self.y + self.vy
    self.x = self.x + self.vx
end

function ClassEnemy:collision(bool)
  if (self.x < 0 or self.x > love.graphics.getWidth()) then
    self.dead = true
  end
  if (self.y < 0 or self.y > love.graphics.getHeight()) then
    self.dead = true
  end
  if (bool == true) then
    self.dead = true
  end
end

function ClassEnemy:shot()
  for i=#self.tirs, 1, -1 do
    self.tirs[i].y = self.tirs[i].y + self.tirs[i].vy
    self.tirs[i].x = self.tirs[i].x + self.tirs[i].vx
    if (self.tirs[i].y <  0 or self.tirs[i].y > Height) then
      table.remove(self.tirs, i)
    end
  end
end

function ClassEnemy:drawSprite()
  if (self.dead == false) then
    love.graphics.draw(self.img, self.x, self.y, math.rad(self.angle), 2, 2, self.img:getWidth() / 2, self.img:getHeight() / 2)
    if (self.On == true) then
      love.graphics.draw(self.imgEngine, self.x, self.y, math.rad(self.angle), 2, 2, self.imgEngine:getWidth() / 2, self.imgEngine:getHeight() / 2)
    end
    for i=1, #self.tirs do
      love.graphics.draw(self.tirs[i].img, self.tirs[i].x, self.tirs[i].y)
    end
  end
end

return ClassEnemy