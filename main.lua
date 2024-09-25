if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    require('lldebugger').start()
end

love.graphics.setDefaultFilter("nearest")


local StateManager = require("states.StateManager")
local StartMenu = require("states.StartMenu")
local Gameplay = require("states.Gameplay")
local EndGame = require("states.EndGame")


function love.load()
    StateManager:addState("StartMenu", StartMenu)
    StateManager:addState("Gameplay", Gameplay)
    StateManager:addState("EndGame", EndGame)
    StateManager:switchTo("StartMenu")
    local cursor = love.mouse.newCursor("assets/sprites/Crosshair.png")
    love.mouse.setCursor(cursor)
end

function love.mousepressed(x, y, button)
    StateManager:mousepressed(x, y, button)
end

function love.keypressed(key, scancode, isrepeat)
    StateManager:keypressed(key, scancode, isrepeat)
end

function love.update(dt)
    StateManager:update(dt)
end

function love.draw()
    StateManager:draw()
end
