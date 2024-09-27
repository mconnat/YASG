local Character = require("classes.character")
local Enemy = require("classes.enemy")
local Boss = require("classes.boss")
local Hero = require("modules.hero")
local GameplayManager = require("modules.gameplay_manager")
local GuiManager = require("modules.gui_manager")
local BonusManager = require("modules.bonus_manager")


local Gameplay = {}


local Enemies = {}
local HUD = GuiManager.newGroup()
local HUDScorePanel = GuiManager.newText(50,
    30,
    100,
    50,
    "",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25),
    nil,
    nil,
    { r = 0, g = 0, b = 0, a = 1 })
HUD:addElement(HUDScorePanel)

local HUDselectedWeaponCase = GuiManager.newPanel(love.graphics.getWidth() / 3 - 2, 30, 37, 37)
HUDselectedWeaponCase:setColor({ r = 0, g = 0, b = 0, a = 1 })
HUDselectedWeaponCase:setMode("line")
HUD:addElement(HUDselectedWeaponCase)

local HUDselectedWeapon = GuiManager.newPanel(love.graphics.getWidth() / 3, 30)
HUDselectedWeapon:setImage(love.graphics.newImage("assets/sprites/Pistol.png"), 2)
HUD:addElement(HUDselectedWeapon)


local HUDbonusCase = GuiManager.newPanel(love.graphics.getWidth() / 2 + 50 - 2, 30, 37, 37)
HUDbonusCase:setColor({ r = 0, g = 0, b = 0, a = 1 })
HUDbonusCase:setMode("line")
HUD:addElement(HUDbonusCase)

local HUDbonusLogo = GuiManager.newPanel(love.graphics.getWidth() / 2 + 50, 32)
HUDbonusLogo:setImage(love.graphics.newImage("assets/sprites/Bonus_damage.png"))
HUD:addElement(HUDbonusLogo)

local HUDbonusCount = GuiManager.newText(love.graphics.getWidth() / 2 + 50 + 50,
    32,
    100,
    50,
    "x 0",
    love.graphics.newFont("assets/fonts/Harvest Yard.otf", 25),
    nil,
    nil,
    { r = 0, g = 0, b = 0, a = 1 }
)
HUD:addElement(HUDbonusCount)


function Gameplay:enter()
    GameplayManager:reset()

    Hero:init(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)


    GameplayManager:init(Hero)
end

function Gameplay:exit()
    Enemies = {}
end

function Gameplay:mousepressed(x, y, button)
    if button == 1 then
        Hero.weapon:addProjectile(x, y, Hero.damageBonusCount)
    end
    if button == 2 then
        Hero.weapon:switchWeapon()
    end
end

function Gameplay:keypressed(key, scancode, isrepeat)

end

function Gameplay:update(dt)
    -- Refresh Enemies numbers
    GameplayManager.currentEnemyNumber = #Enemies
    if GameplayManager.currentEnemyNumber < GameplayManager.maxEnemyNumber then
        while GameplayManager.currentEnemyNumber ~= GameplayManager.maxEnemyNumber do
            GameplayManager.currentEnemyNumber = #Enemies
            table.insert(Enemies, Enemy:new())
        end
    end
    if GameplayManager.score % GameplayManager.spawnBossKillThreshold == 0 and GameplayManager.canSpawnBoss and GameplayManager.score ~= 0 then
        table.insert(Enemies, Boss:new())
        table.insert(Enemies, Boss:new())
        GameplayManager.canSpawnBoss = false
        GameplayManager.maxEnemyNumber = GameplayManager.maxEnemyNumber + 20
    end
    if GameplayManager.score % GameplayManager.spawnBossKillThreshold ~= 0 then
        GameplayManager.canSpawnBoss = true
    end

    -- Update Hero and his weapon
    Hero:update(dt, Enemies)

    -- Manage Bonus collision
    BonusManager:update()

    -- Update Bullets
    for bulletIndex = #Hero.weapon.projectiles, 1, -1 do
        Hero.weapon.projectiles[bulletIndex]:update(Enemies, bulletIndex)
    end

    for i = 1, #Enemies do
        Enemies[i]:update(dt, Hero)
    end


    GameplayManager:update(Hero)
    HUDScorePanel.text = GameplayManager.score .. " over " .. GameplayManager.maxScore
    HUDbonusCount.text = "x " .. BonusManager.DamageBonusCount
    HUDselectedWeapon:setImage(Hero.weapon.image, 2)
end

function Gameplay:draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(1, 1, 1)
    for _, bonus in ipairs(BonusManager.BonusPool) do
        bonus:draw()
    end
    for _, enemy in ipairs(Enemies) do
        enemy:draw()
    end
    Hero:draw()
    HUD:draw()

    love.graphics.setColor(1, 1, 1)
end

return Gameplay
