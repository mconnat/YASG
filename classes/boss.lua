local Enemy = require("classes.enemy")
local GameplayManager = require("modules.gameplay")

local Boss = {}
setmetatable(Boss, { __index = Enemy })

function Boss:new(x, y)
    local instance = Enemy:new()
    setmetatable(instance, { __index = Boss })
    instance.currentHealthPoint = 10
    instance.maxHealthPoint = 10
    instance.speed = 80
    instance.image = love.graphics.newImage("assets/sprites/Boss.png")
    instance.radius = instance.image:getWidth() / 2
    instance:randomizeStartPosition()

    return instance
end

function Boss:dropBonus()
    -- TODO Find a way to add bonus
end

function Boss:Destroy(enemies, enemyIndex)
    GameplayManager.score = GameplayManager.score + 1
    table.remove(enemies, enemyIndex)
    self:dropBonus()
end

return Boss
