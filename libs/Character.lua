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
    instance.hit = false
    instance.canBeHit = true
    instance.accumulatedInvincibilityTime = 0

    return instance
end

function Character:draw()
    local r, g, b, a = love.graphics.getColor()
    if self.angle > 2 or self.angle < -2 then
        self.scaleY = -1
    else
        self.scaleY = 1
    end
    if self.hit then
        love.graphics.setColor(.7, 0, 0, a)
        self.hit = false
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
    love.graphics.setColor(r, g, b, a)
    if self.weapon ~= nil then
        self.weapon:draw()
    end
    if self.healthPoint ~= self.maxHealthPoint then
        self:DrawHealthBar()
    end
end

function Character:DrawHealthBar()
    local r, g, b, a = love.graphics.getColor()
    local squareSize = 4
    for i = 1, self.maxHealthPoint do
        love.graphics.setColor(0.8, 0, 0, 0.8)
        local rectangleForm = "line"
        if i <= self.healthPoint then
            rectangleForm = "fill"
        end
        love.graphics.rectangle(rectangleForm,
            ((self.x - (squareSize * self.maxHealthPoint) / 2) + ((i - 1) * squareSize)),
            self.y - self.radius - 10, squareSize,
            squareSize)
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("line", ((self.x - (squareSize * self.maxHealthPoint) / 2) + ((i - 1) * squareSize)),
            self.y - self.radius - 10, squareSize,
            squareSize)
    end
    love.graphics.setColor(r, g, b, a)
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
    -- Get angle of the character according to mouse position
    self.angle = math.atan2(mouseY - self.y, mouseX - self.x)

    -- Get weapon position according to the player angle + the distance from the player
    self.weapon.x = (self.weapon.distanceFromHero * math.cos(self.angle)) + self.weapon.parent.x
    self.weapon.y = (self.weapon.distanceFromHero * math.sin(self.angle)) + self.weapon.parent.y

    -- Switch weapon control
    if love.keyboard.isScancodeDown("q") then
        self.weapon.switchTo(self.weapon, "Pistol")
    end
    if love.keyboard.isScancodeDown("e") then
        self.weapon.switchTo(self.weapon, "Shotgun")
    end

    -- Manage keyboard deplacement inputs
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

    -- Keep the player position inside the window
    if self.x + self.radius >= love.graphics.getWidth() then
        self.x = love.graphics.getWidth() - self.radius
    elseif self.x - self.radius <= 0 then
        self.x = self.radius
    end
    if self.y - self.radius <= 0 then
        self.y = self.radius
    elseif self.y + self.radius >= love.graphics.getHeight() then
        self.y = love.graphics.getHeight() - self.radius
    end

    -- function Character:update(dt)
    -- ...
    if self.canBeHit == false then
        self.accumulatedInvincibilityTime = self.accumulatedInvincibilityTime + dt;
        if self.accumulatedInvincibilityTime > 2 then
            self.canBeHit = true
            self.accumulatedInvincibilityTime = 0
        end
    end
end

function Character:checkCollision(enemies)
    for i = 1, #enemies do
        if Utils.CircleCollision(self, enemies[i]) then
            self:onHit(1)
        end
    end
end

function Character:onHit(damage)
    if self.canBeHit and CONFIG.GodMod == false then
        self.healthPoint = self.healthPoint - damage
        self.canBeHit = false
    end
    self.hit = true
end

return Character
