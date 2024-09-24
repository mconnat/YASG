local Character = require("libs.Character")

local Enemy = {}
setmetatable(Enemy, { __index = Character })

function Enemy:new(x, y)
    local instance = Character:new(x, y)
    setmetatable(instance, { __index = Enemy })
    local image = love.graphics.newImage("assets/sprites/Enemy.png")
    instance.weapon = nil
    instance.healthPoint = 5
    instance.speed = 70
    instance.image = image
    instance.radius = image:getWidth() / 2

    return instance
end

function Enemy:findStartPosition()
end

return Enemy
