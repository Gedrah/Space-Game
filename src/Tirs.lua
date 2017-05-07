local ClassTirs = {}

local tirs_mt = {__index, ClassTirs }

function ClassTirs.new()
  newTirs = {}
  
  newTirs.x = 0
  newTirs.y = 0
  newTirs.vx = 0
  newTirs.vy = 0
  newTirs.img = love.graphics.newImage("media/Sprites/laser1.png")
  
  return setmetatable(newTirs, tirs_mt)
end

return ClassTirs