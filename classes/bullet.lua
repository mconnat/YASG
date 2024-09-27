Utils = require("libs.utils")

local Bullet = {}

function Bullet:new(mouseX, mouseY, weapon, bonusDamageCount)
    local instance = {}
    setmetatable(instance, { __index = Bullet })
    local angle = math.atan2(mouseY - weapon.parent.y, mouseX - weapon.parent.x)
    local distanceFromGun = 10
    instance.x = weapon.x + (distanceFromGun * math.cos(angle))
    instance.y = weapon.y + (distanceFromGun * math.sin(angle))
    instance.originalX = weapon.parent.x
    instance.originalY = weapon.parent.y
    instance.distance = weapon.maxBulletDistance
    instance.angle = angle
    instance.image = weapon.bulletImage
    instance.scale = 1
    instance.speed = 200
    instance.damage = weapon.damage + bonusDamageCount
    instance.width = weapon.bulletImage:getWidth()
    instance.height = weapon.bulletImage:getHeight()
    instance.parent = weapon
    instance.hit = false
    return instance
end

function Bullet:drawHitbox()
    love.graphics.push()
    love.graphics.setColor(0.2, 0.8, 0.1)
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.angle)
    love.graphics.rectangle("line", -self.image:getWidth() / 2, -self.image:getHeight() / 2, self.image:getWidth(),
        self.image:getHeight())
    love.graphics.pop()
end

function Bullet:update(enemies, bulletIndex)
    for i = #enemies, 1, -1 do
        if Utils.CircleAndRectangleOverlap(enemies[i].x, enemies[i].y, enemies[i].radius, self.x, self.y, self.width, self.height) then
            enemies[i]:onHit(enemies, i, self.damage)
            self:Destroy(bulletIndex)
        end
    end
end

function Bullet:draw()
    love.graphics.draw(self.image, self.x, self.y, self.angle, self.scale, self.scale,
        self.image:getWidth() / 2,
        self.image:getHeight() / 2)
    if CONFIG.debug then
        self:drawHitbox()
    end
end

function Bullet:Destroy(index)
    table.remove(self.parent.projectiles, index)
end

return Bullet
