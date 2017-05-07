local AsteroidClass = {}

local mt_asteroid = {__index = AsteroidClass }

function AsteroidClass.new()
  newAsteroid = {}
  
  newAsteroid.name = "asteroid"
  newAsteroid.x = 10
  newAsteroid.y = 20
  newAsteroid.img = love.graphics.newImage('media/Sprites/Asteroid1.png')
  
  return setmetatable(newAsteroid, mt_asteroid)
end

function AsteroidClass:drawSprite()
  love.graphics.draw(self.img, self.x, self.y, 0, 0.5, 0.5, self.img:getWidth() / 2, self.img:getHeight() / 2)
end

return AsteroidClass