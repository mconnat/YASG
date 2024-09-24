local Character = require("libs.Character")
local StateManager = require("states.StateManager")
local Enemy = require("libs.Enemy")
local Boss = require("libs.Boss")

local Gameplay = {}


local Hero = nil
local Enemies = {}

function Gameplay:enter()
    print("Entering Gameplay")
    if Hero == nil then
        Hero = Character:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    end

    table.insert(Enemies, Enemy:new(100, 200))
    table.insert(Enemies, Enemy:new(200, 100))
    table.insert(Enemies, Enemy:new(500, 200))
    table.insert(Enemies, Boss:new(100, 500))
end

function Gameplay:exit()
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
end

function Gameplay:draw()
    love.graphics.clear(1, 1, 1)
    love.graphics.setColor(1, 1, 1)

    Hero:draw()
    -- Hero.weapon:draw()

    for _, enemy in ipairs(Enemies) do
        enemy:draw()
    end
    if CONFIG.debug then
        local r, g, b, a = love.graphics.getColor()
        love.graphics.setColor(0.2, 0.8, 0.1)
        Hero:drawHitBox()
        Hero:drawCenter()
        love.graphics.setColor(r, g, b, a)
    end
end

return Gameplay
