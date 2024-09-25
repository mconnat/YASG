GameLoopManager = require("libs.GameLoopManager")

local GUI = {}



function GUI:update(Hero)
    GUI.score = GameLoopManager.score
    GUI.maxScore = GameLoopManager.maxScore
    GUI.currentWeapon = Hero.weapon
end

function GUI:draw()

end

return GUI
