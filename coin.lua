
-- Define the coin class
local coin = {img = love.graphics.newImage("assets/coin/4.png")}
coin.__index = coin
coin.width = coin.img:getWidth()
coin.height  = coin.img:getHeight()
local ActiveCoins = {} -- Table to store all active coin instances
local player = require ("player")

function coin.new(x,y)
    local instance = setmetatable({}, coin)
    instance.x = x
    instance.y = y
    
    instance.scale = 2
    instance.scaleX = instance.scale
    instance.randomTimeOffset = math.random(0, 100)

    instance.toBeRemoved = false 

    instance.physics = {}
    instance.physics.body = love.physics.newBody(world,instance.x,instance.y,"static")
    
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
    -- Fixture combines the shape and the body as one 
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveCoins, instance)
end

function coin:draw()
 -- Draw the coin's image at its position, centered on its origin
    love.graphics.draw(self.img,self.x,self.y, 0, self.scaleX, self.scale, self.width / 2, self.height / 2)
end 

function coin:update(dt)
    self:spin(dt)
    self:checkRemove()
end 

function coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 5 + self.randomTimeOffset) + self.scale - 1 

end 

function coin:remove()
    for i,instance in ipairs(ActiveCoins) do
        -- if i is the coin that called this function
        if instance == self then
            player:incrementCoins()
            self.physics.body:destroy()
            table.remove(ActiveCoins,i)
        end 

    end 
end 
    

function coin:checkRemove()
    if self.toBeRemoved then
        self:remove()

    end 

end 


function coin:updateAll(dt)
    for i,instance in ipairs(ActiveCoins) do
        instance:update(dt)

    end
end 

function coin.drawAll()
    -- Iterate through all coins in the ActiveCoins table
    for i,instance in ipairs(ActiveCoins) do
        instance:draw()
    
    end 

end

function coin.beginContact(a,b, collision)
    for i,instance in ipairs(ActiveCoins) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == player.physics.fixture or b == player.physics.fixture then
                
                instance.toBeRemoved = true
                return true
            end
        end 
    end 
end 

function coin:removeAll()
    for i,v in ipairs(ActiveCoins) do
        v.physics.body:destroy()
    end 
    ActiveCoins = {}
end 
return coin