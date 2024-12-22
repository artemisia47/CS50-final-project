

local spike = {img = love.graphics.newImage("assets/traps/spike.png")}
spike.__index = spike
spike.width = spike.img:getWidth()
spike.height  = spike.img:getHeight()
Activespikes = {} 
local player = require ("player")

function spike.new(x,y)
    local instance = setmetatable({}, spike)
    instance.x = x
    instance.y = y
    instance.damage = 1 
    instance.physics = {}
    instance.physics.body = love.physics.newBody(world,instance.x,instance.y,"static")
    
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
   
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(Activespikes, instance)
end

function spike:draw()
 
    love.graphics.draw(self.img,self.x,self.y, 0, 2.5, 2.5, self.width / 2, self.height / 2)
end 

function spike:update(dt)
    
    
end 




function spike:updateAll(dt)
    for i,instance in ipairs(Activespikes) do
        instance:update(dt)

    end
end 

function spike.drawAll()
  
    for i,instance in ipairs(Activespikes) do
        instance:draw()
    
    end 

end

function spike.beginContact(a,b, collision)
    for i,instance in ipairs(Activespikes) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
             -- Check if the collision involves the player
            if a == player.physics.fixture or b == player.physics.fixture then
                player:takeDamage(instance.damage)
                
                return true  -- End the check after detecting the collision
            end
        end 
    end 
end 


-- Function to remove all spikes 
function spike:removeAll()
    for i,v in ipairs(Activespikes) do
        v.physics.body:destroy()
    end 
    Activespikes = {}
end 

return spike