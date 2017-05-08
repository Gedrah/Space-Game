local MenuClass = {}

local menu_mt = {__index = MenuClass }

local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
local fontSize = 50

function MenuClass.new()
  newMenu = {}
  
  newMenu.x = 0
  newMenu.y = 0
  newMenu.font = love.graphics.newFont("media/Font/Triforce.ttf", fontSize)
  newMenu.img = love.graphics.newImage("media/Sprites/background.jpg")
  newMenu.backgroundMusic = love.audio.newSource("media/Sounds/space_background.ogg", "stream")


  return setmetatable(newMenu, menu_mt)
end

function MenuClass:drawMenu()
  love.graphics.draw(self.img, 0, 0)
  love.graphics.setFont(self.font)
  love.graphics.print("Space Game", Width / 2, Height / 4, 0, 1, 1, (string.len("Space Game") / 2 * fontSize / 2))
  love.graphics.setColor(0, 0, 255)
  love.graphics.print("Press ENTER to Start", Width / 2, Height / 2, 0, 1, 1, (string.len("Press ENTER to Start") / 2 * fontSize / 2))
  love.graphics.setColor(255, 255, 255)
end

function MenuClass:drawGameOver(score)
  love.graphics.draw(self.img, 0, 0)
  love.graphics.print("Game Over", Width / 2, Height / 4, 0, 1, 1, (string.len("Game Over") / 2 * fontSize / 2) )
  love.graphics.print("Score : "..tostring(score), Width / 2, Height / 3, 0, 1, 1, (string.len("Score : ") / 2 * fontSize / 2))
  love.graphics.print("Press ENTER to restart", Width / 2, Height / 2, 0, 1, 1, (string.len("Press ENTER to restart") / 2 * (fontSize / 2)))
end

return MenuClass