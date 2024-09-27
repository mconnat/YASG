local Character = require("classes.character")
local GameplayManager = require("modules.gameplay_manager")

local Enemy = {}
setmetatable(Enemy, { __index = Character })

function Enemy:new()
    local instance = Character:new(0, 0)
    setmetatable(instance, { __index = Enemy })

    instance.currentHealthPoint = 5
    instance.maxHealthPoint = 5
    instance.speed = 30
    instance.image = love.graphics.newImage("assets/sprites/Enemy.png")
    instance.radius = instance.image:getWidth() / 2
    instance:randomizeStartPosition()
    return instance
end

function Enemy:update(dt, player)
    -- Get angle of the character
    self.angle = math.atan2(player.y - self.y, player.x - self.x)
    -- Compute distance between player center and enemy center then
    -- Make the enemy move forward the player according to the speed
    -- If the enemy enter the radius of the player, deny next mouvement
    -- https://love2d.org/forums/viewtopic.php?p=217897#p217897
    local enemyDirectionX = player.x - self.x
    local enemyDirectionY = player.y - self.y
    local distance = math.sqrt(enemyDirectionX * enemyDirectionX + enemyDirectionY * enemyDirectionY)
    if distance > self.radius * 2 then
        self.x = self.x + enemyDirectionX / distance * self.speed * dt
        self.y = self.y + enemyDirectionY / distance * self.speed * dt
    end
end

function Enemy:randomizeStartPosition()
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
    self.currentHealthPoint = self.currentHealthPoint - damage
    self.hit = true
    if self.currentHealthPoint <= 0 then
        self:Destroy(enemies, enemyIndex)
    end
end

function Enemy:Destroy(enemies, enemyIndex)
    GameplayManager.score = GameplayManager.score + 1
    table.remove(enemies, enemyIndex)
end

return Enemy
