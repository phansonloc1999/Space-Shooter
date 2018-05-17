Class = require('src/class')

require('src/player')
require('src/util')

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

function love.load()
    player = Player()
    player:init()
end

function love.draw()
    player:render()
    LOG(player.bullet.cooldownTimer)
end

function love.update(dt)
    player:update(dt)

    -- flush keys pressed table
    love.keyboard.keysPressed = {}
end