local StateManager = require("states.state_manager")


local GameplayManager = {}

GameplayManager.score = 0
GameplayManager.maxScore = 200
GameplayManager.currentHealthPoint = 0
GameplayManager.maxHealthPoint = 0
GameplayManager.canSpawnBoss = true
GameplayManager.maxEnemyNumber = 10
GameplayManager.currentEnemyNumber = 0
GameplayManager.spawnBossKillThreshold = 30


function GameplayManager:init(Hero)
    GameplayManager.currentHealthPoint = Hero.currentHealthPoint
    GameplayManager.maxHealthPoint = Hero.maxHealthPoint
end

function GameplayManager:reset()
    GameplayManager.score = 0
end

function GameplayManager:update(Hero)
    GameplayManager.currentHealthPoint = Hero.currentHealthPoint

    print("currentHealthPoint " .. tostring(GameplayManager.currentHealthPoint))
    print("score " .. tostring(GameplayManager.score))
    print("maxScore " .. tostring(GameplayManager.maxScore))
    if GameplayManager.currentHealthPoint <= 0 or GameplayManager.score == GameplayManager.maxScore then
        StateManager:switchTo("EndGame")
    end
end

return GameplayManager
