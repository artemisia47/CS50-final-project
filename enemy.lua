

local enemy = {}
enemy.__index = enemy
local player = require("player")

ActiveEnemies = {} 


function enemy.new(x,y)
    local instance = setmetatable({}, enemy)
    instance.x = x
    instance.y = y
    instance.r = 0
    instance.speed = 100
    instance.speedMod = 1
    instance.xVel = instance.speed

    instance.rageCounter = 0
    instance.rageTrigger = 3-- Number of hits before enemy becomes enraged
    instance.scale = 2.5
    instance.damage = 1
    instance.state = "idle"
    instance.animation = {timer = 0, rate = 0.1}
    instance.animation.idle = {total = 5, current =1, img = enemy.idleAnim}
    instance.animation.run = {total =15 , current =1, img = enemy.runAnim}
    instance.animation.draw = instance.animation.idle.img[1]

    instance.physics = {}
    instance.physics.body = love.physics.newBody(world,instance.x,instance.y,"dynamic")
    instance.physics.body:setFixedRotation(true)
    instance.physics.shape = love.physics.newRectangleShape(instance.width* 0.4,instance.height* 0.75)
   
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.body:setMass(25)
   
    table.insert(ActiveEnemies, instance)
end

function enemy.loadAssets()
    enemy.runAnim = {}
    for i = 1,15 do
        enemy.runAnim[i] = love.graphics.newImage("assets/enemy.run/"..i..".png")
    end 
    enemy.idleAnim = {}
    for i = 1,5 do
        enemy.idleAnim[i] = love.graphics.newImage("assets/enemy.idle/"..i..".png")
    end 
    
    enemy.width = enemy.runAnim[1]:getWidth()
    enemy.height = enemy.runAnim[1]:getHeight()
end

function enemy:draw()
    local scaleX = self.scale
    if self.xVel > 0 then
        scaleX = -scaleX
    end
    love.graphics.draw(self.animation.draw,self.x,self.y, self.r, scaleX, self.scale, self.width / 2, self.height / 2)
end 

function enemy:update(dt)
    self:syncPhysics()
    self:animate(dt)
    
    
end 
-- Function to increment the rage of the enemy
function enemy:incrementRage()
    self.rageCounter = self.rageCounter + 1 
    if self.rageCounter > self.rageTrigger then
        self.state = "run"
        self.animation.rate = 0.01
        self.speedMod = 3
        self.rageCounter = 0
        
    else
        self.state = "idle"
        self.animation.rate = 0.1
        self.speedMod = 1
    end
end 

function enemy:flipDirection()
    self.xVel = -self.xVel-- Reverse the enemy's x-velocity to flip direction

end 

function enemy:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel* self.speedMod, 100)
end 

function enemy:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end

end 

--Iterates it's animation frame and draws the frame 
function enemy:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else 
        anim.current = 1
    end 
    self.animation.draw = anim.img[anim.current]


end 

function enemy:updateAll(dt)
    for i,instance in ipairs(ActiveEnemies) do
        instance:update(dt)

    end
end 

function enemy.drawAll()
  
    for i,instance in ipairs(ActiveEnemies) do
        instance:draw()
    
    end 

end

function enemy.beginContact(a,b, collision)
    for i,instance in ipairs(ActiveEnemies) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == player.physics.fixture or b == player.physics.fixture then
                player:takeDamage(instance.damage)
                
            end
            instance:incrementRage()
            instance:flipDirection()
        end 

    end 
end 


function enemy:removeAll()
    for i,v in ipairs(ActiveEnemies) do
        v.physics.body:destroy()
    end 
    ActiveEnemies = {}
end 

return enemy