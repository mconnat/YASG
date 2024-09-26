local Character = require("classes.character")
local Enemy = require("classes.enemy")
local Boss = require("classes.boss")
local Hero = require("modules.hero")
local GameplayManager = require("modules.gameplay")
local GuiManager = require("modules.gui_manager")
local FontManager = require("libs.fonts")


local Gameplay = {}


local Enemies = {}
local HUDGroup = {}
local panel = GuiManager.newPanel(5, 5, love.graphics.getWidth() - 10, 50)
local font = FontManager.Font
local scoreText = GuiManager.newText(
    panel.x + 20,
    panel.y + 10, 70, 40,
    "Enemies: " .. tostring(GameplayManager.score) .. " over " .. tostring(GameplayManager.maxScore),
    font
)
local selectedWeapon = {}

function Gameplay:enter()
    GameplayManager:reset()

    Hero:init(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    table.dump(Hero)

    GameplayManager:init(Hero)

    HUDGroup = GuiManager.newGroup()
    selectedWeapon = GuiManager.newPanel(panel.width / 2, panel.height / 2, Hero.weapon.image)
    HUDGroup:addElement(panel)
    HUDGroup:addElement(scoreText)
    HUDGroup:addElement(selectedWeapon)
end

function Gameplay:exit()
    Enemies = {}
end

function Gameplay:mousepressed(x, y, button)
    if button == 1 then
        Hero.weapon:addProjectile(x, y)
    end
    if button == 2 then
        Hero.weapon:switchWeapon()
    end
end

function Gameplay:keypressed(key, scancode, isrepeat)

end

function Gameplay:update(dt)
    GameplayManager.currentEnemyNumber = #Enemies

    Hero:update(dt)
    Hero.weapon:update(dt)
    for bulletIndex = #Hero.weapon.projectiles, 1, -1 do
        Hero.weapon.projectiles[bulletIndex]:update(Enemies, bulletIndex)
    end

    scoreText.text = "Enemies: " ..
        tostring(GameplayManager.score) .. " over " .. tostring(GameplayManager.maxScore)
    selectedWeapon:setImage(Hero.weapon.image)
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
    for i = 1, #Enemies do
        Enemies[i]:update(dt, Hero)
    end
    Hero:checkCollision(Enemies)

    GameplayManager:update(Hero)
end

function Gameplay:draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(1, 1, 1)
    for _, enemy in ipairs(Enemies) do
        enemy:draw()
    end
    Hero:draw()

    HUDGroup:draw()

    -- love.graphics.setColor(0, 0, 0.1)
    -- love.graphics.print(GameplayManager.score, 10, 10)
    love.graphics.setColor(1, 1, 1)
end

return Gameplay
