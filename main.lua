if os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    require('lldebugger').start()
end

love.graphics.setDefaultFilter("nearest")


local StateManager = require("states.state_manager")
local StartMenu = require("states.start_menu")
local Gameplay = require("states.gameplay")
local EndGame = require("states.end_game")


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
