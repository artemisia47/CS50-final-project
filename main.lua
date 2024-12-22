
-- Prevents blurry assets 
love.graphics.setDefaultFilter("nearest", "nearest")
local player = require ("player")
local coin = require("coin")
local spike = require("spike")
local stone = require("stone")
local enemy = require("enemy")
local map = require("map")
local camera = require("camera")
local gui = require("gui")

function love.load()-- This function is called once at the start of the game to initialize everything
   
    enemy:loadAssets()
    background = love.graphics.newImage("assets/tiles and background_foreground (new)/forest.jpg")
    map:load()
    player:load()
    
    gui:load()

end


-- This function is called every frame to update game logic
-- `dt` is the delta time (time passed since the last frame)
function love.update(dt)
    world:update(dt)
    player:update(dt)
    coin:updateAll(dt)
    spike:updateAll(dt)
    stone:updateAll(dt)
    enemy:updateAll(dt)
    map:update(dt)
    gui:update(dt)
    camera:setPosition(player.x, 0)

end

function love.draw()
    
    -- Get window dimensions
    local windowWidth, windowHeight = love.graphics.getDimensions()
    -- Get image dimensions
    local bgWidth, bgHeight = background:getDimensions()
    -- Calculate scaling factors to fill the screen
    local scaleX = windowWidth / bgWidth
    local scaleY = windowHeight / bgHeight
    -- Draw the background, scaling to fill the screen
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

    map.level:draw(-camera.x, -camera.y, camera.scale, camera.scale)
    camera:apply()
    -- love.graphics.push()
    -- love.graphics.scale(2,2)

    player:draw()
    coin:drawAll()
    spike:drawAll()
    stone:drawAll()
    -- love.graphics.pop()
    enemy:drawAll()
    camera:clear()
    gui:draw()
end 

function love.keypressed(key)
    player:jump(key)
end 

function beginContact(a, b, collision)-- Callback for when two physics objects begin contact
    if coin.beginContact(a, b, collision) then return end
    if spike.beginContact(a, b, collision) then return end
    enemy.beginContact(a, b, collision) 
    player:beginContact(a, b, collision)

end

function endContact(a, b, collision)-- Callback for when two physics objects end contact
    player:endContact(a, b, collision)

end 

