function love.conf(t)
     -- The love.conf function is used to configure game settings before the game starts.
    -- The parameter `t` is a table that contains various configuration options.

    t.title = "Platformer"
    -- Specifies the version of LÖVE (the game framework) that this game is compatible with.
    t.version = "11.5"
    t.console = true
    t.window.width = 1280 -- Sets the width of the game window to 1280 pixels.

    t.window.height = 720    -- Sets the height of the game window to 720 pixels.
    t.window.vsync = 0
end 