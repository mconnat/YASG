local Character = require("libs.Character")
local GameLoopManager = require("libs.GameLoopManager")

local Enemy = {}
setmetatable(Enemy, { __index = Character })

function Enemy:new()
    local instance = Character:new(0, 0)
    setmetatable(instance, { __index = Enemy })
    local image = love.graphics.newImage("assets/sprites/Enemy.png")
    instance.weapon = nil
    instance.healthPoint = 5
    instance.maxHealthPoint = 5
    instance.speed = 30
    instance.image = image
    instance.radius = image:getWidth() / 2
    instance:findStartPosition()
    return instance
end

function Enemy:update(dt, player)
    -- Get angle of the character
    self.angle = math.atan2(player.y - self.y, player.x - self.x)
    -- https://love2d.org/forums/viewtopic.php?p=217897#p217897
    local enemyDirectionX = player.x - self.x
    local enemyDirectionY = player.y - self.y
    local distance = math.sqrt(enemyDirectionX * enemyDirectionX + enemyDirectionY * enemyDirectionY)
    if distance > self.radius * 2 then
        self.x = self.x + enemyDirectionX / distance * self.speed * dt
        self.y = self.y + enemyDirectionY / distance * self.speed * dt
    end
end

function Enemy:findStartPosition()
    local DisplayWidth = love.graphics.getWidth()
    local DisplayHeight = love.graphics.getHeight()
    local randomScreenSide = love.math.random(1, 4)
    if randomScreenSide == 1 then
        self.x = love.math.random(1, DisplayWidth)
        self.y = -self.radius
    elseif randomScreenSide == 2 then
        self.x = DisplayWidth + self.radius
        self.y = love.math.random(1, DisplayHeight)
    elseif randomScreenSide == 3 then
        self.x = love.math.random(1, DisplayWidth)
        self.y = DisplayHeight + self.radius
    else
        self.x = -self.radius
        self.y = love.math.random(1, DisplayHeight)
    end
end

function Enemy:onHit(enemies, enemyIndex, damage)
    self.healthPoint = self.healthPoint - damage
    self.hit = true
    if self.healthPoint <= 0 then
        self:Destroy(enemies, enemyIndex)
    end
end

function Enemy:Destroy(enemies, enemyIndex)
    GameLoopManager.score = GameLoopManager.score + 1
    table.remove(enemies, enemyIndex)
end

return Enemy
