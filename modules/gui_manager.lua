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

    function instance:update(dt)
        for n, v in pairs(instance.elements) do
            v:update(dt)
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

    function instance:update(dt)
        print("newElement / update / Not implemented")
    end

    return instance
end

function GuiManager.newPanel(x, y, width, height)
    local instance = newElement(x, y)
    instance.width = width
    instance.height = height
    instance.image = nil
    instance.mode = "fill"
    instance.scale = 1
    instance.color = { r = 1, g = 1, b = 1, a = 1 }
    instance.isHover = false
    instance.lstEvents = {}

    function instance:setEvent(pEventType, pFunction)
        self.lstEvents[pEventType] = pFunction
    end

    function instance:setImage(image, scale)
        self.image = image
        self.width = image:getWidth()
        self.height = image:getHeight()
        if scale ~= nil then
            self.scale = scale
        else
            self.scale = 1
        end
    end

    function instance:setMode(mode)
        self.mode = mode
    end

    function instance:setColor(color)
        self.color = color
    end

    function instance:update(dt)
        self:updatePanel()
    end

    function instance:updatePanel(dt)
        local mx, my = love.mouse.getPosition()
        if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height then
            if self.isHover == false then
                self.isHover = true
                if self.lstEvents["hover"] ~= nil then
                    self.lstEvents["hover"]("begin", self)
                end
            end
        else
            if self.isHover == true then
                self.isHover = false
                if self.lstEvents["hover"] ~= nil then
                    self.lstEvents["hover"]("end", self)
                end
            end
        end
    end

    function instance:drawPanel()
        love.graphics.push()
        if self.image == nil and self.color ~= nil then
            if self.color.r and self.color.g and self.color.b and self.color.a then
                love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
            end
            love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height)
        else
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.draw(self.image, self.x, self.y, 0, self.scale, self.scale)
        end
        love.graphics.pop()
    end

    function instance:draw()
        if self.visible == false then return end
        self:drawPanel()
    end

    return instance
end

function GuiManager.newText(x, y, width, height, text, font, hAlign, vAlign, color)
    local instance = GuiManager.newPanel(x, y, width, height)
    instance.text = text
    instance.font = font
    instance.textWidth = instance.font:getWidth(text)
    instance.textHeight = instance.font:getHeight(text)
    instance.hAlign = hAlign
    instance.vAlign = vAlign
    instance.color = nil


    if color ~= nil then
        if color.r and color.g and color.b and color.a then
            love.graphics.setColor(color.r, color.g, color.b, color.a)
        end
    end

    function instance:drawText()
        love.graphics.push()
        if color ~= nil then
            if color.r and color.g and color.b and color.a then
                love.graphics.setColor(color.r, color.g, color.b, color.a)
            end
        end
        love.graphics.setFont(self.font)
        local tmpX = self.x
        local tmpY = self.y
        if self.hAlign == "center" then
            tmpX = tmpX + ((self.width - self.textWidth) / 2)
        end
        if self.vAlign == "center" then
            tmpY = tmpY + ((self.height - self.textHeight) / 2)
        end
        love.graphics.print(self.text, tmpX, tmpY)
        love.graphics.pop()
    end

    function instance:draw()
        if self.visible == false then return end
        self:drawText()
    end

    return instance
end

function GuiManager.newButton(pX, pY, pW, pH, pText, pFont, pColor)
    local instance = GuiManager.newPanel(pX, pY, pW, pH)
    instance.Text = pText
    instance.Font = pFont
    instance.Label = GuiManager.newText(pX, pY, pW, pH, pText, pFont,
        "center", "center", pColor)
    instance.isPressed = false
    instance.oldButtonState = false
    instance.imgDefault = nil
    instance.imgHover = nil
    instance.imgPressed = nil

    function instance:setImages(pImageDefault, pImageHover, pImagePressed)
        self.imgDefault = pImageDefault
        self.imgHover = pImageHover
        self.imgPressed = pImagePressed
        self.width = pImageDefault:getWidth()
        self.height = pImageDefault:getHeight()
    end

    function instance:draw()
        love.graphics.setColor(1, 1, 1)
        if self.isPressed then
            if self.imgPressed == nil then
                self:drawPanel()
                love.graphics.setColor(1, 1, 1, .5)
                love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
            else
                love.graphics.draw(self.imgPressed, self.x, self.y)
            end
        elseif self.isHover then
            if self.imgHover == nil then
                self:drawPanel()
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("line",
                    self.x + 2, self.y + 2, self.width - 4, self.height - 4)
            else
                love.graphics.draw(self.imgHover, self.x, self.y)
            end
        else
            if self.imgDefault == nil then
                self:drawPanel()
            else
                love.graphics.draw(self.imgDefault, self.x, self.y)
            end
        end
        self.Label:draw()
    end

    function instance:update(dt)
        self:updatePanel(dt)
        if self.isHover and love.mouse.isDown(1) and
            self.isPressed == false and
            self.oldButtonState == false then
            self.isPressed = true
            if self.lstEvents["pressed"] ~= nil then
                self.lstEvents["pressed"]("begin", self)
            end
        else
            if self.isPressed == true and love.mouse.isDown(1) == false then
                self.isPressed = false
                if self.lstEvents["pressed"] ~= nil then
                    self.lstEvents["pressed"]("end")
                end
            end
        end


        self.oldButtonState = love.mouse.isDown(1)
    end

    return instance
end

return GuiManager
