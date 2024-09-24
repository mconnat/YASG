local Enemy = require("libs.Enemy")

local Boss = {}
setmetatable(Boss, { __index = Enemy })

function Boss:new(x, y)
    local instance = Enemy:new(x, y)
    setmetatable(instance, { __index = Enemy })
    local image = love.graphics.newImage("assets/sprites/Boss.png")
    instance.weapon = nil
    instance.healthPoint = 10
    instance.speed = 70
    instance.image = image
    instance.radius = image:getWidth() / 2

    return instance
end

return Boss
