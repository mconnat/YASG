local MyObj = {}

function MyObj:new(x, y, image)
    local instance = {}
    instance.x = 0
    instance.y = 0
    instance.image = nil
    setmetatable(instance, { __index = MyObj })
    return instance
end

function Destroy(bonuses, index, callback, Hero)
end

return MyObj
