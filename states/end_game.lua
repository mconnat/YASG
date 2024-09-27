local StateManager = require("states.state_manager")
local GameplayManager = require("modules.gameplay_manager")
local FontManager = require("libs.fonts")

local EndGame = {}
EndGame.status = {}
EndGame.status.text = ""
EndGame.status.x = love.graphics.getWidth() / 2
EndGame.status.y = love.graphics.getHeight() / 3
EndGame.status.width = 0
EndGame.status.height = 0

EndGame.backToMenu = {}
EndGame.backToMenu.text = "Return to menu"
EndGame.backToMenu.x = love.graphics.getWidth() / 2
EndGame.backToMenu.y = EndGame.status.y * 2
EndGame.backToMenu.width = 0
EndGame.backToMenu.height = 0
EndGame.backToMenu.hover = false

function EndGame:enter()
    if GameplayManager.score >= GameplayManager.maxScore then
        EndGame.status.text = "You Win"
    else
        EndGame.status.text = "You Loose"
    end
end

function EndGame:exit()
end

function EndGame:mousepressed(mouseX, mouseY, mouseButton)
    if mouseButton == 1 then
        if mouseX >= EndGame.backToMenu.x - EndGame.backToMenu.width / 2 and mouseX <= ((EndGame.backToMenu.x - EndGame.backToMenu.width / 2) + EndGame.backToMenu.width) and mouseY >= EndGame.backToMenu.y - EndGame.backToMenu.height / 2 and mouseY <= ((EndGame.backToMenu.y - EndGame.backToMenu.height / 2) + EndGame.backToMenu.height) then
            StateManager:switchTo("StartMenu")
        end
    end
end

function EndGame:keypressed(key, scancode, isrepeat)
end

function EndGame:update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    if mouseX >= EndGame.backToMenu.x - EndGame.backToMenu.width / 2 and mouseX <= ((EndGame.backToMenu.x - EndGame.backToMenu.width / 2) + EndGame.backToMenu.width) and mouseY >= EndGame.backToMenu.y - EndGame.backToMenu.height / 2 and mouseY <= ((EndGame.backToMenu.y - EndGame.backToMenu.height / 2) + EndGame.backToMenu.height) then
        EndGame.backToMenu.hover = true
    else
        EndGame.backToMenu.hover = false
    end
end

function EndGame:draw()
    love.graphics.clear(1, 1, 1)
    FontManager:setFontSize(60)
    love.graphics.setColor(0, 0, 0)
    local font = love.graphics.getFont()
    EndGame.status.width = font:getWidth(EndGame.status.text)
    EndGame.status.height = font:getHeight(EndGame.status.text)
    EndGame.backToMenu.width = font:getWidth(EndGame.backToMenu.text)
    EndGame.backToMenu.height = font:getHeight(EndGame.backToMenu.text)

    love.graphics.print(EndGame.status.text, EndGame.status.x, EndGame.status.y, 0, 1, 1, EndGame.status.width / 2,
        EndGame.status.height / 2)
    if EndGame.backToMenu.hover then
        FontManager:setFontSize(70)
    else
        FontManager:setFontSize(60)
    end
    love.graphics.print(EndGame.backToMenu.text, EndGame.backToMenu.x, EndGame.backToMenu.y, 0, 1, 1,
        EndGame.backToMenu.width / 2,
        EndGame.backToMenu.height / 2)
end

return EndGame
