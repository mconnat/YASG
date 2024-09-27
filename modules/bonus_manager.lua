local WeaponCatalog = require("modules.weapon_catalog")
local Utils = require("libs.utils")
local Bonus = require("classes.bonus")
local Hero = require("modules.hero")
local BonusManager = {}

local function applyDamageBonus()
    BonusManager.DamageBonusCount = BonusManager.DamageBonusCount + 1
    Hero:setBonusDamage(BonusManager.DamageBonusCount)
end

local function applyHealthBonus()
    if Hero.maxHealthPoint - Hero.currentHealthPoint <= 1 then
        Hero.currentHealthPoint = Hero.maxHealthPoint
    else
        Hero.currentHealthPoint = Hero.currentHealthPoint + 2
    end
end

local function applyShotgunBonus()
    for i = 1, #WeaponCatalog do
        if WeaponCatalog[i].name == "Shotgun" then
            WeaponCatalog[i].unlocked = true
        end
    end
end

BonusManager.BonusCatalog = {
    Shotgun = {
        name = "Shotgun",
        image = love.graphics.newImage("assets/sprites/bonus_shotgun.png"),
        callback = applyShotgunBonus
    },
    Damage = {
        name = "Double Damage",
        image = love.graphics.newImage("assets/sprites/bonus_damage.png"),
        callback = applyDamageBonus,
    },
    Heal = {
        name = "Heal",
        image = love.graphics.newImage("assets/sprites/bonus_heal.png"),
        callback = applyHealthBonus

    }
}

BonusManager.BonusPool = {}
BonusManager.DamageBonusCount = 0



function BonusManager:update()
    for i = 1, #BonusManager.BonusPool do
        if BonusManager.BonusPool[i] ~= nil then
            if Utils.CircleCollision(BonusManager.BonusPool[i], Hero) then
                BonusManager.BonusPool[i]:onHit()
                table.remove(BonusManager.BonusPool, i)
            end
        end
    end
end

function BonusManager:newBonus(x, y, choosenBonus)
    local freshBonus = Bonus:new(x, y, choosenBonus)
    return freshBonus
end

local function NotInBonusPool(bonus)
    for _, b in ipairs(BonusManager.BonusPool) do
        if b.name == bonus.name then
            return false
        end
    end
    return true
end

function BonusManager:chooseBonus(Hero)
    local tmpBonuses = {}
    if Hero.currentHealthPoint < Hero.maxHealthPoint then
        table.insert(tmpBonuses, BonusManager.BonusCatalog["Heal"])
    end
    for i, w in ipairs(WeaponCatalog) do
        if w.name == "Shotgun" and w.unlocked == false and NotInBonusPool(w) then
            table.insert(tmpBonuses, BonusManager.BonusCatalog["Shotgun"])
        end
    end
    table.insert(tmpBonuses, BonusManager.BonusCatalog["Damage"])

    local choosenBonusIndex = love.math.random(1, #tmpBonuses)
    return tmpBonuses[choosenBonusIndex]
end

return BonusManager
