local Bonus = {}

function Bonus:new(x, y, choosenBonus)
    local instance = {}
    setmetatable(instance, { __index = Bonus })
    instance.x = x
    instance.y = y
    instance.image = choosenBonus.image
    instance.name = choosenBonus.name
    instance.width = instance.image:getWidth()
    instance.height = instance.image:getHeight()
    instance.radius = instance.width / 2
    instance.scaleX = 1
    instance.scaleY = 1
    instance.angle = 0
    instance.applyBonus = choosenBonus.callback

    return instance
end

function Bonus:draw()
    love.graphics.draw(
        self.image,
        self.x,
        self.y,
        self.angle,
        self.scaleX,
        self.scaleY,
        (self.width / 2),
        (self.height / 2)
    )
end

function Bonus:onHit()
    self:applyBonus()
end

return Bonus
