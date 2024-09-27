require("libs.table")
Bullet = require("classes.bullet")
WeaponCatalog = require("modules.weapon_catalog")
local Weapon = {}


function Weapon:init(weaponName, parent)
    setmetatable(self, { __index = Weapon })
    self.x = 0
    self.y = 0
    self.parent = parent
    self.projectiles = {}
    self = table.merge(self, WeaponCatalog[1])
end

function Weapon:addProjectile(mouseX, mouseY, bonusDamageCount)
    local newBullet = Bullet:new(mouseX, mouseY, self, bonusDamageCount)
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
            bullet:Destroy(index)
        end
    end
end

function Weapon:switchWeapon()
    local weaponIndex = 1
    local tmpCatalog = {}
    for i = 1, #WeaponCatalog do
        if WeaponCatalog[i].unlocked then
            table.insert(tmpCatalog, WeaponCatalog[i])
        end
    end
    for i = 1, #tmpCatalog do
        if tmpCatalog[i].name == self.name then
            weaponIndex = i
        end
    end
    if weaponIndex == #tmpCatalog then
        self = table.merge(self, tmpCatalog[1])
    else
        self = table.merge(self, tmpCatalog[weaponIndex + 1])
    end
end

return Weapon
