local GodMod = {}
local delay_between_key = 1.5
local last_key_timer = 0
local sequence = { "up", "up", "down", "down", "left", "right", "left", "right" }
local i = 1

function GodMod:cheatcode(key, callback)
    local timer = love.timer.getTime()
    if (timer - last_key_timer) > delay_between_key then
        i = 1
    end

    if sequence[i] == key then
        last_key_timer = timer
        i = i + 1
        if i > #sequence then
            callback()
        end
    else
        i = 1
    end
end

return GodMod
