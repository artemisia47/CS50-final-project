local map = {}
local STI = require("sti")
local coin = require("coin")
local spike = require("spike")
local stone = require("stone")
local enemy = require("enemy")
local player = require("player")

function map:load()
    self.currentLevel = 1-- Start with the first level
    world = love.physics.newWorld(0,2000)
    world:setCallbacks(beginContact, endContact)
    self:init()
    -- self:next()
    
end 

function map:init()
    self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})


    self.level:box2d_init(world)
    self.level.layers.solid.visible = false
    self.level.layers.entity.visible = false
    mapWidth = self.level.layers.grass.width * 16

    self:spawnEntities()
end

function map:update()
    if player.x > mapWidth - 16 then
        self:next()
    end 
end 

function map:next()
    self:clean()
    self.currentLevel = self.currentLevel + 1 
    self:init()
    player:resetPosition()
end 

function map:clean()
    self.level:box2d_removeLayer("solid")
    spike:removeAll()
    stone:removeAll()
    coin:removeAll()
    enemy:removeAll()
end 

function  map:spawnEntities()
    for i,v in ipairs(self.level.layers.entity.objects) do
        --Origin point in tile is the top left corner, physics module uses the center, that is why we offset by half on rectangles
        if v.type == "spike" then
            spike.new(v.x + v.width / 2, v.y + v.height / 2)
        end 
        if v.type == "stone" then
            stone.new(v.x + v.width / 2, v.y + v.height / 2)
        end 
        if v.type == "coin" then
            coin.new(v.x, v.y)
        end 
        if v.type == "enemy" then
            enemy.new(v.x + v.width / 2, v.y + v.height /2)
        end 
    end 
end
return map