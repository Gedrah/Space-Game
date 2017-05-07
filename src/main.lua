-- classes called --
local SpaceShipClass = require('SpaceShip')
local AsteroidClass = require('Asteroid')
local StarfieldClass = require('Starfield')
local TirsClass = require('Tirs')


-- tabs of classes (usually to create multiple sprites --
local Asteroids = {}
local nbrAst = 10

local Space
local Background

-- variable usefull

local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
local gravity = 0.6

-- manage sprites

function initGame()
  Background = StarfieldClass.new()   
  Space = SpaceShipClass.new()
  Background:createStars()
  Asteroids = createSprites(AsteroidClass, nbrAst)
end

function collisionHandler(ClassA, ClassB)
  if (ClassA == ClassB) then
    return false
  end
  local dx = ClassA.x - ClassB.x
  local dy = ClassA.y - ClassB.y
  if (math.abs(dx) < ClassA.img:getWidth() + ClassB.img:getWidth() / 10) then
      if (math.abs(dy) < ClassA.img:getHeight() + ClassB.img:getHeight() / 10) then
          return true
      end
  end
  return false
end

function createSprites(Class, nbrSprites)
  math.randomseed(os.time())
  local newSpritesTab = {}
  for i=1, nbrSprites do
    newSpritesTab[i] = Class.new()
    newSpritesTab[i].x = math.random(Width - newSpritesTab[i].img:getWidth())
    newSpritesTab[i].y = math.random(Height - newSpritesTab[i].img:getHeight())
  end
  return newSpritesTab
end

function drawSprites(ClassTab, nbrSprites)
  for i=1, nbrSprites do
    ClassTab[i]:drawSprite()
  end
end

-- love functions (draw, load, update, key) --

function love.load()
  local icon = love.image.newImageData("media/Sprites/icon.png")
  love.window.setIcon(icon)
  love.window.setTitle("Space Game")
  initGame()
end

function love.update(dt)
  if (Space.dead == false) then
    Space:gravity(gravity, dt)
    Space:shot()
    Space:move(dt)
    Space:shot()
    for i=1, #Asteroids do
      bool = collisionHandler(Space, Asteroids[i])
      --Space:collision(bool)
    end
  end
end

function love.draw()
  Background:drawSprite()
  Space:drawSprite()
  drawSprites(Asteroids, nbrAst)
end

function love.keypressed(key)
  if (key == 'escape') then
    love.event.quit()
  end
  if (key == ' ') then
    local newTirs = TirsClass.new()
    newTirs.vy = 10 * math.sin(math.rad(Space.angle))
    newTirs.vx = 10 * math.cos(math.rad(Space.angle))
    newTirs.x = Space.x - Space.img:getWidth() / 2
    newTirs.y = Space.y - (Space.img:getHeight() * 2) / 2
    table.insert(Space.tirs, newTirs)
    love.audio.play(Space.laserSound)
  end
end