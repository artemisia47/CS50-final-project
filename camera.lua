local camera = {
    x = 0,
    y = 0,
    scale = 2
}
-- Function to apply the camera transformations before drawing the game world
function camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y )

end 

-- Function to clear the camera transformations after drawing the game world
function camera:clear()
    love.graphics.pop()

end 
-- Function to set the camera position, making sure it doesn't go out of the map's boundaries
function camera:setPosition(x,y)
    self.x = x - love.graphics.getWidth()/ 2 / self.scale
    self.y = y 
    local rightSide = self.x + love.graphics.getWidth() / 2

    if self.x < 0 then
        self.x = 0
    elseif rightSide > mapWidth then 
        self.x = mapWidth - love.graphics.getWidth() / 2
    end
    
end 

return camera
