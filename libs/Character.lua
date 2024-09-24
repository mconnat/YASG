local Weapon = require("libs.Weapon")

local Character = {}

function Character:new(x, y)
    local instance = {}
    setmetatable(instance, { __index = Character })
    local image = love.graphics.newImage("assets/sprites/Hero.png")
    instance.x = x
    instance.y = y
    instance.image = image
    instance.scaleX = 1
    instance.scaleY = 1
    instance.angle = 0
    instance.radius = image:getWidth() / 2
    instance.speed = 150
    instance.weapon = Weapon:new("Pistol", instance)
    instance.healthPoint = 10
    instance.maxHealthPoint = 10

    return instance
end

function Character:draw()
    if self.angle > 2 or self.angle < -2 then
        self.scaleY = -1
    else
        self.scaleY = 1
    end

    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.angle,
        self.scaleX,
        self.scaleY,
        (self.image:getWidth() / 2),
        (self.image:getHeight() / 2)
    )
    if self.weapon ~= nil then
        self.weapon:draw()
    end
    if self.healthPoint ~= self.maxHealthPoint then
        self:DrawHealthBar()
    end
end

function Character:DrawHealthBar()
    local squareSize = 4
    local r, g, b = 0, 0, 0
    local alpha = 1
    for i = 1, self.maxHealthPoint do
        love.graphics.rectangle("fill", self.x, self.y + self.radius + 30, squareSize,
            squareSize)
    end
end

function Character:drawCenter()
    love.graphics.circle("fill", self.x,
        self.y, 3)
end

function Character:drawHitBox()
    love.graphics.circle("line", self.x,
        self.y, self.radius)
end

function Character:getPosition()
    return self.x, self.y
end

function Character:update(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    self.angle = math.atan2(mouseY - self.y, mouseX - self.x)
    self.weapon.x = (self.weapon.distanceFromHero * math.cos(self.angle)) + self.weapon.parent.x
    self.weapon.y = (self.weapon.distanceFromHero * math.sin(self.angle)) + self.weapon.parent.y
    if love.keyboard.isScancodeDown("d") then
        self.x = self.x + (self.speed * dt)
    end
    if love.keyboard.isScancodeDown("a") then
        self.x = self.x - (self.speed * dt)
    end
    if love.keyboard.isScancodeDown("w") then
        self.y = self.y - (self.speed * dt)
    end
    if love.keyboard.isScancodeDown("s") then
        self.y = self.y + (self.speed * dt)
    end
    if love.keyboard.isScancodeDown("q") then
        self.weapon.switchTo(self.weapon, "Pistol")
    end
    if love.keyboard.isScancodeDown("e") then
        self.weapon.switchTo(self.weapon, "Shotgun")
    end
end

function Character:onHit(enemies, enemyIndex, damage)
    self.healthPoint = self.healthPoint - damage
    if self.healthPoint <= 0 then
        self:Destroy(enemies, enemyIndex)
    end
end

function Character:Destroy(enemies, enemyIndex)
    table.remove(enemies, enemyIndex)
end

return Character
