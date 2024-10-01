CONFIG = {}

function love.conf(t)
    t.window.title = "YASG"
    t.window.icon = "assets/sprites/Hero.png" -- Filepath to an image to use as the windows icon (string)
    t.window.width = 1280                     -- The window width (number)
    t.window.height = 1024                    -- The window height (number)
    t.window.resizable = false                -- Let the window be user-resizable (boolean)
    t.window.vsync = 1                        -- Vertical sync mode (number)
    t.window.display = 1                      -- Index of the monitor to show the window in (number)
    t.window.usedpiscale = true               -- Enable automatic DPI scaling when highdpi is set to true as well (boolean)
    t.debug = false                           -- Enable debug mode
    CONFIG = t
    CONFIG.GodMod = false
end
