# 2D Platformer Game
#### Showcase:

https://github.com/user-attachments/assets/55d3ae99-d9c8-44a3-8308-9bff65d3dd5a


#### Description:

This is a 2D Platformer Game developed using LÖVE2D (Love2D), a framework for creating 2D games in Lua. The game features player movement, level transitions, physics interactions, and interactive elements like coins, spikes, stones, and enemies. The camera dynamically follows the player, and a user interface (GUI) displays the player's score and health.
Features

* Physics-based gameplay: Using the Box2D engine for realistic collisions and movement.
* Dynamic camera: Smooth camera following the player with zoom functionality.
* Level progression: Seamlessly transitioning between levels as the player advances.
* Interactive entities: Collect coins, avoid spikes, break stones, and fight enemies.
* User Interface (GUI): Displays player's health and coin count.

Requirements

* LÖVE2D (Love2D) framework (version 11.3 or higher).
* Basic knowledge of Lua programming and game development.

# Game Structure

The project is divided into several Lua modules, each handling specific aspects of the game. Below is an overview of the files and their responsibilities:
## 1. main.lua - Game Initialization and Main Loop

This is the entry point of the game, where everything is initialized and the main game loop is executed. It handles:

* Asset Loading: Loads the assets such as images, sounds, and maps.
* Physics Update: Manages the world and updates all entities each frame.
* Drawing: Renders the background, map, player, entities, and GUI.
* Camera Control: Follows the player’s movement.
* Collision Detection: Handles interactions between game entities (player, enemies, coins, spikes).

```lua
function love.load() 
    enemy:loadAssets() 
    background = love.graphics.newImage("assets/tiles and background_foreground (new)/forest.jpg")
    map:load() 
    player:load() 
    gui:load()
end
```

## 2. player.lua - Player Management

This module defines the player, including movement, health, and interaction with other entities. The player is controlled via keyboard inputs and can collect coins, take damage from enemies, and jump on platforms.

* Movement: Handles player position and speed.
* Health: Tracks the player's health and updates the* display accordingly.
* Collision Handling: Interactions with other game entities, including damage taken from enemies.

```lua
function player:update(dt)
    -- Update player movement and interactions
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
```

## 3. coin.lua - Coin Collection

The coin module manages coins that the player can collect. When the player touches a coin, it is added to their coin count.

* Coin Creation: Coins are spawned on the map based on the level.
* Collision Detection: Detects when the player collects a coin and removes it from the game world.

```lua
function coin:beginContact(a, b, collision)
    if a == player.physics.fixture or b == player.physics.fixture then
        player.coins = player.coins + 1
        self:remove()  -- Remove coin when collected
    end
end
```
## 4. enemy.lua - Enemy Behavior

This module defines enemy behavior and interactions. Enemies move back and forth, chase the player when enraged, and deal damage upon contact.

* Movement and Rage: Enemies follow a simple AI, moving towards the player once enraged.
* Animation: Different animations for idle and running states.
* Damage: Enemies deal damage to the player upon collision.

```lua
function enemy:update(dt)
    self:syncPhysics()
    self:animate(dt)
end
```

## 5. map.lua - Level Management

The map module loads and manages game levels, using STI (Simple Tiled Implementation) to load and display Tiled map files. It handles the level transitions when the player reaches the edge of the screen. To built our maps 
we used Tiled, a versatile and open-source map editor that allows you to design 2D tile-based game levels

* Level Loading: Loads the current level from a .lua map file using STI.
* Entity Spawning: Spawns entities like coins, spikes, stones, and enemies based on the level data.
* Level Transition: Moves to the next level once the player reaches the end of the current level.

```lua
function map:next()
    self:clean()  -- Clean up current level
    self.currentLevel = self.currentLevel + 1  -- Load the next level
    self:init()
    player:resetPosition()
end
```
## 6. camera.lua - Camera Handling

The camera module keeps the camera focused on the player, allowing for dynamic scrolling. The camera zooms and pans as the player moves through the level.

* Positioning: Keeps the camera centered on the player.
* Scale: Scales the game view based on the player's movement.

```lua
function camera:setPosition(x, y)
    self.x = x - love.graphics.getWidth()/ 2 / self.scale
    self.y = y
end
```

## 7. gui.lua - Graphical User Interface (HUD)

This module is responsible for displaying the game’s user interface, such as the player’s health and coin count.

* Health Display: Displays hearts indicating the player's health.
* Coin Display: Shows the current number of coins the player has collected.

```lua
function gui:displayCoins()
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y)
end
```
## How to Play

* Player Movement: Use the arrow keys or WASD to move the player left and right.
* Jumping: Press the Spacebar or W key to make the player jump.
* Collect Coins: Move over the coins scattered in each level to collect them.
* Avoid Spikes: Spikes are deadly; avoid them by jumping or running around them.
* Defeat Enemies: The player can be harmed by enemies, so avoid them or find ways to defeat them (e.g., jumping on them).
* Level Progression: Move to the right side of the screen to transition to the next level.

## Running the Game

To run the game, follow these steps:

* Download and Install LÖVE2D:
    Visit the LÖVE2D website and download the appropriate version for your system.
    Install LÖVE2D on your computer.
* Download the Game Code: Clone or download this repository to your local machine.
* Run the Game:
    To run the game, simply drag the folder containing the main.lua into the LÖVE2D executable or use the command line:
    ```
    love .
    ```



## File Structure

```
/assets
    /coin
    /enemy
    /heart
    /spike
    /stone
    /tiles_and_background
    /fonts
/map
    /1.lua
    /2.lua
    ...
/coin.lua
/enemy.lua
/player.lua
/spike.lua
/stone.lua
/map.lua
/camera.lua
/gui.lua
/main.lua
```
