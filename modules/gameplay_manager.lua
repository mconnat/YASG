local StateManager = require("states.state_manager")
local BonusManager = require("modules.bonus_manager")
local Hero = require("modules.hero")


local GameplayManager = {}

GameplayManager.score = 0
GameplayManager.maxScore = 100
GameplayManager.currentHealthPoint = 0
GameplayManager.maxHealthPoint = 0
GameplayManager.canSpawnBoss = true
GameplayManager.maxEnemyNumber = 10
GameplayManager.currentEnemyNumber = 0
GameplayManager.spawnBossKillThreshold = 10

function GameplayManager:init(Hero)
    GameplayManager.currentHealthPoint = Hero.currentHealthPoint
    GameplayManager.maxHealthPoint = Hero.maxHealthPoint
end

function GameplayManager:reset()
    GameplayManager.score = 0
    GameplayManager.maxScore = 100
    GameplayManager.currentHealthPoint = 0
    GameplayManager.maxHealthPoint = 0
    GameplayManager.canSpawnBoss = true
    GameplayManager.maxEnemyNumber = 10
    GameplayManager.currentEnemyNumber = 0
    GameplayManager.spawnBossKillThreshold = 10
    BonusManager.BonusPool = {}
    BonusManager.DamageBonusCount = 0
    for i = 1, #WeaponCatalog do
        if WeaponCatalog[i].name == "Shotgun" then
            WeaponCatalog[i].unlocked = false
        end
    end
end

function GameplayManager:addBonus(x, y)
    local choosenBonus = BonusManager:chooseBonus(Hero)
    local newBonus = BonusManager:newBonus(x, y, choosenBonus)
    table.insert(BonusManager.BonusPool, newBonus)
end

function GameplayManager:update(Hero)
    GameplayManager.currentHealthPoint = Hero.currentHealthPoint

    if GameplayManager.currentHealthPoint <= 0 or GameplayManager.score == GameplayManager.maxScore then
        StateManager:switchTo("EndGame")
    end
end

return GameplayManager
