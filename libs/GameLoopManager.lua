local StateManager = require("states.StateManager")


local GameLoopManager = {}

GameLoopManager.score = 0
GameLoopManager.maxScore = 200
GameLoopManager.currentHealtPoint = 0
GameLoopManager.maxHealthPoint = 0
GameLoopManager.canSpawnBoss = true


function GameLoopManager:init(Hero)
    GameLoopManager.currentHealtPoint = Hero.healthPoint
    GameLoopManager.maxHealthPoint = Hero.maxHealthPoint
end

function GameLoopManager:reset()
    GameLoopManager.score = 0
end

function GameLoopManager:update(Hero)
    GameLoopManager.currentHealtPoint = Hero.healthPoint

    if GameLoopManager.currentHealtPoint <= 0 then
        StateManager:switchTo("EndGame")
    end

    if GameLoopManager.score == GameLoopManager.maxScore then
        StateManager:switchTo("EndGame")
    end
end

return GameLoopManager
