local GuiManager = {}

function GuiManager.newGroup()
    local instance = {}
    instance.elements = {}

    function instance:addElement(elem)
        table.insert(self.elements, elem)
    end

    function instance:setVisible(visible)
        for n, v in pairs(instance.elements) do
            if v.setVisible then
                v:setVisible(visible)
            end
        end
    end

    function instance:draw()
        for n, v in pairs(instance.elements) do
            if v.draw then
                v:draw()
            end
        end
    end

    return instance
end

local function newElement(x, y)
    local instance = {}
    instance.x = x
    instance.y = y
    function instance:draw()
        print("newElement / draw / Not implemented")
    end

    function instance:setVisible(visible)
        self.visible = visible
    end

    return instance
end

function GuiManager.newPanel(x, y, width, height)
    local instance = newElement(x, y)
    instance.width = width
    instance.height = height
    instance.image = nil

    function instance:setImage(image)
        self.image = image
        self.width = image:getWidth()
        self.height = image:getHeight()
    end

    function instance:drawPanel()
        local r, g, b, a = love.graphics.getColor()
        if self.image == nil then
            love.graphics.setColor(0.8, 0.8, 0.8, 1)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(self.image, self.x, self.y)
        end
        love.graphics.setColor(r, g, b, a)
    end

    function instance:draw()
        if self.visible == false then return end
        self:drawPanel()
    end

    return instance
end

function GuiManager.newText(x, y, width, height, text, font, color)
    local instance = GuiManager.newPanel(x, y, width, height)
    instance.text = text
    instance.font = font
    instance.textWidth = font:getWidth(text)
    instance.textHeight = font:getHeight(text)


    if color ~= nil then
        if color.r and color.g and color.b and color.a then
            love.graphics.setColor(color.r, color.g, color.b, color.a)
        end
    end

    function instance:drawText()
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(self.font)
        love.graphics.print(self.text, self.x, self.y)
        love.graphics.setColor(1, 1, 1)
    end

    function instance:draw()
        if self.visible == false then return end
        self:drawText()
    end

    return instance
end

return GuiManager
