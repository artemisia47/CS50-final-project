
player = {}

function player:load()
    self.x = 100
    self.y = 0
    self.startX = self.x
    self.startY = self.y
    self.width = 20
    self.height = 32
    self.xVel = 0
    self.yVel = 100
    self.maxSpeed = 200
    self.acceleration = 9000
    -- 200/4000 = 0.05 (time ti reach max speed)
    -- time to stop = 200/3500 = 0.0571

    self.direction = "right"
    self.friction = 3500
    self.gravity = 1500
    self.jumpAmount = -500
    self.hasdoubleJump = true 
    self.direction = "right"
    self.state = "idle"
    self.graceTime = 0
    self.graceDuration = 0.2
    self.coins = 0
    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 1
    }
    -- Player attributes
    self.alive = true 
    self.health = {current = 3, max = 3}
    self.grounded = false
    self:loadAssets()
  -- Initialize physics for the player using LÖVE's physics engine
    self.physics = {}
    self.physics.body = love.physics.newBody(world,self.x,self.y,"dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width,self.height)
    -- Fixture combines the shape and the body as one 
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)--Removes player's default gravity so we can use our own
    
    


end

function player:loadAssets()
    self.animation = {timer = 0, rate = 0.1}

    self.animation.run = {total = 6, current =1, img = {}}
    for i=1, self.animation.run.total do 
        self.animation.run.img[i] = love.graphics.newImage("assets/hero.run/"..i..".png")
    end 

    self.animation.idle = {total = 4, current = 1, img = {}}
    for i=1, self.animation.idle.total do 
        self.animation.idle.img[i] = love.graphics.newImage("assets/hero.idle/"..i..".png")
    end 
    self.animation.airUp = {total = 3, current = 1, img = {}}
    for i=1, self.animation.airUp.total do 
        self.animation.airUp.img[i] = love.graphics.newImage("assets/hero.airUp/"..i..".png")
    end 
    self.animation.airDown = {total = 3, current = 1, img = {}}
    for i=1, self.animation.airDown.total do 
        self.animation.airDown.img[i] = love.graphics.newImage("assets/hero.airDown/"..i..".png")
    end 
    
    self.animation.draw = self.animation.run.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw: getHeight()

end 



function player:applyGravity(dt)
    if self.grounded then return end 
    self.yVel = self.yVel + self.gravity * dt
end 

function player:update(dt)
    self:respawn()
    self:setState()
    self:setDirection()
    self:animate(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:decreaseGraceTime(dt)
    self:unTint(dt)


end

function player:takeDamage(amount)
    self:tintRed()-- Temporarily tint the player red
    self.health.current = math.max(self.health.current - amount, 0)
    if self.health.current == 0 then self:die() -- Kill the player if health reaches 0

    end 
end 

function player:die()
    print("R.I.P.")-- That is a debug message
    self.alive = false 
end 

function player:respawn()
    if not self.alive or player.y > love.graphics.getWidth() / 2 then
        self:resetPosition()
        self.health.current = self.health.max 
        self.alive = true

    end

end 

function player:resetPosition()
    self.physics.body:setPosition(self.startX, self.startY)-- Reset the player's position to the starting point
end
    

function player:incrementCoins()
    self.coins = self.coins + 1 
end 
 

function player:tintRed(args)
    self.color.green = 0
    self.color.blue = 0

end 

function player:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)

end 

function player:setState()
    if not self.grounded and self.yVel > 0 then
        self.state = "airDown"
    elseif not self.grounded and self.yVel < 0 then
        self.state = "airUp"
    elseif self.xVel == 0 then
        self.state = "idle"
    else
        self.state = "run"
    end
end 


function player:setDirection()
    if self.xVel < 0 then
        self.direction = "left"
    elseif self.xVel > 0 then
        self.direction = "right"
    end
end     

function player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end

end 

