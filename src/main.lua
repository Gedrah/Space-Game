-- classes called --
local SpaceShipClass = require('SpaceShip')
local AsteroidClass = require('Asteroid')
local StarfieldClass = require('Starfield')
local TirsClass = require('Tirs')
local EnemyClass = require('Enemy')
local MenuClass = require('Menu')


-- tabs of classes (usually to create multiple sprites --
local Asteroids = {}
local Enemies = {}

local nbrAst = 10
local nbrEnemies = 2
local SpawnDelay = 30

local Space
local Background
local Menu
local Score = 0
local Level = 0

-- variable usefull

local Width = love.graphics.getWidth()
local Height = love.graphics.getHeight()
local gravity = 0.6

-- manage sprites

function initGame()
  math.randomseed(os.time())   
  Enemies = createSprites(EnemyClass, nbrEnemies)
  Asteroids = createSprites(AsteroidClass, nbrAst)
  Background = StarfieldClass.new()   
  Space = SpaceShipClass.new()
  love.audio.play(Menu.backgroundMusic)
  Score = 0
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

function destroySprites(Class, nbrSprites)
  for i=#Class, 1, -1 do
    table.remove(Class, i)
  end
end

function drawSprites(ClassTab, nbrSprites)
  for i=1, nbrSprites do
    ClassTab[i]:drawSprite()
  end
end

function createTirs(Class)
    local newTirs = TirsClass.new()
    newTirs.vy = 10 * math.sin(math.rad(Class.angle + 90))
    newTirs.vx = 10 * math.cos(math.rad(Class.angle + 90))
    newTirs.x = Class.x - Class.img:getWidth() / 2
    newTirs.y = Class.y - (Class.img:getHeight() * 2) / 2
    table.insert(Class.tirs, newTirs)
    love.audio.play(Class.laserSound)
end

function HandleEnemies(Class, nbr)
    for i=#Enemies, 1, -1 do
      Class[i].delay = Enemies[i].delay + 1
      Class[i]:shot()  
      Class[i]:move()
      if (Class[i].delay > 80) then
        local Tirs = TirsClass.new()
        createTirs(Class[i])
        Class[i].delay = 0
      end
      local bool = collisionHandler(Class[i], Space)
      for j=#Class[i].tirs, 1, -1 do
        local bool2 = collisionHandler(Space, Class[i].tirs[j])
        if (bool2 == true) then
          Space.dead = true
        end
      end
      if (bool == true) then
        Space.dead = true
      end
      if (Class[i]:collision() == true) then
        table.remove(Class, i)
        nbrEnemies = nbrEnemies - 1
      end
    end
end

function updateGame(dt)
  if (Space.dead == false) then
    
    --player actions --
    Space:gravity(gravity, dt)
    Space:shot()
    Space:move(dt)
    Space:collision()
    for i=1, #Space.tirs do
      for j=#Enemies, 1, -1 do
        local bool = collisionHandler(Space.tirs[i], Enemies[j])
        if (bool == true) then
          nbrEnemies = nbrEnemies - 1
          table.remove(Enemies, j)
          Score = Score + 1
        end
      end
    end
    
    --enemy actions --
    HandleEnemies(Enemies, nbrEnemies)
    
    -- spawner --
    if (SpawnDelay > math.random(60, 100)) then
      table.insert(Enemies, EnemyClass.new())
      nbrEnemies = nbrEnemies + 1
      SpawnDelay = 0
    end
    
    SpawnDelay = SpawnDelay + 1
  else
    Level = 2
    Clear = true
    love.audio.stop(Background.backgroundMusic)
  end
end

-- love functions (draw, load, update, key) --

function love.load()
  local icon = love.image.newImageData("media/Sprites/icon.png")
  love.window.setIcon(icon)
  love.window.setTitle("Space Game")
  Menu = MenuClass.new()
  initGame()
end


function love.update(dt)
  if (Level == 1) then
    updateGame(dt)
  end
  if (Clear == true) then
    destroySprites(Enemies)
    destroySprites(Asteroids)
    initGame()
    love.audio.stop(Background.backgroundMusic)
    Clear = false
  end
end

function love.draw()
  if (Level == 0) then
    Menu:drawMenu()
  elseif (Level == 1) then
    Background:drawSprite()
    Space:drawSprite()
    drawSprites(Enemies, nbrEnemies)
    drawSprites(Asteroids, nbrAst)
    love.graphics.print("Score : "..tostring(Score), 0, 0)
  else
    Menu:drawGameOver()
  end
end


function love.keypressed(key)
    if (key == 'escape') then
      love.event.quit()
    end
   if (key == 'return') then
    if (Level == 2) then
      Level = 0
      love.audio.stop(Background.backgroundMusic)
    else
      Level = 1
      love.audio.stop(Menu.backgroundMusic)
      love.audio.play(Background.backgroundMusic)
    end
  end
  if (Level == 1) then
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
end