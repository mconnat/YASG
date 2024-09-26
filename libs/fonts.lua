local FontManager = {}
FontManager.fontFile = "assets/fonts/Harvest Yard.otf"
FontManager.defaultFontSize = 25
FontManager.Font = love.graphics.newFont(FontManager.fontFile, FontManager.defaultFontSize)

---@param size number font size value in pixels
function FontManager:setFontSize(size)
    self.Font = love.graphics.newFont(self.fontFile, size)
    love.graphics.setFont(self.Font)
end

---Set default font size
function FontManager:resetFontSize()
    self.Font = love.graphics.newFont(self.fontFile, self.defaultFontSize)
    love.graphics.setFont(self.Font)
end

return FontManager
