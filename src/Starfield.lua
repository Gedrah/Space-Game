local ClassStarfield = {}

local starfield_mt = {__index = ClassStarfield }

function ClassStarfield.new()
  newStarfield = {}
  
  newStarfield.x = 0
  newStarfield.y = 0
  newStarfield.maxStars = 100
  newStarfield.stars = {}
  newStarfield.center_x = love.graphics.getWidth()
  newStarfield.center_y = love.graphics.getHeight()
  newStarfield.background = love.graphics.newImage('media/Sprites/back.jpg')
  return setmetatable(newStarfield, starfield_mt)
end

function ClassStarfield:drawSprite()
  love.graphics.draw(self.background, self.x, self.y)
end

function ClassStarfield:createStars()
     for i=1, self.maxStars do
      local x = love.math.random(5, love.graphics.getWidth() - 5)
      local y = love.math.random(5, love.graphics.getHeight() - 5)
      self.stars[i] = {x, y}
   end
end

function ClassStarfield:drawStars()
  for i, star in ipairs(self.stars) do
      love.graphics.point(star[1], star[2])
   end
end

return ClassStarfield