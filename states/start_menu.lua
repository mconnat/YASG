local FontManager = require("libs.fonts")
local GodMod = require("libs.godmod")
local StateManager = require("states.state_manager")

local StartMenu = {}

local MenuButton = {
    PlayButton = {
        text = "START",
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 3,
        width = 0,
        height = 0,
        hover = false,
        onClick = function()
            StateManager:switchTo("Gameplay")
        end
    },
    QuitButton = {
        text = "EXIT",
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        width = 0,
        height = 0,
        hover = false,
        onClick = function()
            love.event.quit(0)
        end
    }
}

local Title = {
    text = "Yet Another Survival Game",
    x = love.graphics.getWidth() / 2,
    y = 100,
    width = 0,
    height = 0,
}


function StartMenu:enter()
    FontManager:setFontSize(60)
    local titleFont = love.graphics.getFont()
    Title.width = titleFont:getWidth(Title.text)
    Title.height = titleFont:getHeight(Title.text)
    FontManager:setFontSize(42)
    for _, v in pairs(MenuButton) do
        local font = love.graphics.getFont()
        v.width = font:getWidth(v.text)
        v.height = font:getHeight(v.text)
    end
end

function StartMenu:exit()
    FontManager:resetFontSize()
end

function StartMenu:update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    for _, v in pairs(MenuButton) do
        if mouseX >= v.x - v.width / 2 and mouseX <= ((v.x - v.width / 2) + v.width) and mouseY >= v.y - v.height / 2 and mouseY <= ((v.y - v.height / 2) + v.height) then
            v.hover = true
        else
            v.hover = false
        end
    end
end

function StartMenu:mousepressed(mouseX, mouseY, mouseButton)
    if mouseButton == 1 then
        for _, v in pairs(MenuButton) do
            if mouseX >= v.x - v.width / 2 and mouseX <= ((v.x - v.width / 2) + v.width) and mouseY >= v.y - v.height / 2 and mouseY <= ((v.y - v.height / 2) + v.height) then
                v.onClick()
            end
        end
    end
end

function StartMenu:keypressed(key, scancode, isrepeat)
    GodMod:cheatcode(scancode, function()
        CONFIG.GodMod = true
        love.window.showMessageBox("God mod", "You are now in god mod, restart the game to disable it")
    end)
end

function StartMenu:draw()
    love.graphics.clear(1, 1, 1)
    FontManager:setFontSize(60)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(Title.text, Title.x, Title.y, 0, 1, 1, Title.width / 2, Title.height / 2)
    for _, v in pairs(MenuButton) do
        if v.hover then
            FontManager:setFontSize(45)
        else
            FontManager:setFontSize(42)
        end
        love.graphics.print(v.text, v.x, v.y, 0, 1, 1, v.width / 2, v.height / 2)
    end
end

return StartMenu
