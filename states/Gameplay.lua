local Character = require("libs.Character")
local Enemy = require("libs.Enemy")
local Boss = require("libs.Boss")
local GameLoopManager = require("libs.GameLoopManager")

local Gameplay = {}


local Hero = nil
local Enemies = {}


function Gameplay:enter()
    GameLoopManager:reset()
    if Hero == nil then
        Hero = Character:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end
    GameLoopManager:init(Hero)
end

function Gameplay:exit()
    Enemies = {}
    Hero = nil
    print("Exiting Gameplay")
end

function Gameplay:mousepressed(x, y, button)
    if button == 1 then
        Hero.weapon:addProjectile(x, y)
    end
end

function Gameplay:keypressed(key, scancode, isrepeat)

end

function Gameplay:update(dt)
    if Hero ~= nil then
        Hero:update(dt)
        Hero.weapon:update(dt)
        for bulletIndex = #Hero.weapon.projectiles, 1, -1 do
            Hero.weapon.projectiles[bulletIndex]:update(Enemies, bulletIndex)
        end
    end
    if #Enemies < 50 then
        while #Enemies ~= 50 do
            table.insert(Enemies,
                Enemy:new())
        end
    end
    if GameLoopManager.score % 50 == 0 and GameLoopManager.canSpawnBoss and GameLoopManager.score ~= 0 then
        table.insert(Enemies, Boss:new())
        table.insert(Enemies, Boss:new())
        GameLoopManager.canSpawnBoss = false
    end
    if GameLoopManager.score % 50 ~= 0 then
        GameLoopManager.canSpawnBoss = true
    end
    for i = 1, #Enemies do
        Enemies[i]:update(dt, Hero)
    end
    Hero:checkCollision(Enemies)

    GameLoopManager:update(Hero)
end

function Gameplay:draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(1, 1, 1)
    for _, enemy in ipairs(Enemies) do
        enemy:draw()
    end
    Hero:draw()


    if CONFIG.debug then
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(0.2, 0.8, 0.1)
        Hero:drawHitBox()
        Hero:drawCenter()
        love.graphics.setColor(r, g, b, a)
    end
    love.graphics.setColor(0, 0, 0.1)
    love.graphics.print(GameLoopManager.score, 10, 10)
    love.graphics.setColor(1, 1, 1)
end

return Gameplay
