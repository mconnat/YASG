require("libs.table")
Bullet = require("libs.Bullet")

local Weapon = {}

WeaponCatalog = {
    Shotgun = {
        name = "Shotgun",
        image = love.graphics.newImage("assets/sprites/Shotgun.png"),
        bulletImage = love.graphics.newImage("assets/sprites/DoubleBullet.png"),
        distanceFromHero = 40,
        maxBulletDistance = 150,
        damage = 2
    },
    Pistol = {
        name = "Pistol",
        image = love.graphics.newImage("assets/sprites/Pistol.png"),
        bulletImage = love.graphics.newImage("assets/sprites/Bullet.png"),
        distanceFromHero = 40,
        maxBulletDistance = 300,
        damage = 1
    }
}

function Weapon:new(weaponName, parent)
    local instance = {}
    setmetatable(instance, { __index = Weapon })
    instance.x = 0
    instance.y = 0
    instance.parent = parent
    instance.projectiles = {}
    instance = table.merge(instance, WeaponCatalog[weaponName])
    return instance
end

function Weapon:addProjectile(mouseX, mouseY)
    local newBullet = Bullet:new(mouseX, mouseY, self)
    table.insert(self.projectiles, newBullet)
end

function Weapon:update(dt)
    for i, bullet in ipairs(self.projectiles) do
        bullet.x = bullet.x + math.cos(bullet.angle) * bullet.speed * dt
        bullet.y = bullet.y + math.sin(bullet.angle) * bullet.speed * dt
    end
end

function Weapon:draw()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.parent.angle,
        self.parent.scaleX,
        self.parent.scaleY,
        (self.image:getWidth() / 2),
        (self.image:getHeight() / 2)
    )
    for index, bullet in ipairs(self.projectiles) do
        if math.abs(bullet.originalX - bullet.x) < bullet.distance and math.abs(bullet.originalY - bullet.y) < bullet.distance then
            bullet:draw()
        else
            table.remove(self.projectiles, index)
        end
    end
end

function Weapon:switchTo(weaponName)
    self.name = WeaponCatalog[weaponName].name
    self.image = WeaponCatalog[weaponName].image
    self.distanceFromHero = WeaponCatalog[weaponName].distanceFromHero
    self.maxBulletDistance = WeaponCatalog[weaponName].maxBulletDistance
    self.bulletImage = WeaponCatalog[weaponName].bulletImage
end

return Weapon
