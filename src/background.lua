Background = Class{}

function Background:init()
    self.img = love.graphics.newImage('Graphics/background.png')
    self.width, self.height = self.img:getDimensions()
end

function Background:render()
    local sx, sy = WINDOW_WIDTH / self.width, WINDOW_HEIGHT / self.height
    love.graphics.draw(self.img, 0, 0, 0, sx, sy)
end

function Background:update(dt)
end