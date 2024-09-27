local Character = require("classes.character")
local Weapon = require("modules.weapon")

local Hero = {}
Hero = Character.new(0, 0)
Hero.image = nil
Hero.radius = nil
Hero.weapon = nil
Hero.currentHealthPoint = nil
Hero.maxHealthPoint = nil
Hero.canBeHit = nil
Hero.accumulatedInvincibilityTime = nil

setmetatable(Hero, { __index = Character })

function Hero:init(x, y)
    Hero.x = x
    Hero.y = y
    Hero.image = love.graphics.newImage("assets/sprites/Hero.png")
    Hero.radius = Hero.image:getWidth() / 2
    Hero.weapon = Weapon
    Hero.currentHealthPoint = 10
    Hero.maxHealthPoint = 10
    Hero.canBeHit = true
    Hero.accumulatedInvincibilityTime = 0
    Hero.damageBonusCount = 0
    Hero.weapon:init(1, Hero)
end

function Hero:setBonusDamage(bonusCount)
    self.damageBonusCount = bonusCount
end

function Hero:update(dt, enemies)
    local mouseX, mouseY = love.mouse.getPosition()
    -- Get angle of the character according to mouse position
    self.angle = math.atan2(mouseY - self.y, mouseX - self.x)

    -- Get weapon position according to the player angle + the distance from the player
    self.weapon.x = (self.weapon.distanceFromHero * math.cos(self.angle)) + self.weapon.parent.x
    self.weapon.y = (self.weapon.distanceFromHero * math.sin(self.angle)) + self.weapon.parent.y

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

    -- Check collision with enemies
    self:checkCollision(enemies)

    -- update Hero's weapon
    self.weapon:update(dt)

    -- Check if the Hero has been hit in the previous 2 second
    -- if yes, stay invulnerable
    if self.canBeHit == false then
        self.accumulatedInvincibilityTime = self.accumulatedInvincibilityTime + dt;
        if self.accumulatedInvincibilityTime > 2 then
            self.canBeHit = true
            self.accumulatedInvincibilityTime = 0
        end
    end
end

function Hero:checkCollision(enemies)
    for i = 1, #enemies do
        if Utils.CircleCollision(self, enemies[i]) then
            self:onHit(1)
        end
    end
end

function Hero:onHit(damage)
    if self.canBeHit and CONFIG.GodMod == false then
        self.currentHealthPoint = self.currentHealthPoint - damage
        self.canBeHit = false
    end
    self.hit = true
end

return Hero
