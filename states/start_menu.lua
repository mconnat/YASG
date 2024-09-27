local FontManager = require("libs.fonts")
local GodMod = require("libs.godmod")
local StateManager = require("states.state_manager")
local GuiManager = require("modules.gui_manager")

local StartMenu = {}

local GUIStartMenuGroup = GuiManager.newGroup()
local TitleText = GuiManager.newText(5, 40, love.graphics.getWidth() - 10, 50, "Yet another survivor game",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 60), "center", nil, { r = 0, g = 0, b = 0, a = 1 })

local ControlGroup = GuiManager.newGroup()
local ControlPanel = GuiManager.newPanel(20, TitleText.y + 200, 400, 600)

local ControlPanelData = {
    {
        text = "W   Z   UP     <- Move up"
    },
    {
        text = "S   DOWN     <- Move down"
    },
    {
        text = "Q   A   LEFT   <- Move left"
    },
    {
        text = "D   RIGHT      <- Move right"
    },
    {
        text = "Mouse Left    <- Shoot"
    },
    {
        text = "Mouse Right  <- Switch Weapon"
    },
}


local ButtonsGroup = GuiManager.newGroup()




local LegendGroup = GuiManager.newGroup()
local LegendPanel = GuiManager.newPanel(860, TitleText.y + 200, 400, 600)
local LegendPanelData = {
    {
        image = love.graphics.newImage("assets/sprites/Hero.png"),
        text = "<- You"
    },
    {
        image = love.graphics.newImage("assets/sprites/Enemy.png"),
        text = "<- Enemy"
    },
    {
        image = love.graphics.newImage("assets/sprites/Boss.png"),
        text = "<- Boss"
    },
    {
        image = love.graphics.newImage("assets/sprites/Bonus_shotgun.png"),
        text = "<- Unlock Shotgun"
    },
    {
        image = love.graphics.newImage("assets/sprites/bonus_heal.png"),
        text = "<- Heal"
    },
    {
        image = love.graphics.newImage("assets/sprites/Bonus_damage.png"),
        text = "<- Increase Damage"
    },
}

local function onPanelHover(pState, obj)
    if pState == "begin" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 60)
    end
    if pState == "end" then
        obj.Label.font = love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50)
    end
end

local function exitGame()
    love.event.quit(0)
end

local function startGame()
    StateManager:switchTo("Gameplay")
end

function StartMenu:enter()
    -- Title definition
    GUIStartMenuGroup:addElement(TitleText)
    -- Controle hint Group definition
    GUIStartMenuGroup:addElement(ControlGroup)
    ControlGroup:addElement(ControlPanel)
    for i = 1, 6 do
        local tmpY = (i - 1) * 100
        if i == 1 then
            tmpY = 0
        end
        local newText = GuiManager.newText(ControlPanel.x + 10, ControlPanel.y + tmpY, 64, 64,
            ControlPanelData[i].text,
            love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25), nil, nil, { r = 0, g = 0, b = 0, a = 1 })
        ControlGroup:addElement(newText)
    end

    -- Buttons Group definition
    GUIStartMenuGroup:addElement(ButtonsGroup)
    local startButton = GuiManager.newButton(500,
        TitleText.y + 200 + 100,
        200,
        100,
        "Start",
        love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50),
        { r = 0, g = 0, b = 0, a = 1 }
    )
    startButton:setEvent("hover", onPanelHover)
    startButton:setEvent("pressed", startGame)
    ButtonsGroup:addElement(startButton)

    local exitButton = GuiManager.newButton(500,
        TitleText.y + 200 + 200,
        200,
        100,
        "Exit",
        love.graphics.newFont("assets/fonts/Harvest Yard.otf", 50),
        { r = 0, g = 0, b = 0, a = 1 }
    )
    exitButton:setEvent("hover", onPanelHover)
    exitButton:setEvent("pressed", exitGame)
    ButtonsGroup:addElement(exitButton)

    -- Legend Group definition
    GUIStartMenuGroup:addElement(LegendGroup)
    LegendGroup:addElement(LegendPanel)
    for i = 1, 6 do
        local tmpY = (i - 1) * 100
        if i == 1 then
            tmpY = 0
        end
        local newPanel = GuiManager.newPanel(LegendPanel.x + 10, LegendPanel.y + tmpY)
        newPanel:setImage(LegendPanelData[i].image)
        local newText = GuiManager.newText(newPanel.x + newPanel.width + 10, LegendPanel.y + tmpY, 64, 64,
            LegendPanelData[i].text,
            love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25), nil, nil, { r = 0, g = 0, b = 0, a = 1 })
        LegendGroup:addElement(newPanel)
        LegendGroup:addElement(newText)
    end
end

function StartMenu:exit()
    FontManager:resetFontSize()
end

function StartMenu:update(dt)
    GUIStartMenuGroup:update(dt)
end

function StartMenu:mousepressed(mouseX, mouseY, mouseButton)
    if mouseButton == 1 then

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

    GUIStartMenuGroup:draw()

    love.graphics.setColor(0, 0, 0)
end

return StartMenu
