local StateManager = {}
StateManager.states = {}
StateManager.currentState = nil

function StateManager:addState(name, state)
    self.states[name] = state
end

function StateManager:switchTo(name)
    if self.currentState and self.currentState.exit then
        self.currentState:exit()
    end

    self.currentState = self.states[name]

    if self.currentState and self.currentState.enter then
        self.currentState:enter()
    end
end

function StateManager:update(dt)
    if self.currentState and self.currentState.update then
        self.currentState:update(dt)
    end
end

function StateManager:mousepressed(x, y, button)
    if self.currentState and self.currentState.mousepressed then
        self.currentState:mousepressed(x, y, button)
    end
end

function StateManager:keypressed(key, scancode, isrepeat)
    if self.currentState and self.currentState.mousepressed then
        self.currentState:keypressed(key, scancode, isrepeat)
    end
end

function StateManager:draw()
    if self.currentState and self.currentState.draw then
        self.currentState:draw()
    end
end

return StateManager
