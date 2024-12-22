 local gui = {}
 local player = require ("player")
-- Load GUI assets and initialize properties
function gui:load()
   self.coins = {}
   self.coins.img = love.graphics.newImage("assets/coin/4.png")
   self.coins.width = self.coins.img:getWidth()
   self.coins.height = self.coins.img:getHeight()
   self.coins.scale = 3
   -- Keep coins GUI consistent across multiple screen sizes
   self.coins.x = love.graphics.getWidth() - love.graphics.getWidth()/10
   self.coins.y = love.graphics.getHeight() - love.graphics.getHeight()/1.06

   self.hearts = {}
   self.hearts.img = love.graphics.newImage("assets/heart/hearts_hud.png")
   self.hearts.width = self.coins.img:getWidth()
   self.hearts.height = self.coins.img:getHeight()
   self.hearts.x = 0
   self.hearts.y = 30
   self.hearts.scale = 3
   self.hearts.spacing = self.hearts.width * self.hearts.scale + 30
    -- Load the font for displaying text
   self.font = love.graphics.newFont("assets/fonts/monogram.ttf", 36)
end
 -- Load the font for displaying text
function gui:update(dt)
 -- Currently no update logic, but this function can handle dynamic GUI changes
end
function gui:displayHearts()
   for i=1, player.health.current do
      local x = self.hearts.x + self.hearts.spacing * i 
      love.graphics.setColor(0,0,0,0.5)
      love.graphics.draw(self.hearts.img, x + 5, self.hearts.y + 5, 0, self.hearts.scale, self.hearts.scale)
      love.graphics.setColor(1,1,1,1)
      love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale)
   end 

end 

function gui:draw()
   self:displayCoins()
   self:displayCoinText()
   self:displayHearts()
end
-- Draw the coin image with a shadow effect
function gui:displayCoins()
   love.graphics.setColor(0,0,0,0.5)
   love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)
   love.graphics.setColor(1,1,1,1)
   love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
end
-- Display the coin count text with a shadow effect
function gui:displayCoinText()
   love.graphics.setFont(self.font) -- Set the font for text rendering
   -- Calculate the text's position relative to the coin
   local x = self.coins.x + self.coins.width * self.coins.scale
   local y = self.coins.y + self.coins.height / 2 * self.coins.scale - self.font:getHeight() / 2
   love.graphics.setColor(0,0,0,0.5)
   love.graphics.print(" : "..player.coins, x + 2, y + 2)-- Print shadow text slightly offset

   love.graphics.setColor(1,1,1,1)
   love.graphics.print(" : "..player.coins, x, y)
end
 
return gui