--Iterates it's animation frame and draws the frame 
function player:setNewFrame()
    local anim = self.animation[self.state]
    if anim.current < anim.total then
        anim.current = anim.current + 1
    else 
        anim.current = 1
    end 
    self.animation.draw = anim.img[anim.current]


end 



function player:move(dt)
    --player movement
    if love.keyboard.isDown("d", "right") then 
        --easier method, argv0 is the calculation, argv1 is the ceiling 
        self.xVel = math.min(self.xVel + self.acceleration * dt, self.maxSpeed)
        -- if self.xVel < self.maxSpeed then 
        --     -- cap at max speed/normalize
        --     if self.xVel + self.acceleration * dt < self.maxSpeed then
        --         self.xVel = self.xVel + self.acceleration * dt
        --     else
        --         self.xVel = self.maxSpeed
        --     end
        -- end
    elseif love.keyboard.isDown("a", "left") then 
        --easier method, argv0 is the calculation, argv1 is the ceiling 
        self.xVel = math.max(self.xVel - self.acceleration * dt, -self.maxSpeed)
        -- if self.xVel > -self.maxSpeed then 
        --     -- cap at max speed/normalize
        --     if self.xVel - self.acceleration * dt > self.maxSpeed then
        --         self.xVel = self.xVel - self.acceleration * dt
        --     else
        --         self.xVel = -self.maxSpeed
        --     end
        -- end
    else
        self:applyFriction(dt)
    end        

                
end 
-- Apply friction to slow the player when not moving
function player:applyFriction(dt)
    if self.xVel > 0 then
        self.xVel = math.max(self.xVel - self.friction * dt, 0) 
        -- if self.xVel - self.friction * dt > 0 then
        --     self.xVel = self.xVel - self.friction * dt
        -- else 
        --     self.xVel = 0
        -- end
    elseif self.xVel < 0 then
        self.xVel = math.max(self.xVel + self.friction * dt, 0)
        -- if self.xVel + self.friction * dt < 0 then
        --     self.xVel = self.xVel + self.friction * dt
        -- else 
        --     self.xVel = 0
        -- end
    end
end     




function player:syncPhysics()
    self.x,self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel,self.yVel)
end 
   
function player:draw()
    --x,y are at the center while the image is being drawn from top left corner that is why we divide by 5 
    -- so we can get the image to draw where the collider is as well.Scale 2,2 is for making the character bigger 
    --and fit well the collider.
    local dirX = 1
    if self.direction == "left" then
        dirX = -1
    end 
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.draw(self.animation.draw, self.x, self.y, 0, 2 *dirX, 2, self.animation.width /2-1, self.animation.height /2)
    love.graphics.setColor(1, 1, 1, 1)

end 

function player:beginContact(a, b, collision)
    if self.grounded then 
        return 
    end 
    --nx: The x-component of the collision normal vector.
    --ny: The y-component of the collision normal vector.
    local nx,ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then 
            self:land(collision)
        elseif ny < 0 then 
            self.yVel = 0
        end 
    elseif b == self.physics.fixture then
        if ny < 0 then 
            self:land(collision)
        elseif ny > 0 then
            self.yVel = 0
        end 
    end
        

end



function player:land(collision)
    self.currentGroundCollision = collision 
    self.yVel = 0 
    self.grounded = true
    self.hasdoubleJump = true 
    self.graceTime = self.graceDuration
end 

function player:decreaseGraceTime(dt)
    if not self.grounded then 
        self.graceTime = self.graceTime - dt 
    end 

end 

function player:jump(key) 
    if (key == "w" or key == "up") then
        if self.grounded or self.graceTime > 0 then
        self.yVel = self.jumpAmount
        self.graceTime = 0
        elseif self.hasdoubleJump then 
            self.hasdoubleJump = false
            self.yVel =  self.jumpAmount * 0.8
        end 
        
    end 


end 

function player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end 
    end 

end 

return player 